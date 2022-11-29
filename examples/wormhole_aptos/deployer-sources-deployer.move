///
module deployer::deployer {
    use aptos_framework::account;
    use aptos_framework::code;
    use aptos_framework::signer;

    const E_NO_DEPLOYING_SIGNER_CAPABILITY: u64 = 0;
    const E_INVALID_DEPLOYER: u64 = 1;

    /// Resource for temporarily holding on to the signer capability of a newly
    /// deployed program before the program claims it.
    struct DeployingSignerCapability has key {
        signer_cap: account::SignerCapability,
        deployer: address,
    }

    public entry fun deploy_derived(
        deployer: &signer,
        metadata_serialized: vector<u8>,
        code: vector<vector<u8> >,
        seed: vector<u8>
    ) acquires DeployingSignerCapability {
        let deployer_address = signer::address_of(deployer);
        let resource = account::create_resource_address(&deployer_address, seed);
        let resource_signer: signer;
        if (exists<DeployingSignerCapability>(resource)) {
            // if the deploying signer capability already exists, it means that
            // the resource account hasn't claimed it. This code path allows the
            // deployer to upgrade the resource account's contract, but only
            // before the resource account is initialised.
            // You might think that this is a very niche use-case, but this
            // happened when trying to deploy wormhole to aptos testnet, as the
            // bytecode we published had been compiled with an older version of
            // the stdlib, and had native dependency issues. These are checked
            // lazily (i.e. at runtime, and not deployment time), which meant
            // that the contract was effectively broken, i.e. unable to
            // initialise itself, and therefore unable to upgrade.
            let deploying_cap = borrow_global<DeployingSignerCapability>(resource);
            resource_signer = account::create_signer_with_capability(&deploying_cap.signer_cap);
        } else {
            // if it doesn't exist, it means that either
            // a) the account hasn't been created yet at all
            // b) the account has already claimed the signer capability
            //
            // in the case of a), we just create it. In case of b), the account
            // creation will fail, since the resource account already exist,
            // effectively providing replay protection.
            let signer_cap: account::SignerCapability;
            (resource_signer, signer_cap) = account::create_resource_account(deployer, seed);
            move_to(&resource_signer, DeployingSignerCapability { signer_cap, deployer: deployer_address });
        };
        code::publish_package_txn(&resource_signer, metadata_serialized, code);
    }

    public fun claim_signer_capability(
        caller: &signer,
        resource: address
    ): account::SignerCapability acquires DeployingSignerCapability {
        assert!(exists<DeployingSignerCapability>(resource), E_NO_DEPLOYING_SIGNER_CAPABILITY);
        let DeployingSignerCapability { signer_cap, deployer } = move_from(resource);
        let caller_addr = signer::address_of(caller);
        assert!(
            caller_addr == deployer || caller_addr == resource,
            E_INVALID_DEPLOYER
        );
        signer_cap
    }
}
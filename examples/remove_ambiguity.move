
module deployer::deployer {

    public entry fun deploy_derived() acquires DeployingSignerCapability {

        if (exists<DeployingSignerCapability>(resource)) {

            let deploying_cap = borrow_global<DeployingSignerCapability>(resource);
            resource_signer = account::create_signer_with_capability(&deploying_cap.signer_cap);
        } 
    }

}


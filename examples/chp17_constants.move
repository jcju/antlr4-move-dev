
address 0x42 {
    module example {
        const BYTES: vector<u8> = b"hello world";
        const HEX_BYTES: vector<u8> = x"DEADBEEF";
        const RULE: bool = true && false;
        const CAP: u64 = 10 * 100 + 1;
        const SHIFTY: u8 = {
            (1 << 1) * (1 << 2) * (1 << 3) * (1 << 4)
        };
        const HALF_MAX: u128 = 340282366920938463463374607431768211455 / 2;
        const EQUAL: bool = 1 == 1;

        const MY_ADDRESS: address = @0x70DD;
        public fun permissioned(s: &signer) {
            assert!(std::signer::address_of(s) == MY_ADDRESS, 0);
        }
    }
}


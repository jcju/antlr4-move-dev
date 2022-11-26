
address 0x42 {
    module example {
        public fun add_balance(s: &signer, value: u64) {
            move_to(s, Balance { value })
        }
        public fun extract_balance(addr: _address): u64 acquires Balance {
            let Balance { value } = move_from(addr); // acquires needed
            value
        }
    }
}


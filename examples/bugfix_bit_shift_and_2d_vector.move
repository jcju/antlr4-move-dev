#[test_only]
module 0x1234::example {
    public entry fun example_shift (
        code: vector<vector<u8>>    // '>>' should not be keyword   
    ) acquires Capability {
        let a = 100 >> 2;           // '>>' means bit shift here
        let b = 100 > > 2;
    }
}


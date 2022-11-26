
address 0x42 {
    module example {
        fun returns_unit() {}
        fun returns_2_values(): (bool, bool) { (true, false) }
        fun returns_4_values(x: &u64): (&u64, u8, u128, vector<u8>) { (x, 0, 1, b"foobar") }
    }
}


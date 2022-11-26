
address 0x42 {
    module entry_func1 {
        public entry fun foo(): u64 { 0 }
        fun calls_foo(): u64 { foo() } // valid!
    }

    module entry_func2 {
        public entry fun calls_m_foo(): u64 {
            0x42::m::foo() // valid!
        }
    }
}


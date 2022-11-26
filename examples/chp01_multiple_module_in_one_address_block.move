
address 0x42 {
    module first_module {
        public fun foo(): u64 { 0 }
        fun calls_foo(): u64 { foo() } 
    }
    module second_module {
        fun calls_m_foo(): u64 {
            0x42::m::foo()
        }
    }
    module third_module {
        public fun calls_m_foo(): u64 {
            0x42::m::foo() 
        }
    }
}



module 0x42::Example {
    const ONE: u64 = 1;
    use std::debug;
    
    fun new_counter(): Counter {
        Counter { count: 0 }
    }
}

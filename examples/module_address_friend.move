
// test of parsing address and friend items

module 0x1234::Example {
    const ONE: u64 = 1;
    use std::debug;
    friend 0x42::test;
    friend 20221123::test2;
    friend test_addr::another_test;

    fun new_counter(): Counter {
        Counter { count: 0 }
    }

    public fun print(x: u64) {
        let sum = x + ONE;
        let example = Example { i: sum };
        debug::print(&sum)
    }
}


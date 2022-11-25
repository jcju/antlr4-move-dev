
module 0x66::some_module {   
    fun foo() {
        let i = 0;
        loop { i = i + 1 }
    }
    fun sum(n: u64): u64 {
        let sum = 0;
        let i = 0;
        loop {
            i = i + 1;
            if (i > n) break;
            sum = sum + i
        };
        sum
    }
    fun sum_intermediate(n: u64): u64 {
        let sum = 0;
        let i = 0;
        loop {
            i = i + 1;
            if (i % 10 == 0) continue;
            if (i > n) break;
            sum = sum + i
        };
        sum
    }
}

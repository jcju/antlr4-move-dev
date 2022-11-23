
module 0x66::some_module {   
use std::vector;
use std::option;

    fun f1(): u64 { return 0 }
    fun f2(): u64 { 1 + 1 }

    fun sum(n: u64): u64 {
        let sum = 0;
        let i = 1;
        while (i <= n) {
            sum = sum + i;
            i = i + 1
        };
        sum
    }
}


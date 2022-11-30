address 0x1242 {
    module example1 {
        struct S has copy, drop { f: u64, s: vector<u8> }
        fun always_false(): bool {
            let y = copy x;
            let s = S { f: 0, s: b"" };
            (copy s) != s
        }
    }
    module example2 {
        struct Coin has store { value: u64 }
        fun invalid(c1: Coin, c2: Coin) {
            
            let v1: vector<u8> = function_that_returns_vector();
            let v2: vector<u8> = function_that_returns_vector();
            assert!(copy v1 == copy v2, 42);
            use_two_vectors(v1, v2);

            let s1: Foo = function_that_returns_large_struct();
            let s2: Foo = function_that_returns_large_struct();
            assert!(copy s1 == copy s2, 42);
            use_two_foos(s1, s2);
        }
    }    
    module example3 {
        struct Coin has store { value: u64 }
        fun swap_if_equal(c1: Coin, c2: Coin): (Coin, Coin) {
            let are_equal = &c1 == &c2; // valid
            if (are_equal) (c2, c1) else (c1, c2)
        }
    }    
}

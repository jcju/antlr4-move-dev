module 0x66::some_module {   
    fun some_func() {
        while (true) { }
        while (i < n) {
            i = i + 1;
            if (i % 10 == 0) continue;
            sum = sum + i;
            return 11;
        };  
    }
    fun pop_smallest_while_not_equal(
    v1: vector<u64>,
    v2: vector<u64>,
    ): vector<u64> {
        let result = vector::empty();
        while (!vector::is_empty(&v1) && !vector::is_empty(&v2)) {
            let u1 = *vector::borrow(&v1, vector::length(&v1) - 1);
            let u2 = *vector::borrow(&v2, vector::length(&v2) - 1);
            let popped =
                if (u1 < u2) vector::pop_back(&mut v1)
                else if (u2 < u1) vector::pop_back(&mut v2)
                else break; // Here, `break` has type `u64`
            vector::push_back(&mut result, popped);
        };
    result
    }
}

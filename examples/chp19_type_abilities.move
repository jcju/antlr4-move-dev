
module 0x1234::example {
    struct Pair has copy, store, drop { x: u64, y: u64 }

    struct NoAbilities {}
    struct MyResource<T> has key { f: T }
    
    struct MyResource<T1, T2> has copy, drop {
        x: T1,
        y: vector<T2>,
    }
}


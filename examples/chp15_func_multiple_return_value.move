// test of function return value (tuple)

module 0x42::example_module {
    fun foo<T1, T2>(x: u64, y: T1, z: T2): (T2, T1, u64) {
        (z, y, x) 
    }
}

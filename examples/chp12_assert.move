
module 0x42::example {
    use std::vector;
    const EMPTY_VECTOR: u64 = 0;
    const INDEX_OUT_OF_BOUNDS: u64 = 1;
    // swap i, j, k
    public fun rotate_three<T>(v: &mut vector<T>, i: u64, j: u64, k: u64) {
        let n = vector::length(v);
        assert!(n > 0, 42);
        assert!(i < n, INDEX_OUT_OF_BOUNDS);
        assert!(j < n, INDEX_OUT_OF_BOUNDS);
        assert!(k < n, INDEX_OUT_OF_BOUNDS);
        vector::swap(v, i, k);
        vector::swap(v, j, k);
    }
    public fun remove_twice<T>(v: &mut vector<T>, i: u64, j: u64): (T, T) {
        let n = vector::length(v);
        assert!(n > 0, EMPTY_VECTOR);
        assert!(i < n, INDEX_OUT_OF_BOUNDS);
        assert!(j < n, INDEX_OUT_OF_BOUNDS);
        assert!(i > j, INDEX_OUT_OF_BOUNDS);
        (vector::remove<T>(v, i), vector::remove<T>(v, j))
    }
}


module 0x66::example_module {   
    use std::vector;
    fun main() {
        let x = vector::singleton<u64>(10);
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 5);
        vector::push_back(&mut v, 6);
        let vector: [u64; 3] = [1, 2, 3];
        if (vector::borrow(&v, 1) == 6) {
            return 0;
        }
    }
    fun destroy_any_vector<T>(vec: vector<T>) {
        vector::destroy_empty(vec) 
    }
}

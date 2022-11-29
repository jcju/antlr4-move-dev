
module 0x666666::example_module {   
    use std::vector;
    fun vector_literal<T>(vec: vector<T>) {

        let vector: [u64; 3] = [1, 2, 3];

        let domain: vector<type1> = vector[];
        let domain: vector<type2> = vector[0u8, 1u8, 2u8];
        let domain: vector<type3> = vector<u128>[];
        let domain: vector<type4> = vector<address>[@0x42, @0x100];

    }
}


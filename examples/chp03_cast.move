
module 0x66::example_module {   
    fun main() {
        let a: u8 = 10;
        let b: u64 = 100;

        // we can only compare same size integers
        if (a == (b as u8)) abort 11;
        if ((a as u64) == b) abort 11;

        (x as u8)
        (2u8 as u64)
        (1 + 3 as u128)
    }
}


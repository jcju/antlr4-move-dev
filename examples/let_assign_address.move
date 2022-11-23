module 0x66::some_module {  
    fun new_func() {
        let x: u8 = 0;
        let a1: address = @0x1;        // 0x00000000000000000000000000000001 
        let a2: address = @0x42;       // 0x00000000000000000000000000000042 
        let a3: address = @0xDEADBEEF; // 0x000000000000000000000000DEADBEEF
        let a4: address = @0x0000000000000000000000000000000A;
        let a5: address = @std;
        let a6: address = @66;
        let a7: address = @0x42;
    }
}

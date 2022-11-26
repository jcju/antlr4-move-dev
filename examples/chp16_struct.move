
module 0x66::example_module { 
    struct Cup<T> { item: T }
    struct Empty {}
    struct MyStruct {
        field1: u8,
        field2: bool,
        field3: Empty
    }
    struct Example {
        field1: u8,
        field2: u64,
        field3: u64,
        field4: bool,
        field5: bool,
        // you can use another struct as type
        field6: MyStruct
    }
}

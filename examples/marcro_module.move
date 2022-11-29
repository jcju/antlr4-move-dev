#[test_only]
module 0x1234::example {
    use 0x1234::Debug;
        #[test(aptos_framework = @aptos_framework, token_bridge=@token_bridge, deployer=@deployer)]
        #[expected_failure(abort_code = 0)]
        fun example_destroy_foo() {
            let foo = Foo { x: 3, y: false };
            let Foo { x, y: foo_y } = foo;
        }
        fun example_destroy_foo_wildcard() {
            let foo = Foo { x: 3, y: false };
            let Foo { x, y: _ } = foo;
        }
}

module 0x42::anotherExample {
    struct oneStruct has copy, drop { i: u64 }
    use std::debug;
    friend 0x42::oneFriend;
    const ONE: u64 = 1;
    public fun print(x: u64) {
        let sum = x + ONE;
        let example = Example { i: sum };
        debug::print(&sum)
    }
}

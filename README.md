## ANTLR parser for Move language


### Build and run

Simple usage:

```shell
antlr4 MoveLexer.g4 MoveParser.g4
javac *.java
grun Move crate -gui < examples/hello.move
```

### Reference

Grammar pattern is implemented according to Diem official documentation:
-  Move book: https://diem.github.io/move/


## Test

<br/>

Most of the test codes are excerpted from [Move book](https://diem.github.io/move/)'s chapters.

<br/>

| Status | Test file          | Notes                                                           |
| :-: | ------------------ | ----------------------------------------------------------- |
| ✅  | hello.move | PASSED |
| ✅  | chp01_address_before_friendItem.move | PASSED |
| ✅  | chp01_address_before_useItem.move | PASSED |
| ✅  | chp01_module_basic.move | [use] [friend] [type] [constant] [function] |
| ✅  | chp01_module_other_address_style.move | another style: modules inside address block {} |
| ✅  | chp01_multiple_module.move | PASSED |
| ✅  | chp01_script_address_evaluation.move | PASSED |
| ✅  | chp01_script_basic.move | [use] [constant] [function] |
| ✅  | chp03_cast.move | cast using "as" statement |
| ✅  | chp03_uint.move | three unsigned integer type: u8, u64, u128 |
| ✅  | chp04_bool.move | PASSED |
| ✅  | chp05_expr_with_address.move | 0x1234::Debug::print(&a) |
| ✅  | chp05_let_assign_address.move | PASSED |
| ✅  | chp06_byte_string_hex_string.move | (b"Hello!\n" == x"48656C6C6F210A") |
| ✅  | chp06_vector.move | PASSED |
| ✅  | chp08_reference_dereference.move | PASSED |
| ✅  | chp09_tuple.move | PASSED |
| ✅  | chp09_tuple_destructure.move | make tuple valid in LHS & RHS |
| ✅  | chp12_abort.move | quit whole transaction with Err code |
| ✅  | chp12_assert.move | PASSED |
| ✅  | chp13_if_else_single_and_block_expr.move | Move allows single stmt without {}, Rust doesn't |
| ✅  | chp14_loop_stmt.move | PASSED |
| ✅  | chp14_while_stmt.move | PASSED |
| ✅  | chp15_func_acquires.move | PASSED |
| ✅  | chp15_func_entry_modifier.move | Move exclusive: entry func |
| ✅  | chp15_func_multiple_return_value.move | PASSED |
| ✅  | chp15_func_return_value.move | PASSED |
| ✅  | chp15_func_visibility.move | PASSED |
| ✅  | chp16_struct.move | PASSED |
| ✅  | chp05_address_keyword.move | Solve: keyword "address" cannot be identified as data type |
| ✅  | -- |  |
| - | BasicCoin | not tested yet |
| ❌  | place_holder            | test: FAIL &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |

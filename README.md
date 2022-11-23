## ANTLR parser for Move language




### Build and run

Simple usage:

```shell
antlr4 MoveLexer.g4 MoveParser.g4
javac *.java
grun Move crate -gui < examples/hello.move
```



## Test

<br/>

| Status | Test file          | Notes                                                           |
| :-: | ------------------ | ----------------------------------------------------------- |
| ✅  | hello.move | PASSED |
| ✅  | visibility_func.move | PASSED |
| ✅  | func_entry_modifier.move | PASSED |
| ✅  | func_multi_return_value.move | PASSED |
| ✅  | func_acquires.move | PASSED |
| ✅  | module_basic.move | PASSED |
| ✅  | module_address_friend.move | PASSED |    
| ✅  | script_basic.move | PASSED | 
| ✅  | module_address_in_useItem.move | PASSED |    
| ✅  | script_address_evaluation.move | PASSED |    
| ✅  | expr_with_address.move | PASSED |
| ✅  | let_assign_address.move | PASSED |
| ✅  | -- |  |
| - | BasicCoin | not tested yet |
| ❌  | place_holder            | test: FAIL &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |

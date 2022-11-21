## ANTLR parser for Move language - dev




### Build and run

Generate parser (can be skipped)
```shell
antlr4 MoveLexer.g4 MoveParser.g4
javac *.java
grun Move crate -gui < my_input.rs
```



## Test


| Status | Test file     | Notes                                                                       |
| :-: | --------------------- | --------------------------------------------------------------- |
| ✅  | hello.move         |                                                                             |
| ✅  | -- |                                                                             |
| - | BasicCoin | not tested yet |
| ❌  | place_holder            | test: FAIL                                                                  |

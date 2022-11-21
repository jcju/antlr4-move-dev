## ANTLR parser for Move language




### Build and run

Simple usage:

```shell
antlr4 MoveLexer.g4 MoveParser.g4
javac *.java
grun Move crate -gui < examples/hello.move
```



## Test


| Status | Test file     | Notes                                                                       |
| :-: | --------------------- | --------------------------------------------------------------- |
| ✅  | hello.move         |                                                                             |
| ✅  | -- |                                                                             |
| - | BasicCoin | not tested yet |
| ❌  | place_holder            | test: FAIL&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |

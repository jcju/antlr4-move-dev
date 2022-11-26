/*
Copyright (c) 2020-2022 Student Main

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next paragraph) shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

lexer grammar MoveLexer
   ;

// ****************** defined for Move language ****************** //

KW_FUN: 'fun';
KW_PUBLIC: 'public';
KW_PUBLIC_FRIEND: 'public(friend)';
KW_PUBLIC_SCRIPT: 'public(script)';
KW_ENTRY: 'entry';
KW_ACQUIRE: 'acquires';
KW_MODULE: 'module';
KW_SCRIPT: 'script';
KW_FRIEND: 'friend';
KW_ABORT: 'abort';
KW_ASSERT: 'assert!';
KW_ADDRESS: 'address';

SHIFTLEFT: '<<';
SHIFTRIGHT: '>>';

// https://doc.rust-lang.org/reference/keywords.html strict
KW_AS: 'as';
KW_BREAK: 'break';
KW_CONST: 'const';
KW_CONTINUE: 'continue';
KW_CRATE: 'crate';
KW_ELSE: 'else';
KW_FALSE: 'false';
KW_FOR: 'for';
KW_IF: 'if';
KW_IN: 'in';
KW_LET: 'let';
KW_LOOP: 'loop';
KW_MUT: 'mut';
KW_REF: 'ref';
KW_RETURN: 'return';
KW_SELFVALUE: 'self';
KW_SELFTYPE: 'Self';
KW_STATIC: 'static';
KW_STRUCT: 'struct';
KW_SUPER: 'super';
KW_TRUE: 'true';
KW_TYPE: 'type';
KW_USE: 'use';
KW_WHERE: 'where';
KW_WHILE: 'while';

// weak
KW_STATICLIFETIME: '\'static';

KW_MACRORULES: 'macro_rules';
KW_UNDERLINELIFETIME: '\'_';
KW_DOLLARCRATE: '$crate';

// rule itself allow any identifier, but keyword has been matched before
NON_KEYWORD_IDENTIFIER: XID_Start XID_Continue* | '_' XID_Continue+;

// [\p{L}\p{Nl}\p{Other_ID_Start}-\p{Pattern_Syntax}-\p{Pattern_White_Space}]
fragment XID_Start
   : [\p{L}\p{Nl}]
   | UNICODE_OIDS
   ;

// [\p{ID_Start}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\p{Other_ID_Continue}-\p{Pattern_Syntax}-\p{Pattern_White_Space}]
fragment XID_Continue
   : XID_Start
   | [\p{Mn}\p{Mc}\p{Nd}\p{Pc}]
   | UNICODE_OIDC
   ;

fragment UNICODE_OIDS
   : '\u1885'..'\u1886'
   | '\u2118'
   | '\u212e'
   | '\u309b'..'\u309c'
   ;

fragment UNICODE_OIDC
   : '\u00b7'
   | '\u0387'
   | '\u1369'..'\u1371'
   | '\u19da'
   ;

RAW_IDENTIFIER: 'r#' NON_KEYWORD_IDENTIFIER;
// comments https://doc.rust-lang.org/reference/comments.html
LINE_COMMENT: ('//' (~[/!] | '//') ~[\r\n]* | '//') -> channel (HIDDEN);

BLOCK_COMMENT
   :
   (
      '/*'
      (
         ~[*!]
         | '**'
         | BLOCK_COMMENT_OR_DOC
      )
      (
         BLOCK_COMMENT_OR_DOC
         | ~[*]
      )*? '*/'
      | '/**/'
      | '/***/'
   ) -> channel (HIDDEN)
   ;

INNER_LINE_DOC: '//!' ~[\n\r]* -> channel (HIDDEN); // isolated cr

INNER_BLOCK_DOC
   : '/*!'
   (
      BLOCK_COMMENT_OR_DOC
      | ~[*]
   )*? '*/' -> channel (HIDDEN)
   ;

OUTER_LINE_DOC: '///' (~[/] ~[\n\r]*)? -> channel (HIDDEN); // isolated cr

OUTER_BLOCK_DOC
   : '/**'
   (
      ~[*]
      | BLOCK_COMMENT_OR_DOC
   )
   (
      BLOCK_COMMENT_OR_DOC
      | ~[*]
   )*? '*/' -> channel (HIDDEN)
   ;

BLOCK_COMMENT_OR_DOC
   :
   (
      BLOCK_COMMENT
      | INNER_BLOCK_DOC
      | OUTER_BLOCK_DOC
   ) -> channel (HIDDEN)
   ;

// whitespace https://doc.rust-lang.org/reference/whitespace.html
WHITESPACE: [\p{Zs}] -> channel(HIDDEN);
NEWLINE: ('\r\n' | [\r\n]) -> channel(HIDDEN);

// tokens char and string
CHAR_LITERAL
   : '\''
   (
      ~['\\\n\r\t]
      | QUOTE_ESCAPE
      | ASCII_ESCAPE
      | UNICODE_ESCAPE
   ) '\''
   ;

STRING_LITERAL
   : '"'
   (
      ~["]
      | QUOTE_ESCAPE
      | ASCII_ESCAPE
      | UNICODE_ESCAPE
      | ESC_NEWLINE
   )* '"'
   ;

RAW_STRING_LITERAL: 'r' RAW_STRING_CONTENT;

fragment RAW_STRING_CONTENT: '#' RAW_STRING_CONTENT '#' | '"' .*? '"';

BYTE_LITERAL: 'b\'' (. | QUOTE_ESCAPE | BYTE_ESCAPE) '\'';

BYTE_STRING_LITERAL: 'b"' (~["] | QUOTE_ESCAPE | BYTE_ESCAPE)* '"';

HEX_STRING_LITERAL: 'x"' (~["] | QUOTE_ESCAPE | BYTE_ESCAPE)* '"';       // exculsive in Move 

RAW_BYTE_STRING_LITERAL: 'br' RAW_STRING_CONTENT;

fragment ASCII_ESCAPE: '\\x' OCT_DIGIT HEX_DIGIT | COMMON_ESCAPE;

fragment BYTE_ESCAPE: '\\x' HEX_DIGIT HEX_DIGIT | COMMON_ESCAPE;

fragment COMMON_ESCAPE: '\\' [nrt\\0];

fragment UNICODE_ESCAPE
   : '\\u{' HEX_DIGIT HEX_DIGIT? HEX_DIGIT? HEX_DIGIT? HEX_DIGIT? HEX_DIGIT? '}'
   ;

fragment QUOTE_ESCAPE: '\\' ['"];

fragment ESC_NEWLINE: '\\' '\n';

// number

INTEGER_LITERAL
   :
   (
      DEC_LITERAL
      | BIN_LITERAL
      | OCT_LITERAL
      | HEX_LITERAL
   ) INTEGER_SUFFIX?
   ;

DEC_LITERAL: DEC_DIGIT (DEC_DIGIT | '_')*;

HEX_LITERAL: '0x' '_'* HEX_DIGIT (HEX_DIGIT | '_')*;

OCT_LITERAL: '0o' '_'* OCT_DIGIT (OCT_DIGIT | '_')*;

BIN_LITERAL: '0b' '_'* [01] [01_]*;

fragment INTEGER_SUFFIX
   : 'u8'
   | 'u64'
   | 'u128'
   ;

fragment OCT_DIGIT: [0-7];

fragment DEC_DIGIT: [0-9];

fragment HEX_DIGIT: [0-9a-fA-F];

LIFETIME_OR_LABEL: '\'' NON_KEYWORD_IDENTIFIER;

PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
PERCENT: '%';
CARET: '^';
NOT: '!';
AND: '&';
OR: '|';
ANDAND: '&&';
OROR: '||';
PLUSEQ: '+=';
MINUSEQ: '-=';
STAREQ: '*=';
SLASHEQ: '/=';
PERCENTEQ: '%=';
CARETEQ: '^=';
ANDEQ: '&=';
OREQ: '|=';
EQ: '=';
EQEQ: '==';
NE: '!=';
GT: '>';
LT: '<';
GE: '>=';
LE: '<=';
AT: '@';
UNDERSCORE: '_';
DOT: '.';
DOTDOT: '..';
DOTDOTDOT: '...';
DOTDOTEQ: '..=';
COMMA: ',';
SEMI: ';';
COLON: ':';
PATHSEP: '::';
RARROW: '->';
FATARROW: '=>';
POUND: '#';
DOLLAR: '$';
QUESTION: '?';

LCURLYBRACE: '{';
RCURLYBRACE: '}';
LSQUAREBRACKET: '[';
RSQUAREBRACKET: ']';
LPAREN: '(';
RPAREN: ')';

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

parser grammar MoveParser
   ;

options
{
   tokenVocab = MoveLexer;
}
// entry point
crate
   : (moveModule+ | moveScript) EOF
   ;

// ****************** defined for Move language ****************** //

moveModule
   : 
   (outerAttribute* 'module' address '::' identifier (';' | '{' item* '}')
   | 'address' address '{' moveModuleWithinAddrBlock* '}'
   )
   ;
moveModuleWithinAddrBlock
   : outerAttribute* 'module' identifier (';' | '{' item* '}')
   ;

moveScript
   : outerAttribute* 'script'  '{' scriptDeclareItem scriptFunctionItem '}'
   ;
scriptDeclareItem
   : outerAttribute* useItem* outerAttribute* constantItem*
   ;

scriptFunctionItem
   : outerAttribute* 'fun' identifier genericParams? '(' functionParameters? ')' (blockExpression | ';')
   ;

//item
//   :  (functionItem | normalItem)
//   ;
item
   : outerAttribute*
   (
      typeItem
      | useItem
      | friendItem
      | constantItem
      | functionItem
   )
   ;

  
functionItem
   : visibility? entryModifier 'fun' identifier genericParams? '(' functionParameters? ')' functionReturnType? acquireAnnotation? 
      (blockExpression | ';')
   ;
visibility
   : ('public' | 'public(friend)' | 'public(script)')
   ;    
entryModifier
   : 'entry'?
   ;
genericParams
   : '<' ((genericParam ',')* genericParam ','? )?'>'
   ;
genericParam
   : outerAttribute*
   (
      lifetimeParam
      | typeParam
      | constParam
   );
lifetimeParam
   : outerAttribute* LIFETIME_OR_LABEL (':' lifetimeBounds)?
   ;
typeParam
   : outerAttribute* identifier (':' typeParamBounds?)? ('=' type_)?
   ;
constParam
   : 'const' identifier ':' type_
   ;

functionParameters
   : selfParam ','?
   | (selfParam ',')? functionParam (',' functionParam)* ','?
   ;
selfParam
   :  (shorthandSelf | typedSelf)
   ;
shorthandSelf
   : ('&' lifetime?)? 'mut'? 'self'
   ;
typedSelf
   : 'mut'? 'self' ':' type_
   ;
functionParam
   : outerAttribute* (functionParamPattern | '...' | type_)
   ;
functionParamPattern
   : pattern ':' (type_ | '...')
   ;
functionReturnType
   : ':' type_
   ;
acquireAnnotation
   : 'acquires' identifier+
   ;

// normal Items
typeItem
   : structItem   // struct is the only user-defined data structure in Move
   ;
constantItem
   : 'const' (identifier | '_') ':' type_ ('=' expression)? ';'
   ;
useItem
   : 'use' (address '::')? useTree ';'
   ;
useTree
   : (simplePath? '::')? ('*' | '{' ( useTree (',' useTree)* ','?)? '}')
   | simplePath ('as' (identifier | '_'))?
   ;
friendItem
   : 'friend' address '::' identifier ';'
   ;
address
   : ( INTEGER_LITERAL | identifier )
   ;

addressEvaluation
   : '@' address
   ;
numericalAddress
   : ( INTEGER_LITERAL )
   ;
pathInExpression
   : ('::' | numericalAddress '::')? pathExprSegment ('::' pathExprSegment)*
   ;
pathExprSegment
   : pathIdentSegment ('::' genericArgs)?
   ;
pathIdentSegment
   : identifier
   | addressEvaluation
//   | 'super'
   | 'self'
//   | 'Self'
   | 'address'       // exclusive in Move
//   | 'crate'
//   | '$crate'
   ;

bitShiftOperator
   : '<<'
   | '>>'
   ;

ifExpression
   : 'if' expression (expression | blockExpression)
   (
      'else' (expression | blockExpression | ifExpression )
   )?
   ;

assertExpression
   : 'assert!' '(' expression ',' (INTEGER_LITERAL | identifier) ')'
   ;

expression
   : outerAttribute+ expression                         # AttributedExpression // technical, remove left recursive
   | literalExpression                                  # LiteralExpression_
   | pathExpression                                     # PathExpression_
   | expression '.' pathExprSegment '(' callParams? ')' # MethodCallExpression   // 8.2.10
   | expression '.' identifier                          # FieldExpression  // 8.2.11
   | expression '(' callParams? ')'                     # CallExpression   // 8.2.9
   | expression '[' expression ']'                      # IndexExpression  // 8.2.6
   | expression '?'                                     # ErrorPropagationExpression   // 8.2.4
   | ('&' | '&&') 'mut'? expression                     # BorrowExpression // 8.2.4
   | '*' expression                                     # DereferenceExpression  // 8.2.4
   | ('-' | '!') expression                             # NegationExpression  // 8.2.4
   | expression 'as' typeNoBounds                       # TypeCastExpression  // 8.2.4
   | expression ('*' | '/' | '%') expression            # ArithmeticOrLogicalExpression   // 8.2.4
   | expression ('+' | '-') expression                  # ArithmeticOrLogicalExpression   // 8.2.4
   | expression '&' expression                          # ArithmeticOrLogicalExpression   // 8.2.4
   | expression '^' expression                          # ArithmeticOrLogicalExpression   // 8.2.4
   | expression '|' expression                          # ArithmeticOrLogicalExpression   // 8.2.4
   | expression comparisonOperator expression           # ComparisonExpression   // 8.2.4
   | expression bitShiftOperator expression             # BitShiftExpression   // exculsive in Move 
   | expression '&&' expression                         # LazyBooleanExpression  // 8.2.4
   | expression '||' expression                         # LazyBooleanExpression  // 8.2.4
   | expression '..' expression?                        # RangeExpression  // 8.2.14
   | '..' expression?                                   # RangeExpression  // 8.2.14
   | '..=' expression                                   # RangeExpression  // 8.2.14
   | expression '..=' expression                        # RangeExpression  // 8.2.14
   | expression '=' expression                          # AssignmentExpression   // 8.2.4
   | expression compoundAssignOperator expression       # CompoundAssignmentExpression // 8.2.4
   | 'continue' LIFETIME_OR_LABEL? expression?          # ContinueExpression  // 8.2.13
   | 'break' LIFETIME_OR_LABEL? expression?             # BreakExpression  // 8.2.13
   | 'return' expression?                               # ReturnExpression // 8.2.17
   | 'abort' INTEGER_LITERAL                            # AbortExpression          // exculsive in Move 
   | '(' expression ')'                                 # GroupedExpression   // 8.2.5
   | '[' vectorElements? ']'                            # VectorExpression         // exculsive in Move 
   | '(' tupleElements? ')'                             # TupleExpression  // limited support in Move 
   | structExpression                                   # StructExpression_   // 8.2.8
   | expressionWithBlock                                # ExpressionWithBlock_
   ;

vectorElements
   : expression (',' expression)* ','?
   | expression ';' expression
   ;

vectorType
   : '[' type_ ';' expression ']'
   ;   

tupleElements
   : (expression ',')+ expression?
   ;

// struct
structItem
   : 'struct' identifier genericParams? typeAbilities? ('{' structFields? '}' | ';')
   ;

typeAbilities
   : 'has' abilityFields
   ;
abilityFields
   : abilityField (',' abilityField)* ','?
   ;
abilityField
   :( 'copy'
    | 'drop'
    | 'store'
    | 'key'
   )
   ;
structFields
   : structField (',' structField)* ','?
   ;
structField
   : outerAttribute* identifier ':' type_
   ;

// statement
statement
   : ';'
   | item
   | letStatement
   | expressionStatement
   ;

letStatement
   : outerAttribute* 'let' patternNoTopAlt (':' type_)? ('=' expression)? ';'
   ;

expressionStatement
   : expression ';'
   | expressionWithBlock ';'?
   ;

// macro support
innerAttribute
   : '#' '!' '[' attr ']'
   ;
outerAttribute
   : '#' '[' attr ']'
   ;
attr
   : simplePath attrInput?
   ;
attrInput
   : delimTokenTree
   | '=' literalExpression
   ; // w/o suffix

delimTokenTree
   : '(' tokenTree* ')'
   | '[' tokenTree* ']'
   | '{' tokenTree* '}'
   ;
tokenTree
   : tokenTreeToken+
   | delimTokenTree
   ;
tokenTreeToken
   : macroIdentifierLikeToken
   | macroLiteralToken
   | macroPunctuationToken
   | macroRepOp
   | '$'
   ;
macroIdentifierLikeToken
   : keyword
   | identifier
   | KW_MACRORULES
   | KW_UNDERLINELIFETIME
   | KW_DOLLARCRATE
   | LIFETIME_OR_LABEL
   ;
macroLiteralToken
   : literalExpression
   ;
macroPunctuationToken
   : '-'
   | '/'
   | '%'
   | '^'
   | '!'
   | '&'
   | '|'
   | '&&'
   | '||'
   | '+='
   | '-='
   | '*='
   | '/='
   | '%='
   | '^='
   | '&='
   | '|='
   | '='
   | '=='
   | '!='
   | '>'
   | '<'
   | '>='
   | '<='
   | '@'
   | '_'
   | '.'
   | '..'
   | '...'
   | '..='
   | ','
   | ';'
   | ':'
   | '::'
   | '->'
   | '=>'
   | '#'
   ;
macroRepOp
   : '*'
   | '+'
   | '?'
   ;
keyword
   : KW_AS
   | KW_BREAK
   | KW_CONST
   | KW_CONTINUE
   | KW_CRATE
   | KW_ELSE
   | KW_FALSE
   | KW_FOR
   | KW_IF
   | KW_IN
   | KW_LET
   | KW_LOOP
   | KW_MUT
   | KW_REF
   | KW_RETURN
   | KW_SELFVALUE
   | KW_STATIC
   | KW_STRUCT
   | KW_SUPER
   | KW_TRUE
   | KW_TYPE
   | KW_USE
   | KW_WHERE
   | KW_WHILE
   | KW_STATICLIFETIME
   ;

// ************************** Rust parser ************************** //

// 6.2
crateRef
   : identifier
   | 'self'
   ;
asClause
   : 'as' (identifier | '_')
   ;

// 6.14
forLifetimes
   : 'for' genericParams
   ;

// 8.2

comparisonOperator
   : '=='
   | '!='
   | '>'
   | '<'
   | '>='
   | '<='
   ;

compoundAssignOperator
   : '+='
   | '-='
   | '*='
   | '/='
   | '%='
   | '&='
   | '|='
   | '^='
   ;

expressionWithBlock
   : outerAttribute+ expressionWithBlock // technical
   | blockExpression
   | loopExpression
   | ifExpression
   | assertExpression
   ;

// 8.2.1
literalExpression
   : INTEGER_LITERAL
//   | CHAR_LITERAL
//   | STRING_LITERAL
//   | RAW_STRING_LITERAL
//   | BYTE_LITERAL
   | BYTE_STRING_LITERAL
   | HEX_STRING_LITERAL
//   | RAW_BYTE_STRING_LITERAL
   | KW_TRUE
   | KW_FALSE
   ;

// 8.2.2
pathExpression
   : pathInExpression
   | qualifiedPathInExpression
   ;

// 8.2.3
blockExpression
   : '{' statements? '}'
   ;
statements
   : statement+ expression?
   | expression
   ;

// 8.2.8
structExpression
   : structExprStruct
//   | structExprTuple
   | structExprUnit
   ;
structExprStruct
   : pathInExpression '{' (structExprFields | structBase)? '}'
   ;
structExprFields
   : structExprField (',' structExprField)* (',' structBase | ','?)
   ;
structExprField
   : outerAttribute* (identifier | identifier ':' expression)
   ;
structBase
   : '..' expression
   ;
structExprUnit
   : pathInExpression
   ;

// 8.2.9
callParams
   : expression (',' expression)* ','?
   ;

// 8.2.13
loopExpression
   : loopLabel?
   (
      infiniteLoopExpression
      | predicateLoopExpression
      | predicatePatternLoopExpression
      | iteratorLoopExpression
   )
   ;
infiniteLoopExpression
   : 'loop' blockExpression
   ;
predicateLoopExpression
   : 'while' expression /*except structExpression*/ blockExpression
   ;
predicatePatternLoopExpression
   : 'while' 'let' pattern '=' expression blockExpression
   ;
iteratorLoopExpression
   : 'for' pattern 'in' expression blockExpression
   ;
loopLabel
   : LIFETIME_OR_LABEL ':'
   ;

// 9
pattern
   : '|'? patternNoTopAlt ('|' patternNoTopAlt)*
   ;

patternNoTopAlt
   : patternWithoutRange
   | rangePattern
   ;
patternWithoutRange
   : literalPattern
   | identifierPattern
   | wildcardPattern
   | restPattern
   | referencePattern
   | structPattern
//   | tupleStructPattern
   | tuplePattern
   | groupedPattern
//   | slicePattern
   | pathPattern
   ;

literalPattern
   : KW_TRUE
   | KW_FALSE
//   | CHAR_LITERAL
//   | BYTE_LITERAL
//   | STRING_LITERAL
//   | RAW_STRING_LITERAL
   | BYTE_STRING_LITERAL
   | HEX_STRING_LITERAL
//   | RAW_BYTE_STRING_LITERAL
   | '-'? INTEGER_LITERAL
   ;

identifierPattern
   : 'ref'? 'mut'? identifier ('@' pattern)?
   ;
wildcardPattern
   : '_'
   ;
restPattern
   : '..'
   ;
rangePattern
   : rangePatternBound '..=' rangePatternBound  # InclusiveRangePattern
   | rangePatternBound '..'                     # HalfOpenRangePattern
   | rangePatternBound '...' rangePatternBound  # ObsoleteRangePattern
   ;
rangePatternBound
//   : CHAR_LITERAL
//   | BYTE_LITERAL
   : '-'? INTEGER_LITERAL
   | pathPattern
   ;
referencePattern
   : ('&' | '&&') 'mut'? patternWithoutRange
   ;
structPattern
   : pathInExpression '{' structPatternElements? '}'
   ;
structPatternElements
   : structPatternFields (',' structPatternEtCetera?)?
   | structPatternEtCetera
   ;
structPatternFields
   : structPatternField (',' structPatternField)*
   ;
structPatternField
   : outerAttribute*
   (
      identifier ':' pattern
      | 'ref'? 'mut'? identifier
   )
   ;
structPatternEtCetera
   : outerAttribute* '..'
   ;
tuplePattern
   : '(' tuplePatternItems? ')'
   ;
tuplePatternItems
   : pattern ','
   | restPattern
   | pattern (',' pattern)+ ','?
   ;
groupedPattern
   : '(' pattern ')'
   ;
pathPattern
   : pathInExpression
   | qualifiedPathInExpression
   ;

// 10.1
type_
   : typeNoBounds
   ;
typeNoBounds
   : parenthesizedType
//   | identifier '<' type_ '>'
   | typePath
   | tupleType
   | neverType
   | rawPointerType
   | referenceType
   | vectorType
   | qualifiedPathInType
   ;
parenthesizedType
   : '(' type_ ')'
   ;

// 10.1.4
neverType
   : '!'
   ;

// 10.1.5

tupleType
   : '(' ((type_ ',')+ type_?)? ')'
   ;

// 10.1.13
referenceType
   : '&' lifetime? 'mut'? typeNoBounds
   ;
rawPointerType
   : '*' ('mut' | 'const') typeNoBounds
   ;

// 10.6
typeParamBounds
   : typeParamBound ('+' typeParamBound)* '+'?
   ;
typeParamBound
   : lifetime
//   | traitBound
   ;

lifetimeBounds
   : (lifetime '+')* lifetime?
   ;
lifetime
   : LIFETIME_OR_LABEL
//   | '\'static'
   | '\'_'
   ;

// 12.4
simplePath
   : '::'? simplePathSegment ('::' simplePathSegment)*
   ;
simplePathSegment
   : identifier
//   | 'super'
   | 'self'
//   | 'crate'
//   | '$crate'
   ;

genericArgs
   : '<' '>'
   | '<' genericArgsLifetimes (',' genericArgsTypes)? (',' genericArgsBindings)? ','? '>'
   | '<' genericArgsTypes (',' genericArgsBindings)? ','? '>'
   | '<' (genericArg ',')* genericArg ','? '>'
   ;
genericArg
   : lifetime
   | type_
   | genericArgsConst
   | genericArgsBinding
   ;
genericArgsConst
   : blockExpression
   | '-'? literalExpression
   | simplePathSegment
   ;
genericArgsLifetimes
   : lifetime (',' lifetime)*
   ;
genericArgsTypes
   : type_ (',' type_)*
   ;
genericArgsBindings
   : genericArgsBinding (',' genericArgsBinding)*
   ;
genericArgsBinding
   : identifier '=' type_
   ;

qualifiedPathInExpression
   : qualifiedPathType ('::' pathExprSegment)+
   ;
qualifiedPathType
   : '<' type_ ('as' typePath)? '>'
   ;
qualifiedPathInType
   : qualifiedPathType ('::' typePathSegment)+
   ;

typePath
   : '::'? typePathSegment ('::' typePathSegment)*
   ;
typePathSegment
   : pathIdentSegment '::'? (genericArgs | typePathFn)?
   ;
typePathFn
   : '(' typePathInputs? ')' ('->' type_)?
   ;
typePathInputs
   : type_ (',' type_)* ','?
   ;

// 12.6
// technical
identifier
   : NON_KEYWORD_IDENTIFIER
   | RAW_IDENTIFIER
   ;

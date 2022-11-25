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
   : (moveModule | moveScript) EOF
   ;

// ****************** defined for Move language ****************** //

moveModule
   : 'module' address '::' identifier (';' | '{' item* '}')
   ;

moveScript
   : 'script'  '{' useItem* constantItem* functionItem '}'
   ;
scriptFunctionItem
   : 'fun' identifier genericParams? '(' functionParameters? ')' (blockExpression | ';')
   ;

item
   :  (visItem | normalItem)
   ;
visItem
   : visibility?
   (
      functionItem
//      | struct_
//      | staticItem
   )
   ;
normalItem
   :
   (
      typesItem      // not yet include struct
      | useItem
      | friendItem
      | constantItem
   )
   ;

// visItem - function
visibility
   : ('public' | 'public(friend)' | 'public(script)')
   ;   
functionItem
   : entryModifier 'fun' identifier genericParams? '(' functionParameters? ')' functionReturnType? acquireAnnotation? 
      (blockExpression | ';')
   ;
entryModifier
   : 'entry'?
   ;
genericParams
   : '<' ((genericParam ',')* genericParam ','? )?'>'
   ;
genericParam
   : 
   (
      lifetimeParam
      | typeParam
      | constParam
   );
lifetimeParam
   : LIFETIME_OR_LABEL (':' lifetimeBounds)?
   ;
typeParam
   : identifier (':' typeParamBounds?)? ('=' type_)?
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
   :  (functionParamPattern | '...' | type_)
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
typesItem
   : 'type' identifier genericParams? ('=' type_)? ';'
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
   | 'super'
   | 'self'
   | 'Self'
   | 'crate'
   | '$crate'
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

expression
   : 
     literalExpression                                  # LiteralExpression_
   | pathExpression                                     # PathExpression_
   | expression '.' pathExprSegment '(' callParams? ')' # MethodCallExpression   // 8.2.10
   | expression '.' identifier                          # FieldExpression  // 8.2.11
   | expression '.' tupleIndex                          # TupleIndexingExpression   // 8.2.7
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
   | 'abort' INTEGER_LITERAL                            # AbortExpression   // exculsive in Move 
   | '(' expression ')'                                 # GroupedExpression   // 8.2.5
   | '[' arrayElements? ']'                             # ArrayExpression  // 8.2.6
   | '(' tupleElements? ')'                             # TupleExpression  // 8.2.7
   | structExpression                                   # StructExpression_   // 8.2.8
//   | enumerationVariantExpression                       # EnumerationVariantExpression_
   | expressionWithBlock                                # ExpressionWithBlock_
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

// 6.6
struct_
   : structStruct
   | tupleStruct
   ;
structStruct
   : 'struct' identifier genericParams? ('{' structFields? '}' | ';')
   ;
tupleStruct
   : 'struct' identifier genericParams? '(' tupleFields? ')' ';'
   ;
structFields
   : structField (',' structField)* ','?
   ;
structField
   :  visibility? identifier ':' type_
   ;
tupleFields
   : tupleField (',' tupleField)* ','?
   ;
tupleField
   :  visibility? type_
   ;

// 6.7

// 6.8

// 6.10
staticItem
   : 'static' 'mut'? identifier ':' type_ ('=' expression)? ';'
   ;

// 6.14
forLifetimes
   : 'for' genericParams
   ;

// 8
statement
   : ';'
   | item
   | letStatement
   | expressionStatement
   ;

letStatement
   :  'let' patternNoTopAlt (':' type_)? ('=' expression)? ';'
   ;

expressionStatement
   : expression ';'
   | expressionWithBlock ';'?
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
   : 
     blockExpression
   | loopExpression
   | ifExpression
   ;

// 8.2.1
literalExpression
   : INTEGER_LITERAL
//   | CHAR_LITERAL
//   | STRING_LITERAL
//   | RAW_STRING_LITERAL
//   | BYTE_LITERAL
//   | BYTE_STRING_LITERAL
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

// 8.2.6
arrayElements
   : expression (',' expression)* ','?
   | expression ';' expression
   ;

// 8.2.7
tupleElements
   : (expression ',')+ expression?
   ;
tupleIndex
   : INTEGER_LITERAL
   ;

// 8.2.8
structExpression
   : structExprStruct
   | structExprTuple
   | structExprUnit
   ;
structExprStruct
   : pathInExpression '{' (structExprFields | structBase)? '}'
   ;
structExprFields
   : structExprField (',' structExprField)* (',' structBase | ','?)
   ;
structExprField
   :  (identifier | (identifier | tupleIndex) ':' expression)
   ;
structBase
   : '..' expression
   ;
structExprTuple
   : pathInExpression '(' (expression ( ',' expression)* ','?)? ')'
   ;
structExprUnit
   : pathInExpression
   ;


// 8.2.9
callParams
   : expression (',' expression)* ','?
   ;

// 8.2.12


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

// 8.2.15


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
   | tupleStructPattern
   | tuplePattern
   | groupedPattern
   | slicePattern
   | pathPattern
   ;

literalPattern
   : KW_TRUE
   | KW_FALSE
//   | CHAR_LITERAL
//   | BYTE_LITERAL
//   | STRING_LITERAL
//   | RAW_STRING_LITERAL
//   | BYTE_STRING_LITERAL
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
   : 
   (
      tupleIndex ':' pattern
      | identifier ':' pattern
      | 'ref'? 'mut'? identifier
   )
   ;
structPatternEtCetera
   :  '..'
   ;
tupleStructPattern
   : pathInExpression '(' tupleStructItems? ')'
   ;
tupleStructItems
   : pattern (',' pattern)* ','?
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
slicePattern
   : '[' slicePatternItems? ']'
   ;
slicePatternItems
   : pattern (',' pattern)* ','?
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
   | typePath
   | tupleType
   | neverType
   | rawPointerType
   | referenceType
   | arrayType
   | sliceType
   | inferredType
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

// 10.1.6
arrayType
   : '[' type_ ';' expression ']'
   ;

// 10.1.7
sliceType
   : '[' type_ ']'
   ;

// 10.1.13
referenceType
   : '&' lifetime? 'mut'? typeNoBounds
   ;
rawPointerType
   : '*' ('mut' | 'const') typeNoBounds
   ;

// 10.1.15

// 10.1.18
inferredType
   : '_'
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
   | '\'static'
   | '\'_'
   ;

// 12.4
simplePath
   : '::'? simplePathSegment ('::' simplePathSegment)*
   ;
simplePathSegment
   : identifier
   | 'super'
   | 'self'
   | 'crate'
   | '$crate'
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

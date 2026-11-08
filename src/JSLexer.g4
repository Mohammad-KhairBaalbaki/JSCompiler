// ============================================================
// JavaScript ES2025 Lexer - ANTLR4
// المرحلة الأولى - المحلل المفرداتي
// مبني على: MDN Lexical Grammar + ECMAScript 2025 Spec
// ============================================================

lexer grammar JSLexer;

// ============================================================
// 1. HASHBANG COMMENT (لازم يكون أول شي في الملف فقط)
// مثال: #!/usr/bin/env node
// ============================================================

HASHBANG
    : '#!' ~[\r\n]* -> skip
    ;

// ============================================================
// 2. RESERVED KEYWORDS
// ترتيب مهم: لازم قبل IDENTIFIER دايماً
// ============================================================

// --- Variable Declaration ---
VAR         : 'var' ;
LET         : 'let' ;
CONST       : 'const' ;

// --- Control Flow ---
IF          : 'if' ;
ELSE        : 'else' ;
FOR         : 'for' ;
WHILE       : 'while' ;
DO          : 'do' ;
BREAK       : 'break' ;
CONTINUE    : 'continue' ;
RETURN      : 'return' ;
SWITCH      : 'switch' ;
CASE        : 'case' ;
DEFAULT     : 'default' ;

// --- Functions ---
FUNCTION    : 'function' ;
ASYNC       : 'async' ;
AWAIT       : 'await' ;
YIELD       : 'yield' ;

// --- Classes & OOP ---
CLASS       : 'class' ;
EXTENDS     : 'extends' ;
SUPER       : 'super' ;
THIS        : 'this' ;
NEW         : 'new' ;
DELETE      : 'delete' ;
STATIC      : 'static' ;

// --- Error Handling ---
TRY         : 'try' ;
CATCH       : 'catch' ;
FINALLY     : 'finally' ;
THROW       : 'throw' ;

// --- Modules ---
IMPORT      : 'import' ;
EXPORT      : 'export' ;
FROM        : 'from' ;
AS          : 'as' ;
OF          : 'of' ;

// --- Operators Keywords ---
TYPEOF      : 'typeof' ;
INSTANCEOF  : 'instanceof' ;
VOID        : 'void' ;
IN          : 'in' ;

// --- Other Keywords ---
DEBUGGER    : 'debugger' ;
WITH        : 'with' ;

// --- Future Reserved ---
ENUM        : 'enum' ;

// --- Strict Mode Reserved ---
IMPLEMENTS  : 'implements' ;
INTERFACE   : 'interface' ;
PACKAGE     : 'package' ;
PRIVATE     : 'private' ;
PROTECTED   : 'protected' ;
PUBLIC      : 'public' ;

// ============================================================
// 3. BOOLEAN LITERALS
// ============================================================

TRUE        : 'true' ;
FALSE       : 'false' ;

// ============================================================
// 4. NULL LITERAL
// ============================================================

NULL_LITERAL : 'null' ;

// ============================================================
// 5. NUMERIC LITERALS
// ترتيب مهم: الأطول والأكثر تخصصاً أولاً
// ============================================================

// --- BigInt (لازم قبل الأرقام العادية) ---
// مثال: 123n  0xFF n  0o77n  0b101n
BIGINT
    : (
        [1-9] ([0-9] | '_' [0-9])*
      | '0'
      | '0' [xX] [0-9a-fA-F] ([0-9a-fA-F] | '_' [0-9a-fA-F])*
      | '0' [oO] [0-7] ([0-7] | '_' [0-7])*
      | '0' [bB] [01] ([01] | '_' [01])*
      ) 'n'
    ;

// --- Hexadecimal ---
// مثال: 0xFF  0xA0_B0
HEX_NUMBER
    : '0' [xX] [0-9a-fA-F] ([0-9a-fA-F] | '_' [0-9a-fA-F])*
    ;

// --- Octal (الصيغة الجديدة 0o) ---
// مثال: 0o777  0O644
OCTAL_NUMBER
    : '0' [oO] [0-7] ([0-7] | '_' [0-7])*
    ;

// --- Binary ---
// مثال: 0b1010  0B1100
BINARY_NUMBER
    : '0' [bB] [01] ([01] | '_' [01])*
    ;

// --- Float ---
// مثال: 3.14  .5  1e10  1.5e-3  1_000.5
FLOAT
    : [0-9] ([0-9] | '_' [0-9])* '.' [0-9] ([0-9] | '_' [0-9])* EXPONENT?
    | '.' [0-9] ([0-9] | '_' [0-9])* EXPONENT?
    | [0-9] ([0-9] | '_' [0-9])* EXPONENT
    ;

// --- Integer ---
// مثال: 42  1_000_000  0
INTEGER
    : '0'
    | [1-9] ([0-9] | '_' [0-9])*
    ;

// Helper fragment للـ exponent
fragment EXPONENT
    : [eE] [+\-]? [0-9] ([0-9] | '_' [0-9])*
    ;

// ============================================================
// 6. STRING LITERALS
// ============================================================

// --- Double Quote String ---
// يدعم: escape sequences, line continuation (\+newline), لكن ليس raw newline
// مثال: "hello"  "say \"hi\""  "line1\
//        line2"
DOUBLE_STRING
    : '"' (
        '\\' ('\r\n' | '\r' | '\n')    // line continuation
      | '\\' .                          // any escape sequence
      | ~["\\\r\n]                      // any char except quote, backslash, newline
      )* '"'
    ;

// --- Single Quote String ---
// مثال: 'hello'  'it\'s'  'line1\
//        line2'
SINGLE_STRING
    : '\'' (
        '\\' ('\r\n' | '\r' | '\n')    // line continuation
      | '\\' .                          // any escape sequence
      | ~['\\\r\n]                      // any char except quote, backslash, newline
      )* '\''
    ;

// --- Template Literal (Backtick) ---
// يدعم: متعدد الأسطر، ${expressions}، escape sequences
// مثال: `hello ${name}`  `multi
//        line`
TEMPLATE_LITERAL
    : '`' (
        '\\' .                          // escape sequence
      | '${' .*? '}'                   // template expression ${...}
      | ~[`\\]                          // any char except backtick and backslash
      )* '`'
    ;

// ============================================================
// 7. COMMENTS
// ============================================================

// --- Single Line Comment ---
// مثال: // this is a comment
SINGLE_LINE_COMMENT
    : '//' ~[\r\n]* -> skip
    ;

// --- Multi Line Comment ---
// مثال: /* this is
//         multi line */
MULTI_LINE_COMMENT
    : '/*' .*? '*/' -> skip
    ;

// ============================================================
// 8. OPERATORS
// الأطول أولاً دايماً لتجنب التعارض
// ============================================================

// --- Spread / Rest ---
ELLIPSIS        : '...' ;

// --- Optional Chaining ---
OPTIONAL_CHAIN  : '?.' ;

// --- Nullish Coalescing Assignment ---
NULLISH_ASSIGN  : '??=' ;

// --- Logical Assignment ---
AND_ASSIGN      : '&&=' ;
OR_ASSIGN       : '||=' ;

// --- Strict Equality ---
STRICT_EQ       : '===' ;
STRICT_NEQ      : '!==' ;

// --- Equality ---
EQ              : '==' ;
NEQ             : '!=' ;

// --- Comparison ---
LTE             : '<=' ;
GTE             : '>=' ;
LT              : '<' ;
GT              : '>' ;

// --- Arrow Function ---
ARROW           : '=>' ;

// --- Assignment ---
ASSIGN          : '=' ;
PLUS_ASSIGN     : '+=' ;
MINUS_ASSIGN    : '-=' ;
MUL_ASSIGN      : '*=' ;
DIV_ASSIGN      : '/=' ;
MOD_ASSIGN      : '%=' ;
POW_ASSIGN      : '**=' ;
AND_BIT_ASSIGN  : '&=' ;
OR_BIT_ASSIGN   : '|=' ;
XOR_ASSIGN      : '^=' ;
LEFT_SHIFT_ASSIGN  : '<<=' ;
RIGHT_SHIFT_ASSIGN : '>>=' ;
URSHIFT_ASSIGN     : '>>>=' ;

// --- Arithmetic ---
INCREMENT       : '++' ;
DECREMENT       : '--' ;
POW             : '**' ;
PLUS            : '+' ;
MINUS           : '-' ;
MUL             : '*' ;
DIV             : '/' ;
MOD             : '%' ;

// --- Bitwise ---
LEFT_SHIFT      : '<<' ;
URSHIFT         : '>>>' ;
RIGHT_SHIFT     : '>>' ;
BIT_AND         : '&' ;
BIT_OR          : '|' ;
BIT_XOR         : '^' ;
BIT_NOT         : '~' ;

// --- Logical ---
LOGICAL_AND     : '&&' ;
LOGICAL_OR      : '||' ;
NULLISH         : '??' ;
LOGICAL_NOT     : '!' ;

// --- Ternary ---
QUESTION        : '?' ;
COLON           : ':' ;

// --- Member Access ---
DOT             : '.' ;

// --- Private Field (#) ---
HASH            : '#' ;

// ============================================================
// 9. PUNCTUATION / DELIMITERS
// ============================================================

OPEN_PAREN      : '(' ;
CLOSE_PAREN     : ')' ;
OPEN_BRACE      : '{' ;
CLOSE_BRACE     : '}' ;
OPEN_BRACKET    : '[' ;
CLOSE_BRACKET   : ']' ;
SEMICOLON       : ';' ;
COMMA           : ',' ;

// ============================================================
// 10. IDENTIFIERS
// لازم تكون بعد كل الكلمات المحجوزة
// تدعم: حروف عربية وUnicode, $, _
// مثال: myVar  _private  $element  متغير
// ============================================================

IDENTIFIER
    : [$_\p{ID_Start}] [$_\p{ID_Continue}]*
    ;

// ============================================================
// 11. WHITESPACE - يتجاهل ولا يطبع
// ============================================================

WS
    : [ \t\r\n\u000B\u000C\u00A0\uFEFF]+ -> skip
    ;

// ============================================================
// 12. LEXICAL ERRORS - أي شي ما اتعرف عليه
// لازم تكون آخر قاعدة دايماً
// ============================================================

UNKNOWN
    : .
    ;

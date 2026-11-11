// ============================================================
// JavaScript ECMAScript 2025 (ES16) Lexer - ANTLR4
// المرحلة الأولى - المحلل المفرداتي (Lexical Analyzer)
// Reference: https://tc39.es/ecma262/2025/ (Clause 12: Lexical Grammar)
// ============================================================

lexer grammar JSLexer;

// ============================================================
// 1. HASHBANG COMMENT (ECMAScript 2025 - Clause 12.5)
// مسموح حصراً في السطر الأول والعمود صفر من الملف
// ============================================================

HASHBANG
    : {getLine() == 1 && getCharPositionInLine() == 0}? '#!' ~[\r\n\u2028\u2029]*
    ;

// ============================================================
// 2. VARIABLE DECLARATIONS (البند 7 في المطلوب: Variable)
// ============================================================

VAR         : 'var' ;
LET         : 'let' ;
CONST       : 'const' ;

// ============================================================
// 3. BOOLEAN LITERALS (البند 3 في المطلوب: Boolean)
// ============================================================

TRUE        : 'true' ;
FALSE       : 'false' ;

// ============================================================
// 4. RESERVED KEYWORDS (البند 1 في المطلوب: Reserved Keyword)
// مطابق لمعيار ECMAScript 2025 - Clause 12.7.2
// ============================================================

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

// --- Functions & Generators ---
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

// --- Modules & ES2025 Import Attributes (import ... with { type: 'json' }) ---
IMPORT      : 'import' ;
EXPORT      : 'export' ;
FROM        : 'from' ;
AS          : 'as' ;
OF          : 'of' ;
WITH        : 'with' ;

// --- Operator Keywords ---
TYPEOF      : 'typeof' ;
INSTANCEOF  : 'instanceof' ;
VOID        : 'void' ;
IN          : 'in' ;

// --- Other & Null/Undefined ---
DEBUGGER     : 'debugger' ;
NULL_LITERAL : 'null' ;

// --- Future Reserved & Strict Mode Reserved (Clause 12.7.2) ---
ENUM        : 'enum' ;
IMPLEMENTS  : 'implements' ;
INTERFACE   : 'interface' ;
PACKAGE     : 'package' ;
PRIVATE     : 'private' ;
PROTECTED   : 'protected' ;
PUBLIC      : 'public' ;

// ============================================================
// 5. NUMERIC LITERALS (البند 2 في المطلوب: Numbers)
// مطابق لمعيار ECMAScript 2025 - Clause 12.9.3
// يدعم Numeric Separators (_) وجميع الصيغ الخمس المطلوبة
// ============================================================

// --- BigInt (Decimal, Hex, Octal, Binary + 'n') ---
BIGINT
    : (
        DECIMAL_INTEGER_LITERAL
      | '0' [xX] HEX_DIGITS
      | '0' [oO] OCTAL_DIGITS
      | '0' [bB] BINARY_DIGITS
      ) 'n'
    ;

// --- Hexadecimal ---
HEX_NUMBER
    : '0' [xX] HEX_DIGITS
    ;

// --- Octal ---
OCTAL_NUMBER
    : '0' [oO] OCTAL_DIGITS
    ;

// --- Binary ---
BINARY_NUMBER
    : '0' [bB] BINARY_DIGITS
    ;

// --- Float (يدعم 3.14 و .5 و 5. و 1.5e-3 و 1_000.5) ---
FLOAT
    : DECIMAL_INTEGER_LITERAL '.' DECIMAL_DIGITS? EXPONENT_PART?
    | '.' DECIMAL_DIGITS EXPONENT_PART?
    | DECIMAL_INTEGER_LITERAL EXPONENT_PART
    ;

// --- Integer ---
INTEGER
    : DECIMAL_INTEGER_LITERAL
    ;

fragment DECIMAL_INTEGER_LITERAL
    : '0'
    | [1-9] ('_'? [0-9])*
    ;

fragment DECIMAL_DIGITS
    : [0-9] ('_'? [0-9])*
    ;

fragment HEX_DIGITS
    : [0-9a-fA-F] ('_'? [0-9a-fA-F])*
    ;

fragment OCTAL_DIGITS
    : [0-7] ('_'? [0-7])*
    ;

fragment BINARY_DIGITS
    : [01] ('_'? [01])*
    ;

fragment EXPONENT_PART
    : [eE] [+\-]? DECIMAL_DIGITS
    ;

// ============================================================
// 6. STRING LITERALS (البند 4 والحالات الخاصة 1 و 2)
// مطابق لمعيار ECMAScript 2025 - Clause 12.9.4 & 12.9.6
// ============================================================

// --- Double Quote String ("...") ---
// يدعم علامة ' بالداخل دون هروب، ومحارف الهروب، وامتداد السطر عبر \ متبوعة بسطر جديد
DOUBLE_STRING
    : '"' (
        '\\' LINE_TERMINATOR_SEQUENCE   // Line Continuation (\ + newline)
      | '\\' ~[\r\n\u2028\u2029]        // Escape sequence
      | ~["\\\r\n\u2028\u2029]          // Normal characters (including ')
      )* '"'
    ;

// --- Single Quote String ('...') ---
// يدعم علامة " بالداخل دون هروب، ومحارف الهروب، وامتداد السطر عبر \ متبوعة بسطر جديد
SINGLE_STRING
    : '\'' (
        '\\' LINE_TERMINATOR_SEQUENCE   // Line Continuation (\ + newline)
      | '\\' ~[\r\n\u2028\u2029]        // Escape sequence
      | ~['\\\r\n\u2028\u2029]          // Normal characters (including ")
      )* '\''
    ;

// --- Template Literal (`...`) ---
// الحالات الخاصة 2: نصوص على عدة أسطر بين علامتي backtick `
TEMPLATE_LITERAL
    : '`' (
        '\\' .                          // Escape sequence (including \` and \$)
      | '${' .*? '}'                    // Template substitution ${...}
      | ~[`\\]                          // Multi-line characters
      )* '`'
    ;

fragment LINE_TERMINATOR_SEQUENCE
    : '\r\n'
    | [\r\n\u2028\u2029]
    ;

// ============================================================
// 7. COMMENTS (البند 8 والحالة الخاصة 3)
// ملاحظة: بدون -> skip لكي يتم التعرف عليها وطباعتها ضمن الـ Tokens
// ============================================================

SINGLE_LINE_COMMENT
    : '//' ~[\r\n\u2028\u2029]*
    ;

MULTI_LINE_COMMENT
    : '/*' .*? '*/'
    ;

// ============================================================
// 8. OPERATORS & PUNCTUATION (البند 5: Operators)
// مطابق لمعيار ECMAScript 2025 - Clause 12.8
// مرتبة من الأطول إلى الأقصر (Maximal Munch)
// ============================================================

// --- Spread / Rest ---
ELLIPSIS            : '...' ;

// --- Optional Chaining ---
OPTIONAL_CHAIN      : '?.' ;

// --- Compound Assignments (4 & 3 chars) ---
URSHIFT_ASSIGN      : '>>>=' ;
LEFT_SHIFT_ASSIGN   : '<<=' ;
RIGHT_SHIFT_ASSIGN  : '>>=' ;
POW_ASSIGN          : '**=' ;
NULLISH_ASSIGN      : '??=' ;
AND_ASSIGN          : '&&=' ;
OR_ASSIGN           : '||=' ;

// --- Strict Equality (3 chars) ---
STRICT_EQ           : '===' ;
STRICT_NEQ          : '!==' ;

// --- Bitwise Unsigned Right Shift (3 chars) ---
URSHIFT             : '>>>' ;

// --- Compound Assignments (2 chars) ---
PLUS_ASSIGN         : '+=' ;
MINUS_ASSIGN        : '-=' ;
MUL_ASSIGN          : '*=' ;
DIV_ASSIGN          : '/=' ;
MOD_ASSIGN          : '%=' ;
AND_BIT_ASSIGN      : '&=' ;
OR_BIT_ASSIGN       : '|=' ;
XOR_ASSIGN          : '^=' ;

// --- Equality & Relational (2 chars) ---
EQ                  : '==' ;
NEQ                 : '!=' ;
LTE                 : '<=' ;
GTE                 : '>=' ;

// --- Arrow Function (2 chars) ---
ARROW               : '=>' ;

// --- Increment, Decrement & Power (2 chars) ---
INCREMENT           : '++' ;
DECREMENT           : '--' ;
POW                 : '**' ;

// --- Bitwise Shifts (2 chars) ---
LEFT_SHIFT          : '<<' ;
RIGHT_SHIFT         : '>>' ;

// --- Logical & Nullish (2 chars) ---
LOGICAL_AND         : '&&' ;
LOGICAL_OR          : '||' ;
NULLISH             : '??' ;

// --- Single-Character Operators ---
ASSIGN              : '=' ;
LT                  : '<' ;
GT                  : '>' ;
PLUS                : '+' ;
MINUS               : '-' ;
MUL                 : '*' ;
DIV                 : '/' ;
MOD                 : '%' ;
BIT_AND             : '&' ;
BIT_OR              : '|' ;
BIT_XOR             : '^' ;
BIT_NOT             : '~' ;
LOGICAL_NOT         : '!' ;
QUESTION            : '?' ;
COLON               : ':' ;
DOT                 : '.' ;

// --- Delimiters / Punctuation ---
OPEN_PAREN          : '(' ;
CLOSE_PAREN         : ')' ;
OPEN_BRACE          : '{' ;
CLOSE_BRACE         : '}' ;
OPEN_BRACKET        : '[' ;
CLOSE_BRACKET       : ']' ;
SEMICOLON           : ';' ;
COMMA               : ',' ;

// ============================================================
// 9. IDENTIFIERS (البند 6: Identifiers & Private Identifiers)
// مطابق لمعيار ECMAScript 2025 - Clause 12.7
// ============================================================

// Unicode Escape Sequence
fragment UNICODE_ESCAPE_SEQUENCE
    : '\\' 'u' (
          HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
        | '{' HEX_DIGIT+ '}'
      )
    ;

// Hexadecimal digit
fragment HEX_DIGIT
    : [0-9a-fA-F]
    ;

// Identifier
IDENTIFIER
    : IDENTIFIER_START IDENTIFIER_PART*
    ;

// Private Identifier
PRIVATE_IDENTIFIER
    : '#' IDENTIFIER_START IDENTIFIER_PART*
    ;

fragment IDENTIFIER_START
    : [$_\p{ID_Start}]
    | UNICODE_ESCAPE_SEQUENCE
    ;

fragment IDENTIFIER_PART
    : [$_\p{ID_Continue}\u200C\u200D]
    | UNICODE_ESCAPE_SEQUENCE
    ;

// ============================================================
// 10. WHITESPACE (Clause 12.2 & 12.3 - يُتجاهل)
// ============================================================

WS
    : [ \t\r\n\u000B\u000C\u00A0\uFEFF\u2028\u2029]+ -> skip
    ;

// ============================================================
// 11. LEXICAL ERRORS (الأخطاء المعجمية - Invalid or unexpected token)
// تلتقط الحالات الخاطئة كاملة (مثل var s = "abc) كخطأ واحد في موقعه الدقيق
// ============================================================

// 1. نص مفرد أو مزدوج غير مغلق قبل نهاية السطر أو الملف
UNTERMINATED_STRING
    : '"' ( '\\' LINE_TERMINATOR_SEQUENCE | '\\' ~[\r\n\u2028\u2029] | ~["\\\r\n\u2028\u2029] )*
    | '\'' ( '\\' LINE_TERMINATOR_SEQUENCE | '\\' ~[\r\n\u2028\u2029] | ~['\\\r\n\u2028\u2029] )*
    ;

// 2. قالب نصي (Template Literal) غير مغلق حتى نهاية الملف
UNTERMINATED_TEMPLATE
    : '`' ( '\\' . | ~[`\\] )*
    ;

// 3. تعليق متعدد الأسطر غير مغلق حتى نهاية الملف
UNTERMINATED_COMMENT
    : '/*' ( ~[*] | '*'+ ~[*/] )* '*'* EOF
    ;

// 4. أرقام بصيغة غير صالحة في ES2025 (مثل: 123abc, 0xG, 0o89, 0b12, 3.14n, 007, 123_)
MALFORMED_NUMBER
    : (BIGINT | HEX_NUMBER | OCTAL_NUMBER | BINARY_NUMBER | FLOAT | INTEGER) [$_\p{ID_Start}0-9.]+
    | '0' [0-9_]+
    | '0' [xX] ('_' | ~[0-9a-fA-F\r\n\t ;,()[\]{}+\-*/%&|^!~=<>?:.])? IDENTIFIER_PART*
    | '0' [oO] ('_' | ~[0-7\r\n\t ;,()[\]{}+\-*/%&|^!~=<>?:.])? IDENTIFIER_PART*
    | '0' [bB] ('_' | ~[01\r\n\t ;,()[\]{}+\-*/%&|^!~=<>?:.])? IDENTIFIER_PART*
    | [0-9]+ ('_' [0-9]*)+ '_'
    ;

// 5. أي محرف غير معروف آخر (مثل @ أو # منفردة أو \ منفردة)
UNKNOWN
    : .
    ;

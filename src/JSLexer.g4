// ============================================================
// JavaScript ECMAScript 2025 (ES16) Lexer - ANTLR4
// المرحلة الأولى - المحلل المفرداتي (Lexical Analyzer)
// Reference: https://tc39.es/ecma262/2025/ (Clause 12: Lexical Grammar)
// ============================================================

lexer grammar JSLexer;

tokens { UNTERMINATED_TEMPLATE }

@members {
    private static final class TemplateState {
        final int start;
        final int line;
        final int column;

        // -1 means template text; 0 or higher means interpolation.
        int braceDepth = -1;

        TemplateState(int start, int line, int column) {
            this.start = start;
            this.line = line;
            this.column = column;
        }
    }

    private final java.util.ArrayDeque<TemplateState> templates =
        new java.util.ArrayDeque<>();

    private boolean templateEofReported = false;


    // A parser may select the exact slash lexical goal before its next token.
    private boolean regexAllowed = true;
    private int previousType = org.antlr.v4.runtime.Token.INVALID_TYPE;
    private int beforePreviousType = org.antlr.v4.runtime.Token.INVALID_TYPE;
    private final java.util.ArrayDeque<Boolean> controlParens =
        new java.util.ArrayDeque<>();
    private final java.util.ArrayDeque<Boolean> blockBraces =
        new java.util.ArrayDeque<>();

    public void setRegexAllowed(boolean allowed) {
        regexAllowed = allowed;
    }

    private boolean isControlKeyword(int type) {
        return type == IF || type == WHILE || type == FOR || type == WITH
            || type == SWITCH || type == CATCH;
    }

    private void trackLexicalContext(org.antlr.v4.runtime.Token token) {
        int type = token.getType();
        if (type == SINGLE_LINE_COMMENT || type == MULTI_LINE_COMMENT
                || type == HASHBANG || type == org.antlr.v4.runtime.Token.EOF) return;
        switch (type) {
            case OPEN_PAREN:
                controlParens.push(isControlKeyword(previousType)
                    && beforePreviousType != DOT
                    && beforePreviousType != OPTIONAL_CHAIN);
                regexAllowed = true;
                break;
            case CLOSE_PAREN:
                regexAllowed = !controlParens.isEmpty() && controlParens.pop();
                break;
            case OPEN_BRACE:
                blockBraces.push(previousType == org.antlr.v4.runtime.Token.INVALID_TYPE
                    || previousType == SEMICOLON || previousType == CLOSE_PAREN
                    || previousType == ELSE || previousType == TRY
                    || previousType == FINALLY || previousType == DO
                    || previousType == OPEN_BRACE || previousType == CLOSE_BRACE);
                regexAllowed = true;
                break;
            case CLOSE_BRACE:
                regexAllowed = _mode != TEMPLATE_MODE
                    && !blockBraces.isEmpty() && blockBraces.pop();
                break;
            case IDENTIFIER: case PRIVATE_IDENTIFIER:
            case TRUE: case FALSE: case NULL_LITERAL: case THIS: case SUPER:
            case BIGINT: case HEX_NUMBER: case OCTAL_NUMBER: case BINARY_NUMBER:
            case FLOAT: case INTEGER: case DOUBLE_STRING: case SINGLE_STRING:
            case REGEX_LITERAL: case TEMPLATE_END: case CLOSE_BRACKET:
            case INCREMENT: case DECREMENT: case DOT: case OPTIONAL_CHAIN:
                regexAllowed = false;
                break;
            case TEMPLATE_TEXT: case TEMPLATE_ESCAPE: case TEMPLATE_DOLLAR:
                return;
            default:
                regexAllowed = previousType != DOT && previousType != OPTIONAL_CHAIN;
        }
        beforePreviousType = previousType;
        previousType = type;
    }

    private void validateStringEscapes() {
        String text = getText();
        for (int i = 1; i < text.length() - 1; i++) {
            if (text.charAt(i) != '\\') continue;
            char escape = text.charAt(++i);
            if (escape != 'x' && escape != 'u') continue;
            int digits = escape == 'x' ? 2 : 4;
            boolean braced = escape == 'u' && i + 1 < text.length() - 1
                && text.charAt(i + 1) == '{';
            if (braced) i++;
            int count = 0;
            long value = 0;
            while (i + 1 < text.length() - 1) {
                int digit = Character.digit(text.charAt(i + 1), 16);
                if (digit < 0 || text.charAt(i + 1) > 127) break;
                i++;
                count++;
                value = Math.min(0x110000L, value * 16 + digit);
                if (!braced && count == digits) break;
            }
            boolean invalid;
            if (braced) {
                invalid = count == 0 || value > 0x10FFFFL
                    || i + 1 >= text.length() - 1 || text.charAt(i + 1) != '}';
                if (!invalid) i++;
            } else {
                invalid = count != digits;
            }
            if (invalid) {
                getErrorListenerDispatch().syntaxError(
                    this, null, _tokenStartLine, _tokenStartCharPositionInLine,
                    "Malformed string escape", null
                );
                return;
            }
        }
    }

    private void beginTemplate() {
        templates.push(new TemplateState(
            _tokenStartCharIndex,
            _tokenStartLine,
            _tokenStartCharPositionInLine
        ));
        mode(TEMPLATE_MODE);
    }

    private void beginInterpolation() {
        templates.peek().braceDepth = 0;
        mode(DEFAULT_MODE);
    }

    private void openBrace() {
        if (!templates.isEmpty()
                && templates.peek().braceDepth >= 0) {
            templates.peek().braceDepth++;
        }
    }

    private void closeBrace() {
        if (templates.isEmpty()
                || templates.peek().braceDepth < 0) {
            return;
        }

        TemplateState current = templates.peek();

        if (current.braceDepth == 0) {
            current.braceDepth = -1;
            mode(TEMPLATE_MODE);
        } else {
            current.braceDepth--;
        }
    }

    private void endTemplate() {
        templates.pop();

        // A nested template finishes inside its parent's expression.
        mode(DEFAULT_MODE);
    }

    @Override
    public org.antlr.v4.runtime.Token nextToken() {
        org.antlr.v4.runtime.Token token = super.nextToken();

        if (token.getType() == org.antlr.v4.runtime.Token.EOF
                && !templates.isEmpty()
                && !templateEofReported) {
            templateEofReported = true;

            TemplateState opening = templates.peekLast();

            String text = _input.getText(
                org.antlr.v4.runtime.misc.Interval.of(
                    opening.start, _input.index() - 1
                )
            );

            org.antlr.v4.runtime.CommonToken error =
                new org.antlr.v4.runtime.CommonToken(
                    UNTERMINATED_TEMPLATE, text
                );

            error.setLine(opening.line);
            error.setCharPositionInLine(opening.column);
            error.setStartIndex(opening.start);
            error.setStopIndex(_input.index() - 1);

            return error;
        }

        trackLexicalContext(token);
        return token;
    }

    @Override
    public void reset() {
        super.reset();

        if (templates != null) {
            templates.clear();
        }

        templateEofReported = false;
        if (controlParens != null) controlParens.clear();
        if (blockBraces != null) blockBraces.clear();
        regexAllowed = true;
        previousType = org.antlr.v4.runtime.Token.INVALID_TYPE;
        beforePreviousType = org.antlr.v4.runtime.Token.INVALID_TYPE;
    }
}

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
    : '"' ('\\' LINE_TERMINATOR_SEQUENCE
          | '\\' ~[\r\n\u2028\u2029]
          | ~["\\\r\n])* '"' {validateStringEscapes();}
    ;

SINGLE_STRING
    : '\'' ('\\' LINE_TERMINATOR_SEQUENCE
           | '\\' ~[\r\n\u2028\u2029]
           | ~['\\\r\n])* '\'' {validateStringEscapes();}
    ;


// --- Template Literal (`...`) ---
// الحالات الخاصة 2: نصوص على عدة أسطر بين علامتي backtick `
TEMPLATE_LITERAL
    : '`' {beginTemplate();}
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

REGEX_LITERAL
    : {regexAllowed}? '/' REGEX_FIRST REGEX_CHAR* '/' IDENTIFIER_PART*
    ;

fragment REGEX_FIRST
    : ~[*/\\\r\n\u2028\u2029[]
    | REGEX_ESCAPE
    | REGEX_CLASS
    ;

fragment REGEX_CHAR
    : ~[/\\\r\n\u2028\u2029[]
    | REGEX_ESCAPE
    | REGEX_CLASS
    ;

fragment REGEX_ESCAPE
    : '\\' ~[\r\n\u2028\u2029]
    ;

fragment REGEX_CLASS
    : '[' (REGEX_ESCAPE | ~[\]\\\r\n\u2028\u2029])* ']'
    ;


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
OPEN_BRACE
    : '{' {openBrace();}
    ;

CLOSE_BRACE
    : '}' {closeBrace();}
    ;
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
    : '"' ('\\' LINE_TERMINATOR_SEQUENCE | '\\' ~[\r\n\u2028\u2029] | ~["\\\r\n])* '\\'?
    | '\'' ('\\' LINE_TERMINATOR_SEQUENCE | '\\' ~[\r\n\u2028\u2029] | ~['\\\r\n])* '\\'?
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

mode TEMPLATE_MODE;

TEMPLATE_END
    : '`' {endTemplate();}
    ;

TEMPLATE_INTERPOLATION_START
    : '${' {beginInterpolation();}
    ;

TEMPLATE_ESCAPE
    : '\\' .?
    ;

TEMPLATE_TEXT
    : ~[`\\$]+
    ;

TEMPLATE_DOLLAR
    : '$'
    ;
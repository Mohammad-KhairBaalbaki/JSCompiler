// JavaScript ECMAScript 2025 Lexer - ANTLR4

lexer grammar JSLexer;

// Keep token numbers stable when organizing rule sections.
tokens {
    UNTERMINATED_TEMPLATE, HASHBANG, VAR, LET, CONST, TRUE,
    FALSE, IF, ELSE, FOR, WHILE, DO,
    BREAK, CONTINUE, RETURN, SWITCH, CASE, DEFAULT,
    FUNCTION, ASYNC, AWAIT, YIELD, CLASS, EXTENDS,
    SUPER, THIS, NEW, DELETE, STATIC, TRY,
    CATCH, FINALLY, THROW, IMPORT, EXPORT, FROM,
    AS, OF, WITH, TYPEOF, INSTANCEOF, VOID,
    IN, DEBUGGER, NULL_LITERAL, ENUM, IMPLEMENTS, INTERFACE,
    PACKAGE, PRIVATE, PROTECTED, PUBLIC, BIGINT, HEX_NUMBER,
    OCTAL_NUMBER, BINARY_NUMBER, FLOAT, INTEGER, DOUBLE_STRING, SINGLE_STRING,
    TEMPLATE_LITERAL, SINGLE_LINE_COMMENT, MULTI_LINE_COMMENT, REGEX_LITERAL, ELLIPSIS, OPTIONAL_CHAIN,
    URSHIFT_ASSIGN, LEFT_SHIFT_ASSIGN, RIGHT_SHIFT_ASSIGN, POW_ASSIGN, NULLISH_ASSIGN, AND_ASSIGN,
    OR_ASSIGN, STRICT_EQ, STRICT_NEQ, URSHIFT, PLUS_ASSIGN, MINUS_ASSIGN,
    MUL_ASSIGN, DIV_ASSIGN, MOD_ASSIGN, AND_BIT_ASSIGN, OR_BIT_ASSIGN, XOR_ASSIGN,
    EQ, NEQ, LTE, GTE, ARROW, INCREMENT,
    DECREMENT, POW, LEFT_SHIFT, RIGHT_SHIFT, LOGICAL_AND, LOGICAL_OR,
    NULLISH, ASSIGN, LT, GT, PLUS, MINUS,
    MUL, DIV, MOD, BIT_AND, BIT_OR, BIT_XOR,
    BIT_NOT, LOGICAL_NOT, QUESTION, COLON, DOT, OPEN_PAREN,
    CLOSE_PAREN, OPEN_BRACE, CLOSE_BRACE, OPEN_BRACKET, CLOSE_BRACKET, SEMICOLON,
    COMMA, IDENTIFIER, PRIVATE_IDENTIFIER, WS, UNTERMINATED_STRING, UNTERMINATED_COMMENT,
    MALFORMED_NUMBER, UNKNOWN, TEMPLATE_END, TEMPLATE_INTERPOLATION_START, TEMPLATE_ESCAPE, TEMPLATE_TEXT,
    TEMPLATE_DOLLAR
}

@members {
    private static final class TemplateState {
        final int start;
        final int line;
        final int column;

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

// 1. WHITESPACE AND COMMENTS
// Tests: ws_and_comments_test.js

HASHBANG
    : {getLine() == 1 && getCharPositionInLine() == 0}? '#!' ~[\r\n\u2028\u2029]*
    ;

WS
    : [ \t\r\n\u000B\u000C\u00A0\uFEFF\u2028\u2029]+ -> skip
    ;

// Single Line
SINGLE_LINE_COMMENT
    : '//' ~[\r\n\u2028\u2029]*
    ;

// Multi Line
MULTI_LINE_COMMENT
    : '/*' .*? '*/'
    ;

// 2. IDENTIFIERS AND KEYWORDS
// Tests: identifiers_and_keywords_test.js

VAR         : 'var' ;
LET         : 'let' ;
CONST       : 'const' ;


// Boolean literals

TRUE        : 'true' ;
FALSE       : 'false' ;


// Reserved and contextual keywords

// Control Flow
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

// Functions & Generators
FUNCTION    : 'function' ;
ASYNC       : 'async' ;
AWAIT       : 'await' ;
YIELD       : 'yield' ;

// Classes & OOP
CLASS       : 'class' ;
EXTENDS     : 'extends' ;
SUPER       : 'super' ;
THIS        : 'this' ;
NEW         : 'new' ;
DELETE      : 'delete' ;
STATIC      : 'static' ;

// Error Handling
TRY         : 'try' ;
CATCH       : 'catch' ;
FINALLY     : 'finally' ;
THROW       : 'throw' ;

// Modules & ES2025 Import Attributes
IMPORT      : 'import' ;
EXPORT      : 'export' ;
FROM        : 'from' ;
AS          : 'as' ;
OF          : 'of' ;
WITH        : 'with' ;

// Operator Keywords
TYPEOF      : 'typeof' ;
INSTANCEOF  : 'instanceof' ;
VOID        : 'void' ;
IN          : 'in' ;

// Other & Null/Undefined
DEBUGGER     : 'debugger' ;
NULL_LITERAL : 'null' ;

// Future Reserved & Strict Mode Reserved
ENUM        : 'enum' ;
IMPLEMENTS  : 'implements' ;
INTERFACE   : 'interface' ;
PACKAGE     : 'package' ;
PRIVATE     : 'private' ;
PROTECTED   : 'protected' ;
PUBLIC      : 'public' ;

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

// 3. NUMERIC LITERALS
// Tests: numerical_values_test.js

// BigInt
BIGINT
    : (
        DECIMAL_INTEGER_LITERAL
      | '0' [xX] HEX_DIGITS
      | '0' [oO] OCTAL_DIGITS
      | '0' [bB] BINARY_DIGITS
      ) 'n'
    ;

// Hexadecimal
HEX_NUMBER
    : '0' [xX] HEX_DIGITS
    ;

// Octal
OCTAL_NUMBER
    : '0' [oO] OCTAL_DIGITS
    ;

// Binary
BINARY_NUMBER
    : '0' [bB] BINARY_DIGITS
    ;

// Float
FLOAT
    : DECIMAL_INTEGER_LITERAL '.' DECIMAL_DIGITS? EXPONENT_PART?
    | '.' DECIMAL_DIGITS EXPONENT_PART?
    | DECIMAL_INTEGER_LITERAL EXPONENT_PART
    ;

// Integer
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

// 4. STRINGS, TEMPLATES, AND REGEX
// Tests: strings_template_rgex.js

// Double Quote String ("")
DOUBLE_STRING
    : '"' ('\\' LINE_TERMINATOR_SEQUENCE
          | '\\' ~[\r\n\u2028\u2029]
          | ~["\\\r\n])* '"' {validateStringEscapes();}
    ;
// Single Quote String ('')
SINGLE_STRING
    : '\'' ('\\' LINE_TERMINATOR_SEQUENCE
           | '\\' ~[\r\n\u2028\u2029]
           | ~['\\\r\n])* '\'' {validateStringEscapes();}
    ;

// Template Literal (``)
TEMPLATE_LITERAL
    : '`' {beginTemplate();}
    ;

fragment LINE_TERMINATOR_SEQUENCE
    : '\r\n'
    | [\r\n\u2028\u2029]
    ;

// Regex Literal
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

// 5. OPERATORS AND PUNCTUATORS
// Tests: operators_punctuators.js

// Rest
ELLIPSIS            : '...' ;

// Optional Chaining
OPTIONAL_CHAIN      : '?.' ;

// Compound Assignments
URSHIFT_ASSIGN      : '>>>=' ;
LEFT_SHIFT_ASSIGN   : '<<=' ;
RIGHT_SHIFT_ASSIGN  : '>>=' ;
POW_ASSIGN          : '**=' ;
NULLISH_ASSIGN      : '??=' ;
AND_ASSIGN          : '&&=' ;
OR_ASSIGN           : '||=' ;

// Strict Equality
STRICT_EQ           : '===' ;
STRICT_NEQ          : '!==' ;

// Bitwise Unsigned Right Shift
URSHIFT             : '>>>' ;

// Compound Assignments
PLUS_ASSIGN         : '+=' ;
MINUS_ASSIGN        : '-=' ;
MUL_ASSIGN          : '*=' ;
DIV_ASSIGN          : '/=' ;
MOD_ASSIGN          : '%=' ;
AND_BIT_ASSIGN      : '&=' ;
OR_BIT_ASSIGN       : '|=' ;
XOR_ASSIGN          : '^=' ;

// Equality & Relational
EQ                  : '==' ;
NEQ                 : '!=' ;
LTE                 : '<=' ;
GTE                 : '>=' ;

// Arrow Function
ARROW               : '=>' ;

// Increment, Decrement & Power
INCREMENT           : '++' ;
DECREMENT           : '--' ;
POW                 : '**' ;

// Bitwise Shifts
LEFT_SHIFT          : '<<' ;
RIGHT_SHIFT         : '>>' ;

// Logical & Nullish
LOGICAL_AND         : '&&' ;
LOGICAL_OR          : '||' ;
NULLISH             : '??' ;

// Single-Character Operators
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

// Delimiters / Punctuation
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


// Single- or double-quoted string not closed before the end of the line or file
UNTERMINATED_STRING
    : '"' ('\\' LINE_TERMINATOR_SEQUENCE | '\\' ~[\r\n\u2028\u2029] | ~["\\\r\n])* '\\'?
    | '\'' ('\\' LINE_TERMINATOR_SEQUENCE | '\\' ~[\r\n\u2028\u2029] | ~['\\\r\n])* '\\'?
    ;


// Multi-line comment not closed before the end of the file
UNTERMINATED_COMMENT
    : '/*' ( ~[*] | '*'+ ~[*/] )* '*'* EOF
    ;

// Invalid numeric formats
MALFORMED_NUMBER
    : (BIGINT | HEX_NUMBER | OCTAL_NUMBER | BINARY_NUMBER | FLOAT | INTEGER) [$_\p{ID_Start}0-9.]+
    | '0' [0-9_]+
    | '0' [xX] ('_' | ~[0-9a-fA-F\r\n\t ;,()[\]{}+\-*/%&|^!~=<>?:.])? IDENTIFIER_PART*
    | '0' [oO] ('_' | ~[0-7\r\n\t ;,()[\]{}+\-*/%&|^!~=<>?:.])? IDENTIFIER_PART*
    | '0' [bB] ('_' | ~[01\r\n\t ;,()[\]{}+\-*/%&|^!~=<>?:.])? IDENTIFIER_PART*
    | [0-9]+ ('_' [0-9]*)+ '_'
    ;

// Any other unknown character ex: @ #
UNKNOWN
    : .
    ;

// Rules used while reading template text
mode TEMPLATE_MODE;

// Close the current template and return to JavaScript tokenization
TEMPLATE_END
    : '`' {endTemplate();}
    ;

// Begin an interpolation and switch to JavaScript tokenization
TEMPLATE_INTERPOLATION_START
    : '${' {beginInterpolation();}
    ;

// Match a backslash and the following character, if present
TEMPLATE_ESCAPE
    : '\\' .?
    ;

// Match template text, excluding backticks, backslashes, and dollar signs
TEMPLATE_TEXT
    : ~[`\\$]+
    ;

// Match a dollar sign that does not begin an interpolation
TEMPLATE_DOLLAR
    : '$'
    ;

lexer grammar JSLexer;

// Keywords
KEYWORD
    : 'await' | 'break' | 'case' | 'catch' | 'class' | 'const'
    | 'continue' | 'debugger' | 'default' | 'delete' | 'do'
    | 'else' | 'enum' | 'export' | 'extends' | 'finally' | 'for'
    | 'function' | 'if' | 'import' | 'in' | 'instanceof' | 'new'
    | 'return' | 'super' | 'switch' | 'this' | 'throw' | 'try'
    | 'typeof' | 'var' | 'void' | 'while' | 'with' | 'yield'
    | 'let' | 'static' | 'implements' | 'interface' | 'package'
    | 'private' | 'protected' | 'public'
    ;

BOOLEAN : 'true' | 'false';
NULL_LITERAL : 'null';

// Contextual words (async, of, get, set, from, as) remain identifiers.
IDENTIFIER : IDENTIFIER_START IDENTIFIER_PART*;
fragment IDENTIFIER_START : [\p{L}\p{Nl}$_];
fragment IDENTIFIER_PART : [\p{L}\p{Nl}\p{Mn}\p{Mc}\p{Nd}\p{Pc}$_\u200C\u200D];

WS : [ \t\r\n\u000B\u000C\u00A0\u2028\u2029\uFEFF]+ -> skip;

ERROR_CHAR : .;

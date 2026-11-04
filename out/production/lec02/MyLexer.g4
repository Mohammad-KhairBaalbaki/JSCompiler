lexer grammar MyLexer;

GREETING : ('Hello'|'Hi'|'Greeting'|'مرحبا');
ID     : [a-zA-Z]+ ;
WS     : [ \t\r\n]+ -> skip ;
lexer grammar SimpleLexer;
GREETING : ('Hello'|'Hi'|'Greeting'|'مرحبا');
IF     : 'if' ;
ELSE   : 'else' ;
ID     : [a-zA-Z]+ ;
NUM    : [0-4]+ ;
ASSIGN : '=' ;
PLUS   : '+' ;
WS     : [ \t\r\n]+ -> skip ;
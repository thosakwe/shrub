lexer grammar ShrubLexer;

WS: [ \n\r\t]+ -> skip;
SINGLE_COMMENT: '//' (~'\n')+;
ARROW: '=>';
COMMA: ',';
LBRACKET: '[';
RBRACKET: ']';
LCURLY: '{';
RCURLY: '}';
LPAREN: '(';
RPAREN: ')';
FN: 'fn';
IMPORT: 'import';
WITH: 'with';
HEX: '0x' [A-Fa-f0-9]+;
NUMBER: '-'? [0-9]+ ('.' [0-9]+)?;
STRING: '`' -> pushMode(TEMPLATE_STRING); 
ID: [A-Za-z_] [A-Za-z0-9_];

mode TEMPLATE_STRING;

INTERPOLATION: '%{' -> pushMode(NORMAL);

END: '`' -> popMode;
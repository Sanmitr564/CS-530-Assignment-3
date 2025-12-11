%option yylineno

%{
#include "a3.tab.h"
#include <stdlib.h>

extern YYLTYPE yylloc;
static int col = 0;

#define YY_USER_ACTION \
yylloc.first_line = yylineno; \
yylloc.last_line = yylineno; \
yylloc.first_column = col; \
yylloc.last_column  = col + yyleng - 1; \
col += yyleng; \

%}

%%

[a-zA-Z][a-zA-Z0-9]*	{ printf("%s", yytext); return IDENTIFIER;}
[ \t]+ 			{ printf("%s", yytext); }
\n 			{ col = 0;  printf("%s", yytext); return '\n';}
[+\-*/%]		{ printf("%s", yytext); return OP;}
=			{ printf("%s", yytext); return EQUAL;}
"("			{ printf("%s", yytext); return OPEN;}
")"			{ printf("%s", yytext); return CLOSE;}
/* [(][a-zA-Z][a-zA-Z0-9]*	{ printf("%s", yytext); return SUBEXSTART;} */
/* [a-zA-Z][a-zA-Z0-9]*[)]	{ printf("%s", yytext); return SUBEXEND;} */
[;]			{ printf("%s", yytext); return ';';}
[^[:space:]]+		{
    			fprintf(stderr, "Invalid token '%s' at line %d\n", yytext, yylineno);
    			return ERROR;
			}
%%

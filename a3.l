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

IDENT	[a-zA-Z][a-zA-Z0-9]*
OP	[+\-*/%]

%%

	/* valid tokens */
{IDENT}		{ printf("%s", yytext); return IDENTIFIER;}
[ \t]+ 		{ printf("%s", yytext); }
\n 		{ col = 0;  printf("%s", yytext); return '\n';}
{OP}		{ printf("%s", yytext); return OP;}
=		{ printf("%s", yytext); return EQUAL;}
"("		{ printf("%s", yytext); return OPEN;}
")"		{ printf("%s", yytext); return CLOSE;}
[;]		{ printf("%s", yytext); return ';';}

	/* error catching */
[0-9]{IDENT}				{
    					fprintf(stderr, "Invalid token '%s' at line %d\n", yytext, yylineno);
    					return ERROR;
					}
{OP}{2,}				{
    					fprintf(stderr, "Invalid token '%s' at line %d\n", yytext, yylineno);
    					return ERROR;
					}
[^[:space:][:alnum:]\(\)+\-*/%=;]+	{
    					fprintf(stderr, "Invalid token '%s' at line %d\n", yytext, yylineno);
    					return ERROR;
					}

%%

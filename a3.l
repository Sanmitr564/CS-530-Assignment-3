/*
Aaron Alegre
828222103
*/

%option yylineno

%{
#include "a3.tab.h"
#include "shared.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern YYLTYPE yylloc;
static int col = 0;
static int correctequal = 1;

#define YY_USER_ACTION \
yylloc.first_line = yylineno; \
yylloc.last_line = yylineno; \
yylloc.first_column = col; \
yylloc.last_column  = col + yyleng - 1; \
col += yyleng; \
strcat(linebuf, yytext); \

%}

IDENT	[a-zA-Z][a-zA-Z0-9]*
DIGIT	[0-9]+
OP	[+\-*/%]

%%

	/* valid tokens */
{IDENT}		{ return IDENTIFIER;}
{DIGIT}		{ return IDENTIFIER;}	/* simpler than having digits be separate */
[ \t]+ 		{ }
\n 		{ correctequal = 1; col = 0; return '\n';}
{OP}		{ correctequal = 0; return OP;}
=		{ 
			if(correctequal){
				correctequal = 0;
				return EQUAL;
			}
			Error("Invalid assignment");
			return ERROR;
		}
"("		{ parentheses++; return OPEN;}
")"		{ parentheses--; return CLOSE;}
[;]		{ return ';';}

	/* error catching */
[0-9][a-zA-Z0-9]*			{
					char buf[STR_LEN];
					snprintf(buf, sizeof(buf), "Invalid token '%s'", yytext);
					Error(buf);
					return ERROR;
					}
{OP}{2,}				{
					char buf[STR_LEN];
					snprintf(buf, sizeof(buf), "Invalid token '%s'", yytext);
					Error(buf);

    					return ERROR;
					}
[^[:space:][:alnum:]\(\)+\-*/%=;]+	{
					char buf[STR_LEN];
					snprintf(buf, sizeof(buf), "Invalid token '%s'", yytext);
					Error(buf);
    					return ERROR;
					}

%%

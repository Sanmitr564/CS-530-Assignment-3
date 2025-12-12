%{
#include <stdio.h>
#include <string.h>
#include "shared.h"

extern int yylex(void);
extern int yyparse(void);
void yyerror(const char *s);

extern int yydebug;
extern int yychar;
extern FILE *yyin;

int elementafterop = 1;

static void trimLinebuf(){
	for(int i = 0; i < STR_LEN; i++){
		if(linebuf[i] == '\0') return;
		if(linebuf[i] == '\n'){
			linebuf[i] = '\0';
			return;
		}
	}
}

static void printValid(){
	trimLinebuf();
	printf("%s\t--valid\n", linebuf);
	resetErrorMessage();
	linebuf[0] = '\0';
}

%}
/*
Aaron Alegre
828222103
*/

%token IDENTIFIER OP EQUAL OPEN CLOSE ERROR error

%define parse.error verbose
%locations
/* %debug */

%%

lines:
	%empty |
	line lines 
	;

line:
	assignment '\n' {printValid(); }|
	expression '\n' {printValid(); }|
	error '\n'	{
				trimLinebuf();
				printf("%s\t", linebuf);
				if(!elementafterop){
					Error("Missing term after operator");
					elementafterop = 1;
				}
				if(parentheses){
					Error("Mismatched parentheses");
					parentheses = 0;
				}
				printf("--error: %s\n", getErrorMessage());
				resetErrorMessage();
				linebuf[0] = '\0';
				yyerrok;
				yyclearin;
			}
	;

assignment:
	IDENTIFIER EQUAL assignment_tail
	;

assignment_tail:
	expression ';' |
	expression		{ Error("Assignment missing semicolon"); YYERROR;} |
	EQUAL			{ Error("'=' '=' is not valid"); YYERROR;}
	;

expression:
	expression_notsub |
	OPEN expression CLOSE
	;

expression_notsub:
	element OP { elementafterop = 0;} element { elementafterop = 1;} |
	expression_notsub OP {elementafterop = 0;} element {elementafterop = 1;}
	;

element:
	IDENTIFIER |
	OPEN expression CLOSE |
	OP			{ Error("OP OP invalid"); YYERROR;} |
	EQUAL			{ Error("Invalid assignment"); YYERROR;} |
	CLOSE			{ Error("Mismatched parentheses"); YYERROR;}

%%

int main(void) {
	//yydebug = 1;
	FILE *file;
	file = fopen("scanme.txt", "r");
	
	if(!file){
		printf("Could not open scanme.txt\n");
		return 1;
	}
	
	yyin = file;
	yyparse();

	fclose(file);

	return 0;
}

void yyerror(const char *msg) {
	if(strlen(getErrorMessage()) != 0){
		return;
	}
	extern YYLTYPE yylloc;
	fprintf(stderr, "Error at line %d:%d: %s\n", yylloc.last_line, yylloc.last_column, msg);
}

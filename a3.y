%{
#include <stdio.h>
#include <string.h>
extern int yydebug;

extern FILE *yyin;
char errmsg[512];

static void Error(const char *msg){
	if (errmsg[0] == '\0') {
		strncpy(errmsg, msg, sizeof(errmsg) - 1);
		errmsg[sizeof(errmsg) - 1] = '\0';
	}
	
}
%}

%token IDENTIFIER OP EQUAL OPEN CLOSE SUBEXSTART SUBEXEND ERROR error

%define parse.error verbose
%locations
%debug

%%

lines:
	%empty |
	line lines
	;

line:
	maybeline '\n'
	;

maybeline:
	assignment |
	expression |
	error		{ printf("\nerror\n");  yyerrok; yyclearin;}
	;

assignment:
	assignment_valid |
	assignment_invalid
	;

assignment_valid:
	IDENTIFIER EQUAL expression ';'
	;

assignment_invalid:
	IDENTIFIER EQUAL expression		{ Error("Assignment missing semicolon"); YYERROR;} |
	IDENTIFIER EQUAL EQUAL			{ Error("'=' '=' is not valid"); YYERROR;}
	;

expression:
	element OP element |
	subexpression
	;

element:
	element_valid |
	element_invalid
	;

element_valid:
	IDENTIFIER |
	subexpression
	;

element_invalid:
	OP	{ Error("OP OP invalid"); YYERROR;} |
	EQUAL	{ Error("Invalid assignment"); YYERROR;}
	;

subexpression:
	OPEN expression CLOSE
	;

%%

int main(void) {
	//yydebug = 1;

	printf("Enter expressions (Ctrl+D to exit):\n");
	return yyparse();
}

void yyerror(const char *msg) {
	extern YYLTYPE yylloc;
	fprintf(stderr, "Error at line %d:%d: %s\n", yylloc.last_line, yylloc.last_column, msg);
}

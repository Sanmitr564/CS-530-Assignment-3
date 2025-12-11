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
	expressionstart expressionextension
	;

expressionstart:
	expressionstart_valid |
	expressionstart_invalid
	;

expressionstart_valid:
	IDENTIFIER OP element |
	subexpression
	;

expressionstart_invalid:
	OP				{ Error("Expression cannot start with OP"); YYERROR;} |
	closesubexpression		{ Error("Expression cannot start by closing subexpression"); YYERROR;} |
	'\n'				{ Error("Expression cannot be empty"); YYERROR;} |
	';'				{ Error("Expression cannot start with ';'"); YYERROR; } |
	IDENTIFIER IDENTIFIER		{ Error("Terms must be separated by OP"); YYERROR;} |
	IDENTIFIER opensubexpression	{ Error("Terms must be separated by OP"); YYERROR;} |
	IDENTIFIER '\n'			{ Error("Expression cannot be single identifier"); YYERROR; } |
	IDENTIFIER closesubexpression	{ Error("Mismatched parentheses"); YYERROR; } |
	IDENTIFIER ';'			{ Error("Expression cannot only have one term"); YYERROR; }
	;

expressionextension:
	%empty |
	expressionextension_valid |
	expressionextension_invalid
	;

expressionextension_valid:
	OP element expressionextension
	;

expressionextension_invalid:
	IDENTIFIER		{ Error("Element IDENTIFIER invalid"); YYERROR;} |
	EQUAL			{ Error("Invalid assignment"); YYERROR;} |
	opensubexpression	{ Error("Terms must be separated by OP"); YYERROR; } |
	closesubexpression	{ Error("Terms must be separated by OP"); YYERROR; }
	;

subexpressionextension:
	subexpressionextension_valid |
	subexpressionextension_invalid
	;

subexpressionextension_valid:
	subexpressionend |
	element OP subexpressionextension
	;

subexpressionextension_invalid:
	element IDENTIFIER
	;

subexpression:
	subexpression_valid |
	subexpression_invalid
	;

subexpression_valid:
	subexpressionstart OP subexpressionextension 
	;

subexpression_invalid:
	subexpressionstart IDENTIFIER		{ Error("Terms must be separated by OP"); YYERROR; } |
	subexpressionstart EQUAL		{ Error("Invalid assignment"); YYERROR; } |
	subexpressionstart opensubexpression	{ Error("Terms must be separated by OP"); YYERROR; } |
	subexpressionstart closesubexpression	{ Error("Terms must be separated by OP"); YYERROR; }
	;

subexpressionstart:
	OPEN  element | // double parentheses not allowed because '(' must be preceded by space '((' illegal '( (' allowed
	SUBEXSTART
	;

subexpressionend:
	element CLOSE |
	SUBEXEND
	;

opensubexpression: //used for error checking purposes
	OPEN |
	SUBEXEND
	;

closesubexpression: //used for error checking purposes
	CLOSE |
	SUBEXEND
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

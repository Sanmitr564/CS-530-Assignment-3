Aaron Alegre
828222103
cssc2101
CS 530, Fall 2025
Assignment 3
README.md

Manifest:
a3.l
a3.output
a3.tab.c
a3.tab.h
a3.y
lex.yy.c
makefile
scanme.txt
scanner
shared.c
shared.h

Compile Instructions:
make            -compiles project
make clean      -deletes all object files and executables

Operating Instructions:
./scanner
Reads from scanme.txt. Cannot be changed

Novel/Significant Design Decisions:
The use of C code between terminals/nonterminals in expression_notsub to track whether OPs were properly followed by terms. Shift/reduce errors were present in other methods of tracking.
The use of shared.c for shared variables between the .y and .l files.
The use of YYERROR to recognize and force errors when errors were recognized.

Extra Functionality:
None

Known Deficiencies/Bugs:
Compiler warnings when running make. Does not affect results.

Lessons Learned:
How to construct a parser and tokenizer using bison and flex.

Grammar (BNF):
<lines> ::= <line> | <line> <lines>
<line> ::= <assignment> "\n" | <expression> "\n"
<assignment> ::= <identifier> "=" <expression> ";"
<expression> ::= <expression_notsub> | "(" <expression> ")"
<expression_notsub> ::= <element> <op> <element> | <expression_notsub> <op> <element>
<element> ::= <identifier> | "(" <expression> ")"

<identifier> ::= <letter> { <letter> | <digit> }
<op>         ::= "+" | "-" | "*" | "/" | "%"

<letter> ::= "a" | "b" | ... | "y" | "z" | "A" | "B" | ... | "Y" | "Z"
<digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

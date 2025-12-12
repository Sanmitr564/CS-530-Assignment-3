#Aaron Alegre
#828222103
BISON   = bison
FLEX    = flex
CC      = gcc

BISONFLAGS	= -d -Wall
FLEXFLAGS	=
CFLAGS		= -Wall -Wextra -g

YFILE	= a3.y
LFILE	= a3.l
TARGET	= scanner

BISON_C		= $(YFILE:.y=.tab.c)
BISON_H		= $(YFILE:.y=.tab.h)
LEX_C		= lex.yy.c
SHARED_C	= shared.c

all: $(TARGET)

$(TARGET): $(BISON_C) $(LEX_C)
	$(CC) $(CFLAGS) -o $@ $(BISON_C) $(LEX_C) $(SHARED_C) -lfl

$(BISON_C) $(BISON_H): $(YFILE)
	$(BISON) $(BISONFLAGS) $(YFILE)

$(LEX_C): $(LFILE) $(BISON_H)
	$(FLEX) $(FLEXFLAGS) $(LFILE)

clean:
	rm -f $(TARGET) $(BISON_C) $(BISON_H) $(LEX_C)

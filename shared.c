/*
 * Aaron Alegre
 * 828222103
 */

#include "shared.h"
#include <string.h>

int parentheses = 0;

char errmsg[STR_LEN];
char linebuf[STR_LEN] = "";

void Error(const char *msg){
	if (errmsg[0] == '\0') {
		strncpy(errmsg, msg, sizeof(errmsg) - 1);
		errmsg[sizeof(errmsg) - 1] = '\0';
	}
}

void resetErrorMessage(){
	errmsg[0] = '\0';
}

char* getErrorMessage(){
	return errmsg;
}

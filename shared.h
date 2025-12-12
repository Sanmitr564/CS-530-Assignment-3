/*
 * Aaron Alegre
 * 828222103
 */
#define STR_LEN 512

extern int parentheses;
extern char linebuf[];

void Error(const char *msg);
void resetErrorMessage();
char* getErrorMessage();

%{
#include <stdio.h>
#include <string.h>
#include "bucol.tab.h"
%}

%option caseless

%%
[\t ]+                          {}
[\n]+                           {}
"BEGINNING"                     { printf("Token: BEGINNING\n"); return (BEGINNING); }
"BODY"                          { printf("Token: BODY\n"); return (BODY); }
"END"                           { printf("Token: END.\n"); return (END); }
"MOVE"                          { printf("Token: MOVE\n"); return (MOVE); }
"ADD"                           { printf("Token: ADD\n"); return (ADD); }
"INPUT"                         { printf("Token: INPUT\n"); return (INPUT); }
"PRINT"                         { printf("Token: PRINT\n"); return (PRINT); }
"TO"                            { printf("Token: TO\n"); return (TO); }
;                               { printf("Token: SEMICOLON\n"); return (SEMICOLON); }
\"(\\.|[^\"])*\"                { printf("Token: STRING\n"); return (STRING); }
\.                              { printf("Token: LINE_END\n"); return (LINE_END); }
[X]+                            { yylval.size = strlen(yytext); printf("Token: CAPACITY, Value: %d\n", yylval.size); return CAPACITY; }
[0-9]+                          { yylval.value = atoi(yytext); printf("Token: INTEGER, Value: %d\n", yylval.value); return INTEGER; }
[A-Za-z][\-a-zA-Z0-9]*          { yylval.id = strdup(yytext); printf("Token: IDENTIFIER, Value: %s\n", yylval.id); return IDENTIFIER; }
.                               { printf("Token: UNKNOWN\n"); return (UNKNOWN); }
%%

int yywrap() {
    return 1;
}

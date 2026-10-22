%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_STR_LEN	100
#include "modula.tab.h"
  int comm_beg;
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID); 
char *strnncpy(char *dst, const char *src, const int n);
int keywords(const char* text);
%}

 /* state of the lexical analyzer (INITIAL is predefined) */
%x ST_COMMENT
%x DOUBLESTR
%x CHARCONST
%x INTEGER
%x FLOAT
%x KOMENTARZ

%option yylineno
%%

 /* removal of white space */
 /* ... */
[[:blank:]\n] {} ;

 /* strings in double quotes STRING_CONST */
 /* ... */

 /* nie uzywajac warunkow poczatkowych */
 
\"[^\"\n]*\" { return process_token(yytext, "STRING_CONST", yytext, STRING_CONST); }

\"[^\"\n]*\n { fprintf(stderr, "nie zamkniety dstr"); } 

 /* uzywajac warunkow poczatkowych */
 /*
<INITIAL>\" { yymore(); BEGIN(DOUBLESTR);}
<DOUBLESTR>\" {BEGIN(INITIAL); return process_token(yytext, "STRING_CONST", yytext, STRING_CONST); }
<DOUBLESTR>. { yymore(); }
<DOUBLESTR>\n {fprintf(stderr, "nie zamkniety dstr"); BEGIN(INITIAL); }
 */

 /* character constants in single quotes */

 /*
<INITIAL>\' { yymore(); BEGIN(CHARCONST);}
<CHARCONST>\' {BEGIN(INITIAL); return process_token(yytext, "CHAR_CONST", yytext, CHAR_CONST); }
<CHARCONST>. { yymore(); }
<CHARCONST>\n {fprintf(stderr, "nie zamkniety char const"); BEGIN(INITIAL); }
 */

 /* nie uzywajac warunkow poczatkowych */

\'[^\'\n]*\' { return process_token(yytext, "CHAR_CONST", yytext, STRING_CONST); }

\'[^\'\n]*\n { fprintf(stderr, "nie zamkniety char const"); } 


 /* interger constants INTEGER_CONST */
<INITIAL>[0-9]+ {return process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST);}

 /* float constants FLOAT_CONST */

<INITIAL>(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))([eE](\+|\-)?[0-9]{1,2})? {return process_token(yytext, "FLOAT_CONST", yytext, REAL_CONST);}
   

 /* keywords */
AND {return process_token(yytext, "KW_AND", "", KW_AND);}
BEGIN {return process_token(yytext, "KW_BEGIN", "", KW_BEGIN);}
CONST {return process_token(yytext, "KW_CONST", "", KW_CONST);}
DIV {return process_token(yytext, "KW_DIV", "", KW_DIV);}
DO {return process_token(yytext, "KW_DO", "", KW_DO);}
ELSE {return process_token(yytext, "KW_ELSE", "", KW_ELSE);}
ELSIF {return process_token(yytext, "KW_ELSIF", "", KW_ELSIF);}
END {return process_token(yytext, "KW_END", "", KW_END);}
FOR {return process_token(yytext, "KW_FOR", "", KW_FOR);}
FROM {return process_token(yytext, "KW_FROM", "", KW_FROM);}
IF {return process_token(yytext, "KW_IF", "", KW_IF);}
IMPORT {return process_token(yytext, "KW_IMPORT", "", KW_IMPORT);}
IN {return process_token(yytext, "KW_IN", "", KW_IN);}
MOD {return process_token(yytext, "KW_MOD", "", KW_MOD);}
MODULE {return process_token(yytext, "KW_MODULE", "", KW_MODULE);}
NOT {return process_token(yytext, "KW_NOT", "", KW_NOT);}
OR {return process_token(yytext, "KW_OR", "", KW_OR);}
THEN {return process_token(yytext, "KW_THEN", "", KW_THEN);}
TYPE {return process_token(yytext, "KW_TYPE", "", KW_TYPE);}
TO {return process_token(yytext, "KW_TO", "", KW_TO);}
VAR {return process_token(yytext, "KW_VAR", "", KW_VAR);}
WHILE {return process_token(yytext, "KW_WHILE", "", KW_WHILE);}
REPEAT {return process_token(yytext, "KW_REPEAT", "", KW_REPEAT);}
UNTIL {return process_token(yytext, "KW_UNTIL", "", KW_UNTIL);}
LOOP {return process_token(yytext, "KW_LOOP", "", KW_LOOP);}
CASE {return process_token(yytext, "KW_CASE", "", KW_CASE);}
OF {return process_token(yytext, "KW_OF", "", KW_OF);}
ARRAY {return process_token(yytext, "KW_ARRAY", "", KW_ARRAY);}
RECORD {return process_token(yytext, "KW_RECORD", "", KW_RECORD);}
DOWNTO {return process_token(yytext, "KW_DOWNTO", "", KW_DOWNTO);}

 /* identifiers */


 /* two-character operators */

\<= { return process_token(yytext, "LE", "", LE); }
>= { return process_token(yytext, "GE", "", GE); }
!= { return process_token(yytext, "NEQ", "", NEQ); }
\.\. { return process_token(yytext, "RANGE", "", RANGE); }
:= { return process_token(yytext, "ASSIGN", "", ASSIGN); }



 /* single character operators */
\, {return process_token(yytext, ",", "", ','); }
\; {return process_token(yytext, ";", "", ';'); }
\= {return process_token(yytext, "=", "", '='); }
\: {return process_token(yytext, ":", "", ':'); }
\( {return process_token(yytext, "(", "", '('); }
\) {return process_token(yytext, ")", "", ')'); }
\+ {return process_token(yytext, "+", "", '+'); }
\* {return process_token(yytext, "*", "", '*'); }
\- {return process_token(yytext, "-", "", '-'); }
\. {return process_token(yytext, ".", "", '.'); }
\| {return process_token(yytext, "|", "", '|'); }
\< {return process_token(yytext, "<", "", '<'); }
\[ {return process_token(yytext, "[", "", '['); }
\] {return process_token(yytext, "]", "", ']'); }
 /* comments (using start conditions) */

<INITIAL>"(*" { BEGIN(KOMENTARZ); comm_beg = yylineno;} 
<KOMENTARZ>.|\n { yymore(); }
<KOMENTARZ>"*)" { BEGIN(INITIAL); }

<INITIAL>"*)" { fprintf(stderr, "Comment closed in line %d when none opened\n", yylineno); }

[a-zA-Z][a-zA-Z_$]* { return process_token(yytext, "IDENT", yytext, IDENT); }



%%

int yywrap() {
  /* take care for closing comments */
  /* ... */
  if (YY_START == KOMENTARZ) {
        fprintf(stderr, "Comment opened in line %d not closed\n", comm_beg);
  }
  return 1; /* obligatory!!! */
}

/* Name:	strnncpy
 * Purpose:	copies given number of characters of a string appending 
 *		character with code 0 at the end.
 * Parameters:	dst		- (o) target string;
 *		src		- (i) source string;
 *		n		- (i) max character number to be copied.
 * Returns:	dst.
 * Remarks:	strncpy does not append character code 0 after copied string.
 *		Target string must have room for n+1 characters.
 */
char *
strnncpy(char *dst, const char *src, const int n)
{
  if (n > 0) {
    strncpy(dst, src, n);
  }
  dst[n] = '\0';
  return dst;
}/*strnncpy*/


/* Name:	process_token
 * Purpose:     Print information about detected token and pass it up
 *              with its value if it is present.
 * Parameters:  text            - (i) matched text;
 *              TokenType       - (i) textual representation of token type;
 *              TokenVal        - (i) token value if present
 *              TokenID         - (i) token identifier declared with %token
 *                                      in modula.y file.
 * Returns:	Token type identifier (TokenID).
 * Uwagi:       Information about the detected token is printed in 3 columns.
 *              The first one contains the matched text,
 *		the second - token type, the third - token value if present.
 */
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID)
{
  int l;
  printf("%-20.20s%-15s %s\n", text, TokenType, TokenVal);
  switch (TokenID) {

  case INTEGER_CONST:
    yylval.i = atoi(text); break;

  case REAL_CONST:
    yylval.d = atof(text); break;

  case IDENT:
    strncpy(yylval.s, text, MAX_STR_LEN); break;

  case STRING_CONST:
    l = strlen(text);
    strnncpy(yylval.s, TokenVal+1, l - 2 <= MAX_STR_LEN ? l - 1 : MAX_STR_LEN);
    break;

  }
  return(TokenID);
}

int keywords(const char* text) {
    char* tokenstring;
    int tokenID;
    if (strcmp(text, "AND") == 0) {
        tokenstring = "KW_AND";
        tokenID = KW_AND; 
    } else if (strcmp(text, "BEGIN") == 0) {
        tokenstring = "KW_BEGIN";
        tokenID = KW_BEGIN;
    }
    return process_token(text, tokenstring, "", tokenID);
}

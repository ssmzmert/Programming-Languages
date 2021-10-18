%{
#include <stdio.h>
void yyerror(char *msg)
{
printf("%s\n", msg);
}

%}
%token tSTRING tGET tSET tFUNCTION tPRINT tIF tRETURN tINC tDEC tGT tEQUALITY tLT tLEQ tGEQ tIDENT tNUM

%left '+' '-'
%left '*' '/'
%%



expr 	:	'[' ']'
    		| '[' stmnt ']'
    		;
     
stmnt : tNUM
      | tSTRING
      | set
      | get
      | if
      | increment
      | decrement
      | return
      | print
      | function
      | stmnt stmnt
      ;

set:	'[' tSET ',' tIDENT ',' subset ']'
	;

subset:	tNUM 
	| tSTRING 
	| function
	| tGET
	| operator
	;

operator:	'[' '+' ',' stmnt ',' stmnt ']'
	 	| '[' '-' ',' stmnt ',' stmnt ']'
		| '[' '*' ',' stmnt ',' stmnt ']'
		| '[' '/' ',' stmnt ',' stmnt ']'
		;

if	:	'[' tIF ',' condition ',' '[' then ']' ']'
		| '[' tIF ',' condition ',' then else ']'
		;

condition	:	'[' tLEQ ',' stmnt ',' stmnt ']'
			|'[' tGEQ ',' stmnt ',' stmnt ']'
			|'[' tLT ',' stmnt ',' stmnt ']'
			|'[' tGT ',' stmnt ',' stmnt ']'
			|'[' tEQUALITY ',' stmnt ',' stmnt ']'
			;


then		:	
			| stmnt
			| then then 
			;

else		:	
			| stmnt
			| else else 
			;	

print		:	'[' tPRINT ',' '[' stmnt ']' ']'
			;

increment		:	'[' tINC ',' tIDENT ']'
			;

decrement		:	'[' tDEC ',' tIDENT ']'
			;

get		:	'[' tGET ',' tIDENT ']'
			|'[' tGET ',' tFUNCTION ']'
			;

function	:	'[' tFUNCTION ',' '[' prefixf ']' ',' '[' suffixf ']'  ']'
			|'[' tFUNCTION ',' '[' prefixf ']' ']'
			;

prefixf 	:	prefixf ',' prefixf
			|tIDENT

suffixf 	:	suffixf suffixf
			| stmnt


return		:	'[' tRETURN ']'
			| '[' tRETURN ',' stmnt ']'
			;


  



%%

int main ()
{
    if (yyparse())
    {
        // parse error
        printf("ERROR\n");
        return 1;
    }   
    else
    {
        // successful parsing
        printf("OK\n");
        return 0;
    }
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror (const char *s) 
{}
void printResult (char*, char, int);
%}
%union{
	struct {
		int line;
		char type;
		int isConst;
    	char* value;
	} stats;
}
%token tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC
%token <stats>tADD <stats>tSUB <stats>tMUL <stats>tDIV <stats>tSTRING <stats>tNUM 
%type <stats>expr 
%type <stats>operation
%start prog
%%
prog:		'[' stmtlst ']'
;
stmtlst:	stmtlst stmt |
;
stmt:		setStmt | if | print | unaryOperation 
		| 	expr 	{
						if($1.isConst == 2)
							printResult($1.value, $1.type, $1.line);
					}
		| 	returnStmt
;
getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
		| 	'[' tGET ',' tIDENT ',' '[' ']' ']'
		| 	'[' tGET ',' tIDENT ']'
;
setStmt:	'[' tSET ',' tIDENT ',' expr ']'	{
													if($6.isConst == 2)
														printResult($6.value, $6.type, $6.line);
												}
;
if:			'[' tIF ',' condition ',' '[' stmtlst ']' ']'
		| 	'[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;
print:		'[' tPRINT ',' '[' expr ']' ']'		{
													if($5.isConst == 2)
														printResult($5.value, $5.type, $5.line);
												}
;
operation:	'[' tADD ',' expr ',' expr ']'	
				{
					$$.isConst = 0;
					if($4.isConst && $6.isConst)
					{
						$$.isConst = 1;
						$$.line = $2.line;
						if($4.type == 'd' && $6.type == 'd')
						{
							$$.type = 'd';
							int temp = atoi($4.value) + atoi($6.value);
							char buffer[20];
							sprintf(buffer,"%d", temp);
							$$.value = strdup(buffer);
						}
						else if(($4.type == 'f' && $6.type == 'f') ||
						($4.type == 'd' && $6.type == 'f') ||
						($4.type == 'f' && $6.type == 'd'))
						{
							$$.type = 'f';
							double temp = atof($4.value) + atof($6.value);
							char buffer[50];
							sprintf(buffer, "%.7f", temp);
							$$.value = strdup(buffer);
						}
						else if($4.type == 's' && $6.type == 's')
						{
							$$.type = 's';
							$$.value = strdup($4.value);
							strcat($$.value, $6.value);
						}
						else
						{
							printf("Type mismatch on %d\n", $2.line);
							$$.isConst = 0;
						}
					}
				}
		| 	'[' tSUB ',' expr ',' expr ']'	
				{
					$$.isConst = 0;
					if($4.isConst && $6.isConst)
					{
						$$.isConst = 1;
						$$.line = $2.line;
						if($4.type == 'd' && $6.type == 'd')
						{
							$$.type = 'd';
							int temp = atoi($4.value) - atoi($6.value);
							char buffer[20];
							sprintf(buffer,"%d", temp);
							$$.value = strdup(buffer);
						}
						else if(($4.type == 'f' && $6.type == 'f') ||
						($4.type == 'd' && $6.type == 'f') ||
						($4.type == 'f' && $6.type == 'd'))
						{
							$$.type = 'f';
							double temp = atof($4.value) - atof($6.value);
							char buffer[50];
							sprintf(buffer, "%.7f", temp);
							$$.value = strdup(buffer);
						}
						else
						{
							printf("Type mismatch on %d\n", $2.line);
							$$.isConst = 0;
						}
					}
				}
		| 	'[' tMUL ',' expr ',' expr ']'	
				{
					$$.isConst = 0;
					if($4.isConst && $6.isConst)
					{
						$$.isConst = 1;
						$$.line = $2.line;
						if($4.type == 'd' && $6.type == 'd')
						{
							$$.type = 'd';
							int temp = atoi($4.value) * atoi($6.value);
							char buffer[20];
							sprintf(buffer,"%d", temp);
							//itoa(temp, $$.value, 10);
							$$.value = strdup(buffer);
						}
						else if(($4.type == 'f' && $6.type == 'f') ||
						($4.type == 'd' && $6.type == 'f') ||
						($4.type == 'f' && $6.type == 'd'))
						{
							$$.type = 'f';
							double temp = atof($4.value) * atof($6.value);
							char buffer[50];
							sprintf(buffer, "%.7f", temp);
							$$.value = strdup(buffer);
						}
						else if($4.type == 'd' && $6.type == 's' && 
						atoi($4.value) >= 0)
						{
							$$.type = 's';
							int count = atoi($4.value);
							$$.value = strdup("");
							int i;
							for(i=0; i<count; i++)
								strcat($$.value, $6.value);
						}
						else
						{
							printf("Type mismatch on %d\n", $2.line);
							$$.isConst = 0;
						}
					}
				}
		| 	'[' tDIV ',' expr ',' expr ']'	
				{
					$$.isConst = 0;
					if($4.isConst && $6.isConst)
					{
						$$.isConst = 1;
						$$.line = $2.line;
						if($4.type == 'd' && $6.type == 'd')
						{
							$$.type = 'd';
							int temp = atoi($4.value) / atoi($6.value);
							char buffer[20];
							sprintf(buffer,"%d", temp);
							//itoa(temp, $$.value, 10);
							$$.value = strdup(buffer);
						}
						else if(($4.type == 'f' && $6.type == 'f') ||
						($4.type == 'd' && $6.type == 'f') ||
						($4.type == 'f' && $6.type == 'd'))
						{
							$$.type = 'f';
							double temp = atof($4.value) / atof($6.value);
							char buffer[50];
							sprintf(buffer, "%.7f", temp);
							$$.value = strdup(buffer);
						}
						else
						{
							printf("Type mismatch on %d\n", $2.line);
							$$.isConst = 0;
						}
					}
				}	
;	
unaryOperation: '[' tINC ',' tIDENT ']'
			| 	'[' tDEC ',' tIDENT ']'
;
expr:			tNUM 			{
									$$.isConst = 1;
									$$.type = $1.type;
									$$.value = strdup($1.value);
								}
			| 	tSTRING 		{
									$$.isConst = 1;
									$$.type = $1.type;
									$$.value = strdup($1.value);
								}
			| 	getExpr 		{
									$$.isConst = 0;
								}
			| 	function 		{
									$$.isConst = 0;
								}
			| 	operation 		{
									if($1.isConst)
									{
										$$.isConst = 2;
										$$.type = $1.type;
										$$.value = strdup($1.value);
										$$.line = $1.line;
									}
									else
										$$.isConst = 0;		
								}
			| 	condition		{
									$$.isConst = 0;
								}
;
function:	 	'[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
			|	'[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;
condition:		'[' tEQUALITY ',' expr ',' expr ']'		{
															if($4.isConst == 2)
																printResult($4.value, $4.type, $4.line);
															if($6.isConst == 2)
																printResult($6.value, $6.type, $6.line);
														}
			| 	'[' tGT ',' expr ',' expr ']'			{
															if($4.isConst == 2)
																printResult($4.value, $4.type, $4.line);
															if($6.isConst == 2)
																printResult($6.value, $6.type, $6.line);
														}
			| 	'[' tLT ',' expr ',' expr ']'			{
															if($4.isConst == 2)
																printResult($4.value, $4.type, $4.line);
															if($6.isConst == 2)
																printResult($6.value, $6.type, $6.line);
														}
			| 	'[' tGEQ ',' expr ',' expr ']'			{
															if($4.isConst == 2)
																printResult($4.value, $4.type, $4.line);
															if($6.isConst == 2)
																printResult($6.value, $6.type, $6.line);
														}
			| 	'[' tLEQ ',' expr ',' expr ']'			{
															if($4.isConst == 2)
																printResult($4.value, $4.type, $4.line);
															if($6.isConst == 2)
																printResult($6.value, $6.type, $6.line);
														}
;
returnStmt:		'[' tRETURN ',' expr ']'	{
												if($4.isConst == 2)
													printResult($4.value, $4.type, $4.line);
											}
			| 	'[' tRETURN ']'
;
parametersList: parametersList ',' tIDENT 
			| 	tIDENT
;
exprList:		exprList ',' expr 	{
										if($3.isConst == 2)
											printResult($3.value, $3.type, $3.line);
									}
			| 	expr				{
										if($1.isConst == 2)
											printResult($1.value, $1.type, $1.line);
									}
;
%%
void printResult(char* value, char valueType, int lineNo)
{
	if(valueType == 'd')
		printf("Result of expression on %d is (%d)\n", lineNo, atoi(value));
	else if(valueType == 'f')
		printf("Result of expression on %d is (%.1f)\n", lineNo, (atof(value) + 0.000005));
	else if(valueType == 's')
		printf("Result of expression on %d is (%s)\n", lineNo, value);
}
int main ()
{
	if (yyparse()) {
	// parse error
		printf("ERROR\n");
		return 1;
	}
	else {
	// successful parsing
		return 0;
	}
}

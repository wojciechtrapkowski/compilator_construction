%{
#include <stdio.h>
#include <string.h>
#define MAX_STR_LEN 100
void found(const char *nonterminal, const char *value);
int yylex(void);
void yyerror(const char *txt);
%}

%union {
  char s[MAX_STR_LEN + 1];
  int i;
  double d;
}

/* keywords */
%token <i> KW_WITH KW_USE KW_PROCEDURE KW_IS KW_CONSTANT
%token <i> KW_BEGIN KW_END KW_FOR KW_IN KW_RANGE KW_LOOP
%token <i> KW_PACKAGE KW_BODY KW_OUT KW_IF KW_THEN KW_ELSE
%token <i> KW_ARRAY KW_RECORD KW_DOWNTO KW_OF

/* literal values */
%token <s> STRING_CONST
%token <i> INTEGER_CONST
%token <d> FLOAT_CONST
%token <i> CHARACTER_CONST

/* operators */
%token <i> ASSIGN RANGE LE GE

/* other */
%token <s> IDENT

/* nonterminals */
%type <s> PROC_DEFINITION PROC_HEADER PROC_DECL PACKAGE_DECL PACKAGE_BODY
%type <s> VAR_DECL BLOCK PROCEDURE_CALL NAME IDENT_LIST

/* set precedence and associativity rules */
%left '+' '-'
%left '*' '/'
%right NEG

%%

/* GRAMMAR */
/* Grammar contains context specifcations (CONTEXT_SPECS) followed
    by procedure definition (PROC_DEFINITION). It can also be empty.
    Everything else is an error. */
Grammar: CONTEXT_SPECS PROC_DEFINITION | error;

/* CONTEXT_SPECS */
/* Context specifications is a possibly empty sequence of context specifications
   (CONTEXT_SPEC) */
CONTEXT_SPECS: /* nothing */ | CONTEXT_SPECS CONTEXT_SPEC;

/* CONTEXT_SPEC */
/* Context specification consists of a with clause (WITH_CLAUSE) followed
   by optional use clause (USE_CLAUSE) */
CONTEXT_SPEC:
   WITH_CLAUSE {
      found("CONTEXT_SPEC", "");
   } 
   | WITH_CLAUSE USE_CLAUSE {
      found("CONTEXT_SPEC", "");
   };

/* WITH_CLAUSE */
/* With clause starts with the keyword with followed by a list of names
   (NAME_LIST), and a semicolon */
WITH_CLAUSE:
   KW_WITH NAME_LIST ';' { 
      found("WITH_CLAUSE", ""); 
   };

/* NAME_LIST */
/* List of names (NAME) separated with commas */
NAME_LIST: NAME | NAME_LIST ',' NAME;

/* NAME */
/* List of identifiers separated with dots */
NAME:
   IDENT { 
      strncpy($$, $1, MAX_STR_LEN);
   }
   | NAME '.' IDENT {
      snprintf($$, MAX_STR_LEN, "%s.%s", $1, $3);
   };

/* USE_CLAUSE */
/* Keyword use followed by a list of names (NAME_LIST) and a semicolon */
USE_CLAUSE:
   KW_USE NAME_LIST ';' { 
      found("USE_CLAUSE", ""); 
   };

/* PROC_DEFINITION */
/* Procedure definition starts with procedure header (PROC_HEADER), followed
   by keyword is, then declarations (DECLS), block (BLOCK), and semicolon */
PROC_DEFINITION:
   PROC_HEADER KW_IS DECLS BLOCK ';' {
      found("PROC_DEFINITION", $1);
   };

/* PROC_HEADER */
/* keyword procedure and identifier, followed by optional formal parameters
   (FORMAL_PARAM_LIST) in parentheses */
PROC_HEADER: 
   KW_PROCEDURE IDENT {
      strncpy($$, $2, MAX_STR_LEN);
      found("PROC_HEADER", $2);
   } 
   | KW_PROCEDURE IDENT '(' FORMAL_PARAM_LIST ')' {
      strncpy($$, $2, MAX_STR_LEN);
      found("PROC_HEADER", $2);
   };

/* FORMAL_PARAM_LIST */
/* Comma-separated list of formal parameters (FORMAL_PARAM) */
FORMAL_PARAM_LIST:
   FORMAL_PARAM | FORMAL_PARAM_LIST ';' FORMAL_PARAM;

/* FORMAL_PARAM */
/* Identifier, colon, specification of direction (IN_OUT), and identifier */
FORMAL_PARAM:
   IDENT ':' IN_OUT IDENT;

/* IN_OUT */
/* Either keyword in, or keyword out, or keyword in followed by keyword out */
IN_OUT:
   KW_IN | KW_OUT | KW_IN KW_OUT;

/* DECLS */
/* Possibly empty sequence of declarations (DECL) */
DECLS: 
   /* nothing */ | DECL | DECLS DECL;

/* DECL */
/* Either a package declaration (PACKAGE_DECL),
   or package bosy (PACKAGE_BODY),
   or procedure definition (PROC_DEFINITION),
   or variable declaration (VAR_DECL),
   or constant declaration (CONST_DECL),
   or with clause (WITH_CLAUSE),
   or use clause (USE_CLAUSE) */
DECL: 
   PACKAGE_DECL | PACKAGE_BODY | PROC_DEFINITION | VAR_DECL | 
   CONST_DECL | WITH_CLAUSE | USE_CLAUSE;

/* PACKAGE_DECL */
/* Keyword package, followed by identifierm keyword is,
   procedure declarations (PROC_DECLS), keyword end, identifier,
   and semicolon */
PACKAGE_DECL:
   KW_PACKAGE IDENT KW_IS PROC_DECLS KW_END IDENT ';' {
      found("PACKAGE_DECL", $2);
   };

/* PROC_DECLS */
/* Possibly empty sequence of procedure declarations (PROC_DECL) */
PROC_DECLS:
   /* nothing */ | PROC_DECL | PROC_DECLS PROC_DECL;

/* PROC_DECL */
/* Procedure header (PROC_HEADER) and a semicolon */
PROC_DECL:
   PROC_HEADER ';' {
      found("PROC_DECL", $1);
   };

/* PACKAGE_BODY */
/* Keyword package, keyword body, identifier, keyword is,
   declarations (DECLS), keyword end, identifier, and semicolon. */
PACKAGE_BODY: 
   KW_PACKAGE KW_BODY IDENT KW_IS DECLS KW_END IDENT ';' {
      found("PACKAGE_BODY", $3);
   };

/* VAR_DECL */
/* list of identifiers (IDENT_LIST), colon, type (TYPE), initialization
   (INITIALIZATION), and semicolon */
VAR_DECL:  
   IDENT_LIST ':' TYPE INITIALIZATION ';' {
      found("VAR_DECL", $1);
   };

/* IDENT_LIST */
/* list of identifiers separated with commas */
IDENT_LIST:
   IDENT | IDENT_LIST ',' IDENT;

/* TYPE */
/* Type can either be:
   identifier
   or:
   keyword array, left parenthesis, dimensions (DIMENSIONS), right parenthesis,
   keyword of, and type,
   or:
   keyword record, fields (FIELDS), keyword end, and keyword record. */
TYPE:
   IDENT | 
   KW_ARRAY '(' DIMENSIONS ')' KW_OF TYPE | 
   KW_RECORD FIELDS KW_END KW_RECORD;

/* DIMENSIONS */
/* Non-empty, comma separated list of:
   constant value (CONST_VALUE), range operator (RANGE), and constant value. */
DIMENSIONS:
   CONST_VALUE RANGE CONST_VALUE | 
   DIMENSIONS CONST_VALUE RANGE CONST_VALUE;

/* CONST_VALUE */
/* Integer or character constant */
CONST_VALUE:
   INTEGER_CONST | CHARACTER_CONST;

/* FIELDS */
/* Non-empty sequence of fields (FIELD) */
FIELDS:
   FIELD | FIELDS FIELD;

/* FIELD */
/* Identifier list (IDENT_LIST), colon, type (TYPE), and semicolon */
FIELD:
   IDENT_LIST ':' TYPE ';'

/* CONST_DECL */
/* List of identifiers (IDENT_LIST), colon, keyword constant, identifier,
   assign operator, expression (EXPR), and semicolon */
CONST_DECL:
   IDENT_LIST ':' KW_CONSTANT IDENT ASSIGN EXPR ';' {
      found("CONST_DECL", $1);
   };

/* INITIALIZATION */
/* Either empty or assign operator followed by expression (EXPR) */
INITIALIZATION:
   /* nothing */ | ASSIGN EXPR;

/* EXPR */
/* Either:
   integer constant (INTEGER_CONST),
   or: float constant (FLOAT_CONST),
   or: character constant (CHARACTER_CONST),
   or: expression (EXPR) in parentheses,
   or: procedure call (PROCEDURE_CALL),
   or: sum, difference, product, or quotient of two expressions,
   or: negative expression (unary minus, set appropriate precendece!) */

EXPR: 
   INTEGER_CONST | FLOAT_CONST | CHARACTER_CONST | 
   STRING_CONST | '(' EXPR ')' | ATTRIBUTE_REF | NAME TAB_TAIL |
   EXPR '+' EXPR | EXPR '-' EXPR | EXPR '*' EXPR | EXPR '/' EXPR | 
   '-' EXPR;

/* ATTRIBUTE_REF */
/* This is added by me to match cases like: 
Character'Succ(Uc) or Character'Succ
*/
ATTRIBUTE_REF:
   NAME '\'' IDENT '(' EXPR ')' |
   NAME '\'' IDENT;

/* BLOCK */
/* Keyword begin, instructions (STATEMENTS), keyword end, and identifier */
BLOCK:
   KW_BEGIN STATEMENTS KW_END IDENT {
      found("BLOCK", "");
   };

/* STATEMENTS */
/* Possibly empty sequence of instructions (STATEMENT) */
STATEMENTS:
   /* nothing */ | STATEMENT | STATEMENTS STATEMENT;

/* STATEMENT */
/* Either:
   name (NAME), table part (TAB_TAIL), assignment operator, expression,
   or: name (NAME), table part (TAB_TAIL), and semicolon,
   printed as PROCEDURE_CALL,
   or: for loop (FOR_LOOP),
   or: conditional instruction (IF_STATEMENT) */

STATEMENT:
   NAME TAB_TAIL ASSIGN EXPR ';' {
      found("ASSIGNMENT", $1);
   }
   | PROCEDURE_CALL 
   | FOR_LOOP 
   | IF_STATEMENT;

/* TAB_TAIL */
/* Either empty or expression list (EXPR_LIST) in parentheses followed
   by record fields (FIELD_TAIL) */
TAB_TAIL:
   /* nothing */ | '(' EXPR_LIST ')' FIELD_TAIL;

/* FIELD_TAIL */
/* Either empty, or a dot, identifier and table part (TAB_TAIL) */
FIELD_TAIL:
   /* nothing */ | '.' IDENT TAB_TAIL;

/* EXPR_LIST */
/* List of expressions (EXPR) separated with commas */
EXPR_LIST:
   EXPR | EXPR_LIST ',' EXPR;

/* PROCEDURE_CALL */
/* name (NAME), type attribute (TYPE_ATTR) followed by optional
   list of actual parameters (ACTTUAL_PARAM_LIST) in parentheses */
PROCEDURE_CALL: 
   NAME '(' EXPR_LIST ')' ';' {
      found("PROCEDURE_CALL", $1);
   }
   | NAME ';' {
      found("PROCEDURE_CALL", $1);
   }
   | IDENT ';' {
      found("PROCEDURE_CALL", $1);
   };

// SKIPPED:
// REPLACE BY ATTRIBUTE_REF
/* TYPE_ATTR */
/* Either empty, or an apostrophe followed by identifier */

// THIS IS EXPR_LIST - therefore redundant
/* ACTUAL_PARAM_LIST */
/* List of actual parameters (ACTUAL_PARAM) separated with commas */

/* ACTUAL_PARAM */
/* Expression (EXPR) */

// END OF SKIPPED

/* FOR_LOOP */
/* Keyword for, identifier, keyword in, range specification (RANGE_SPEC),
   keyword loop, instructions (STATEMENTS), keyword end, keyword loop,
   and semicolon */
FOR_LOOP:
   KW_FOR IDENT KW_IN RANGE_SPEC KW_LOOP STATEMENTS KW_END KW_LOOP ';' {
      found("FOR_LOOP", "");
   };

/* RANGE_SPEC */
/* Either: identifier,
   or: two expressions (EXPR) joined with range operator,
   or: identifier, keyword range, and two expressions joined
   with range operator */
RANGE_SPEC:
   IDENT | EXPR RANGE EXPR | IDENT KW_RANGE EXPR RANGE EXPR;

/* IF_STATEMENT */
/* Keyword if, logical expression (LOGICAL_EXPR), keyword then, instructions
   (STATEMENTS), else part (ELSE_PART), keyword else, keyword if, semicolon */
IF_STATEMENT:
   KW_IF LOGICAL_EXPR KW_THEN STATEMENTS ELSE_PART KW_END KW_IF ';' {
      found("IF_STATEMENT", "");
   };

/* LOGICAL_EXPR */
/* Either a single expression (EXPR), or two expressions joined with logical
   operator (LOGICAL_OPERATOR) */
LOGICAL_EXPR: 
   EXPR | EXPR LOGICAL_OPERATOR EXPR;

/* LOGICAL_OPERATOR */
/* LOGICAL_OPERATOR */
/* Less than, more than, equal to, LE, and GE */
LOGICAL_OPERATOR: 
   '<' | '>' | "==" | LE | GE;

/* ELSE_PART */
/* Either empty, or keword else followed by instructions (STATEMENTS) */
ELSE_PART:
   /* nothing */ | KW_ELSE STATEMENTS;

%%

int main(void)
{ 
   printf("Wojciech Trapkowski\n");
   printf("yytext              Token type     Token value as string\n\n");
   return yyparse();
}

void yyerror(const char *txt)
{
   printf("Syntax error %s\n", txt);
}

void found(const char *nonterminal, const char *value)
{
   printf("===== FOUND: %s %s%s%s=====\n", nonterminal, 
          (*value) ? "'" : "", value, (*value) ? "'" : "");
}
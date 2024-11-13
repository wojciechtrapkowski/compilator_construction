/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     KW_WITH = 258,
     KW_USE = 259,
     KW_PROCEDURE = 260,
     KW_IS = 261,
     KW_CONSTANT = 262,
     KW_BEGIN = 263,
     KW_END = 264,
     KW_FOR = 265,
     KW_IN = 266,
     KW_RANGE = 267,
     KW_LOOP = 268,
     KW_PACKAGE = 269,
     KW_BODY = 270,
     KW_OUT = 271,
     KW_IF = 272,
     KW_THEN = 273,
     KW_ELSE = 274,
     KW_ARRAY = 275,
     KW_RECORD = 276,
     KW_DOWNTO = 277,
     KW_OF = 278,
     STRING_CONST = 279,
     INTEGER_CONST = 280,
     FLOAT_CONST = 281,
     CHARACTER_CONST = 282,
     ASSIGN = 283,
     RANGE = 284,
     LE = 285,
     GE = 286,
     IDENT = 287,
     NEG = 288
   };
#endif
/* Tokens.  */
#define KW_WITH 258
#define KW_USE 259
#define KW_PROCEDURE 260
#define KW_IS 261
#define KW_CONSTANT 262
#define KW_BEGIN 263
#define KW_END 264
#define KW_FOR 265
#define KW_IN 266
#define KW_RANGE 267
#define KW_LOOP 268
#define KW_PACKAGE 269
#define KW_BODY 270
#define KW_OUT 271
#define KW_IF 272
#define KW_THEN 273
#define KW_ELSE 274
#define KW_ARRAY 275
#define KW_RECORD 276
#define KW_DOWNTO 277
#define KW_OF 278
#define STRING_CONST 279
#define INTEGER_CONST 280
#define FLOAT_CONST 281
#define CHARACTER_CONST 282
#define ASSIGN 283
#define RANGE 284
#define LE 285
#define GE 286
#define IDENT 287
#define NEG 288




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 10 "ada.y"
{
  char s[MAX_STR_LEN + 1];
  int i;
  double d;
}
/* Line 1529 of yacc.c.  */
#line 121 "ada.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;


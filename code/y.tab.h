
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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
     IF = 258,
     ELSE = 259,
     FOR = 260,
     WHILE = 261,
     DO = 262,
     RETURN = 263,
     VOID = 264,
     BREAK = 265,
     CONTINUE = 266,
     SWITCH = 267,
     CASE = 268,
     DEFAULT = 269,
     CONST = 270,
     STATIC = 271,
     CLASS = 272,
     CHAR = 273,
     INT = 274,
     FLOAT = 275,
     DOUBLE = 276,
     LONG = 277,
     BOOL = 278,
     NOT = 279,
     GT = 280,
     LT = 281,
     GE = 282,
     LE = 283,
     EQ = 284,
     NE = 285,
     AND = 286,
     OR = 287,
     INC = 288,
     DEC = 289,
     PLUS = 290,
     MINUS = 291,
     MULT = 292,
     DIV = 293,
     MOD = 294,
     ASSIGN = 295,
     PLUS_ASSIGN = 296,
     MINUS_ASSIGN = 297,
     MULT_ASSIGN = 298,
     DIV_ASSIGN = 299,
     MOD_ASSIGN = 300,
     LBRACE = 301,
     RBRACE = 302,
     LBRACKET = 303,
     RBRACKET = 304,
     SEMICOLON = 305,
     COMMA = 306,
     COLON = 307,
     DOT = 308,
     QUESTION = 309,
     VARIABLE = 310,
     INT_LITERAL = 311,
     FLOAT_LITERAL = 312,
     STRING_LITERAL = 313,
     CHAR_LITERAL = 314
   };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define FOR 260
#define WHILE 261
#define DO 262
#define RETURN 263
#define VOID 264
#define BREAK 265
#define CONTINUE 266
#define SWITCH 267
#define CASE 268
#define DEFAULT 269
#define CONST 270
#define STATIC 271
#define CLASS 272
#define CHAR 273
#define INT 274
#define FLOAT 275
#define DOUBLE 276
#define LONG 277
#define BOOL 278
#define NOT 279
#define GT 280
#define LT 281
#define GE 282
#define LE 283
#define EQ 284
#define NE 285
#define AND 286
#define OR 287
#define INC 288
#define DEC 289
#define PLUS 290
#define MINUS 291
#define MULT 292
#define DIV 293
#define MOD 294
#define ASSIGN 295
#define PLUS_ASSIGN 296
#define MINUS_ASSIGN 297
#define MULT_ASSIGN 298
#define DIV_ASSIGN 299
#define MOD_ASSIGN 300
#define LBRACE 301
#define RBRACE 302
#define LBRACKET 303
#define RBRACKET 304
#define SEMICOLON 305
#define COMMA 306
#define COLON 307
#define DOT 308
#define QUESTION 309
#define VARIABLE 310
#define INT_LITERAL 311
#define FLOAT_LITERAL 312
#define STRING_LITERAL 313
#define CHAR_LITERAL 314




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 13 "parser.y"

    int ival;
    char *sval;



/* Line 1676 of yacc.c  */
#line 177 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



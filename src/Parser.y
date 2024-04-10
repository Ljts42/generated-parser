{
module Parser where

import Grammar
import Lexer
}

%name           parseCode Code
%error          { parseError }

%tokentype      { Token }

%token INDENT   { Indent }
%token DEDENT   { Dedent }
-- standart words
%token INPUT    { InputT }
%token PRINT    { PrintT }
%token RANGE    { RangeT }
%token WHILE    { WhileT }
%token FOR      { ForT }
%token INT      { IntT }
%token IF       { IfT }
%token IN       { InT }
-- bool ops
%token TRUE     { TrueT }
%token FALSE    { FalseT }
%token NOT      { NotT }
%token AND      { AndT }
%token OR       { OrT }
%token EQUAL    { EqualT }
%token NEQ      { NeqT }
%token LEQ      { LeqT }
%token LESS     { LtT }
%token GEQ      { GeqT }
%token GREATER  { GtT }
-- standart symbols
%token ASSIGN   { AssignT }
%token COLON    { ColonT }
%token COMMA    { CommaT }
%token LEFTP    { LeftP }
%token RIGHTP   { RightP }
-- int ops
%token MUL      { MulT }
%token DIV      { DivT }
%token MOD      { ModT }
%token ADD      { AddT }
%token SUB      { SubT }
-- other
%token NUMBER   { NumberT $$ }
%token VAR      { VarT $$ }
-- mod
%token NAME     { NameT $$ }
%token RETURN   { ReturnT }

%left OR
%left AND
%left NOT
%nonassoc EQUAL NEQ LEQ LESS GEQ GREATER
%left ADD SUB
%left MUL DIV MOD
%%


Code
  : Line Code                                   { $1 : $2 }
  | {- empty -}                                 { [] }

Line
  : VAR ASSIGN INT LEFTP INPUT LEFTP RIGHTP RIGHTP  { IntInput $1 }
  | VAR ASSIGN Expr                                 { Assign $1 $3 }
  | IF Expr Block                                   { If $2 $3 }
  | WHILE Expr Block                                { While $2 $3 }
  | FOR VAR IN RANGE LEFTP Expr RIGHTP Block        { For $2 $6 $8 }
  | PRINT LEFTP Expr Rest RIGHTP                    { Print ($3 : $4) }
  -- mod
  | RETURN Expr                                     { Return $2 }
  | NAME LEFTP VAR Args RIGHTP Block                { Def $1 ($3 : $4) $6 }

Args
  : COMMA VAR Args                                  { $2 : $3 }
  | {- empty -}                                     { [] }

Block : COLON INDENT Code DEDENT  { $3 }

Rest
  : COMMA Expr Rest                                 { $2 : $3 }
  | {- empty -}                                     { [] }

Expr
  : NAME LEFTP Expr Rest RIGHTP                     { Fun $1 ($3 : $4) }
  | TRUE                                            { TrueVal }
  | FALSE                                           { FalseVal }
  | NUMBER                                          { Number $1 }
  | VAR                                             { Var $1 }
  | Expr MUL Expr                                   { Binary Mul $1 $3 }
  | Expr DIV Expr                                   { Binary Div $1 $3 }
  | Expr MOD Expr                                   { Binary Mod $1 $3 }
  | Expr ADD Expr                                   { Binary Add $1 $3 }
  | Expr SUB Expr                                   { Binary Sub $1 $3 }
  | Expr EQUAL Expr                                 { Binary Equal $1 $3 }
  | Expr NEQ Expr                                   { Binary Neq $1 $3 }
  | Expr LEQ Expr                                   { Binary Leq $1 $3 }
  | Expr LESS Expr                                  { Binary Less $1 $3 }
  | Expr GEQ Expr                                   { Binary Geq $1 $3 }
  | Expr GREATER Expr                               { Binary Greater $1 $3 }
  | NOT Expr                                        { Not $2 }
  | Expr AND Expr                                   { Binary And $1 $3 }
  | Expr OR Expr                                    { Binary Or $1 $3 }
  | LEFTP Expr RIGHTP                               { Brackets $2 }

{
parseError = error "Parse error"
}

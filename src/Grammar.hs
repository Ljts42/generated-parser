module Grammar where

import           Data.List (intercalate)
import           GHC.Base  (join)

data Line = IntInput String
          | Assign String Expr
          | If Expr [Line]
          | While Expr [Line]
          | For String Expr [Line]
          | Print [Expr]
          -- mod
          | Return Expr
          | Def String [String] [Line]

instance Show Line where
  -- show f@Def {} = showLine 0 f
  show s = showLine 1 s

tab :: Int -> String
tab n = join $ replicate n "\t"

showLine :: Int -> Line -> String
showLine n (IntInput v) = tab n ++ "scanf(\"%d\", &" ++ v ++ ");"
showLine n (Assign v e) = tab n ++ v ++ " = " ++ show e ++ ";"
showLine n (If e c)     = tab n ++ "if (" ++ show e ++ ") {\n"
                       ++ intercalate "\n" (map (showLine $ n + 1) c) ++ "\n"
                       ++ tab n ++ "}"
showLine n (While e c)  = tab n ++ "while (" ++ show e ++ ") {\n"
                       ++ intercalate "\n" (map (showLine $ n + 1) c) ++ "\n"
                       ++ tab n ++ "}"
showLine n (For v e c)  = tab n ++ "for (" ++ v ++ " = 0; " ++ v ++ " < "
                       ++ show e ++ "; ++" ++ v ++ ") {\n"
                       ++ intercalate "\n" (map (showLine $ n + 1) c) ++ "\n"
                       ++ tab n ++ "}"
showLine n (Print a)    = tab n ++ "printf(\"%d" ++ join (replicate (length a - 1) " %d")
                       ++ "\\n\", " ++ intercalate ", " (map show a) ++ ");"
showLine n (Return e)   = tab n ++ "return " ++ show e ++ ";"
showLine n (Def v a c)  = tab n ++ "int " ++ v ++ "(" ++ intercalate ", " a ++ ") {\n"
                       ++ intercalate "\n" (map (showLine $ n + 1) c) ++ "\n"
                       ++ tab n ++ "}"

data Expr = TrueVal
          | Fun String [Expr]
          | FalseVal
          | Number String
          | Var String
          | Not Expr
          | Binary Binop Expr Expr
          | Brackets Expr

instance Show Expr where
  show (Fun v e) = v ++ "(" ++ intercalate ", " (map show e) ++ ")"
  show TrueVal         = "true"
  show FalseVal        = "true"
  show (Number n)      = n
  show (Var v)         = v
  show (Not e)         = "!" ++ show e
  show (Binary op a b) = show a ++ " " ++ show op ++ " " ++ show b
  show (Brackets e)    = "(" ++ show e ++ ")"

data Binop = And | Or | Mul | Div | Mod | Add | Sub
           | Equal | Neq | Leq | Less | Geq | Greater

instance Show Binop where
  show And     = "&&"
  show Or      = "||"
  show Mul     = "*"
  show Div     = "/"
  show Mod     = "%"
  show Add     = "+"
  show Sub     = "-"
  show Equal   = "=="
  show Neq     = "!="
  show Leq     = "<="
  show Less    = "<"
  show Geq     = ">="
  show Greater = ">"

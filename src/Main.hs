module Main where

import Grammar
import Lexer (scanTokens, Token (VarT))
import Parser
import Data.List (intercalate, nub)

getVariables :: [Token] -> String
getVariables tokens = intercalate ", " $ nub [name | (VarT name) <- tokens]

pythonToC :: String -> String
pythonToC input = case scanTokens input of
    Left error -> error
    Right tokens -> show tokens ++ "\n\n" ++ begin ++ code where
        variables = getVariables tokens
        begin = if variables == "" then ""
                else "int " ++ variables ++ ";\n\n"
        lines = parseCode tokens
        code = "int main() {\n"
            ++ intercalate "\n" (map show lines) ++ "\n\treturn 0;\n}"

main :: IO ()
main = do
    input <- readFile "a.py"
    putStrLn $ pythonToC input

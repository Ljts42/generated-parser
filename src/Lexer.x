{
module Lexer where
}

%wrapper "monadUserState"

$digit = 0-9
$alpha = [a-zA-Z_]
$letter = [$alpha $digit]
@tab = [\ ]{4} | \t
@func = $alpha$alpha"("
-- @func = $alpha$letter*$white*"("

tokens :-
  -- mod
  "def"$white+$alpha$letter* { \(_, _, _, s) i -> pure [NameT $ dropWhile (==' ') $ drop 3 $ take i s] }
  "return"                   { \_ _ -> pure [ReturnT] }

  -- indents
  \n@tab*             { \(_, _, _, s) i -> do
    previous <- getLexerIndent
    let current = if (take 2 s) == "\n\t" 
                then i - 1
                else (i - 1) `div` 4
    if (current > previous)
      then do
        putLexerIndent current
        pure $ replicate (current - previous) Indent
    else if (current < previous)
      then do
        putLexerIndent current
        pure $ replicate (previous - current) Dedent
    else pure [] }
  $white              ;

  -- standart words
  "input"             { \_ _ -> pure [InputT] }
  "print"             { \_ _ -> pure [PrintT] }
  "range"             { \_ _ -> pure [RangeT] }
  "while"             { \_ _ -> pure [WhileT] }
  "for"               { \_ _ -> pure [ForT] }
  "int"               { \_ _ -> pure [IntT] }
  "if"                { \_ _ -> pure [IfT] }
  "in"                { \_ _ -> pure [InT] }
  -- bool ops
  "True"              { \_ _ -> pure [TrueT] }
  "False"             { \_ _ -> pure [FalseT] }
  "not"               { \_ _ -> pure [NotT] }
  "and"               { \_ _ -> pure [AndT] }
  "or"                { \_ _ -> pure [OrT] }
  "=="                { \_ _ -> pure [EqualT] }
  "!="                { \_ _ -> pure [NeqT] }
  "<="                { \_ _ -> pure [LeqT] }
  "<"                 { \_ _ -> pure [LtT] }
  ">="                { \_ _ -> pure [GeqT] }
  ">"                 { \_ _ -> pure [GtT] }
  -- standart symbols
  "="                 { \_ _ -> pure [AssignT] }
  ":"                 { \_ _ -> pure [ColonT] }
  ","                 { \_ _ -> pure [CommaT] }
  "("                 { \_ _ -> pure [LeftP] }
  ")"                 { \_ _ -> pure [RightP] }
  -- int ops
  "*"                 { \_ _ -> pure [MulT] }
  "//"                { \_ _ -> pure [DivT] }
  "%"                 { \_ _ -> pure [ModT] }
  "+"                 { \_ _ -> pure [AddT] }
  "-"                 { \_ _ -> pure [SubT] }
  -- other
  @func   { \(_, _, _, s) i -> pure ((NameT $ reverse $ dropWhile (==' ') $ reverse $ take (i - 1) s) : [LeftP]) }
  $digit+             { \(_, _, _, s) i -> pure [NumberT $ take i s] }
  $alpha$letter*      { \(_, _, _, s) i -> pure [VarT $ take i s] }

{
data Token = Indent | Dedent
           -- mod
           | NameT String | ReturnT
           -- standart words
           | InputT | PrintT | RangeT | WhileT | ForT | IntT | IfT | InT
           -- bool ops
           | TrueT | FalseT | NotT | AndT | OrT | EqualT | NeqT | LeqT | LtT | GeqT | GtT
           -- standart symbols
           | AssignT | ColonT | CommaT | LeftP | RightP
           -- int ops
           | MulT | DivT | ModT | AddT | SubT
           -- other
           | NumberT String | VarT String | Eeof
           deriving (Show, Eq)


data AlexUserState = AlexUserState{ lexerIndent :: Int }

alexInitUserState :: AlexUserState
alexInitUserState = AlexUserState{ lexerIndent = 0 }

getLexerIndent :: Alex Int
getLexerIndent = lexerIndent <$> alexGetUserState

putLexerIndent :: Int -> Alex ()
putLexerIndent indent = do
  ust <- alexGetUserState
  alexSetUserState ust{ lexerIndent = indent }

alexEOF :: Alex [Token]
alexEOF = do
  current <- getLexerIndent
  if current /= 0
    then do
      putLexerIndent 0
      pure $ replicate current Dedent
  else pure [Eeof]

scanTokens :: String -> Either String [Token]
scanTokens input = runAlex input go >>= pure . concat
  where go = do
              output <- alexMonadScan
              if output == [Eeof]
                then pure []
              else (output :) <$> go
}

-- Mohammad Anees
-- UIN: 821009771
-- Got a lot of help from Piazza, mainly the SI and TA

module MiniLangParser (parse, start) where 

import Prelude hiding (fail)
import MiniLangSyntax
import ParserCombinators

-- Parsers for the expression language
start :: Parser Program
start = space >> program

comment = string "--" >> many (sat (/= '\n')) >> space >> return ()

-- program is many statements followed by an expression
program = many stmt >>= \s -> 
          expr >>= \e ->
          return $ Program s e

----------------
-- Statements --
----------------

-- It is important that assignment is tried last
-- We want that the alternatives tried first fail at the first token, without consuming input
stmt = skip +++ ifstmt +++ while +++ block +++ newVar1 +++ newVar2+++ assignment

skip = symbol ";" >> return Skip

ifstmt = symbol "if" >>
         parens expr >>= \c ->
         stmt >>= \t ->
         symbol "else" >>
         stmt >>= \e ->
         return $ If c t e

while = symbol "while" >>
        parens expr >>= \e ->
        stmt >>= \s ->
        return (While e s )

block = symbol "{" >>
        many stmt >>= \s ->
        symbol "}" >>
        return (Block s)

newVar1 = symbol "var " >>
         token identifier >>= \v ->
         symbol ";" >>
         return (Assignment2 v (IntLit 0)) --newVariable automatically gets a value of 0

newVar2 = symbol "var " >>
          token identifier >>= \v ->
          symbol "=" >>
          expr >>= \e ->
          symbol ";" >>
          return (Assignment2 v e)

-- make sure assignment is tried last
assignment = token identifier >>= \v ->
             symbol "=" >>
             expr >>= \e ->
             symbol ";" >> 
             return (Assignment v e) 



-----------------
-- Expressions --
-----------------

expr = composite +++ atomic

atomic = literal +++ varRef +++ parens expr

literal = intLiteral +++ boolLiteral

intLiteral = token nat >>= \i -> return $ IntLit i

boolLiteral = strue +++ sfalse

strue = symbol "true" >> return (BoolLit True)
sfalse = symbol "false" >> return (BoolLit False)

varRef = token identifier >>= \n -> return (Var n)

comparison = summation >>= \left ->
             comparisonX left

composite = comparison>>= \left ->
            compositeX left

comparisonX left
    =((symbol "<=" +++ symbol ">=" +++ symbol "<" +++ symbol ">") >>= \op ->
          summation >>= \right ->
          comparisonX $ BinOp (stringToOp op) left right)
          +++
          return left

compositeX left
    = ((symbol "==" +++ symbol "<>") >>= \op -> 
           comparison >>= \right -> 
           compositeX $ BinOp (stringToOp op) left right)
      +++
      return left



summation = term >>= \left -> 
            summationX left

summationX left = 
    ((symbol "+" +++ symbol "-") >>= \op -> 
         term >>= \right ->
         summationX $ BinOp (stringToOp op) left right)
    +++ 
    return left

term = atomic >>= \left -> 
       termX left

termX left = 
    ((symbol "*" +++ symbol "/") >>= \op ->
         atomic >>= \right ->
         termX $ BinOp (stringToOp op) left right)
    +++
    return left

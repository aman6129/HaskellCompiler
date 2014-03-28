-- Mohammad Anees
-- UIN: 821009771
-- Got a lot of help from Piazza, mainly the SI and TA

module MiniLangEvaluator where

import MiniLangSyntax

-- Expression evaluator
eval :: Env -> Expr -> Expr
eval _ (IntLit i) = IntLit i
eval _ (BoolLit b) = BoolLit b
eval env (Var n) = lookupVar env n
eval env (BinOp op a b) = primEval op (eval env a) (eval env b)
eval env (Undefined) = undefined

-- Env is an association list from variable names to expressions
-- Expressions in the environment are assumed to always be values 
type VarName = String
type Env = [(VarName, Expr)]



-- Check if a variable exists in an environment
isVarDefined :: Env -> VarName -> Bool
isVarDefined env n = n `elem` map fst env

-- Add a new variable to the environment
newVar :: Env -> VarName -> Expr -> Env
newVar env n e = (n, e):env

-- Assign to a variable.
-- If variable exists, replace its value. If it doesn't, add
-- the variable binding. Note, this implementaiton is very 
-- inefficient
assignVar1 :: Env -> VarName -> Expr -> Env
assignVar1 env n e = 
    if isVarDefined env n then
        map (\(n', e') -> if n == n' then (n, e) else (n', e')) env
    else
        error $ "Error undefined variable " ++ n

assignVar2 :: Env -> VarName -> Expr -> Env
assignVar2 env n e = 
	if isVarDefined env n then
		error $ "Error cannot redeclare variable " ++ n
	else
		newVar env n e


-- Look up the value of a variable from the environment
-- If the variable is not found, crash
lookupVar :: Env -> VarName -> Expr
lookupVar ((n, v):_) m | n == m = v
lookupVar (_:env) m = lookupVar env m
lookupVar [] m = error $ "Unknown variable " ++ m

enterBlock :: Env -> Env
enterBlock env = ("$",Undefined) : env

exitBlock :: Env -> Env
exitBlock (x:xs) = if x == ("$",Undefined) then xs else exitBlock xs
-- Execute statement
-- Statments can affect the environment, hence return a new
-- environment
exec :: Env -> Stmt -> Env
exec env Skip = env
exec env (If c t e) = 
    exec env ( if eval env c == BoolLit True then t else e )
exec env (While e s) = 
	(  			if eval env e == BoolLit True 
				then  exec (exec env s) (While e s)
				else env
	)
--exec env (Block s) =exitBlock(foldl exec (enterBlock env) s)
exec env (Block s) = foldl exec env s
exec env (Assignment v e) = assignVar1 env v (eval env e) --for assigning to existing vars
exec env (Assignment2 v e) = assignVar2 env v (eval env e) --for declaring var's

-- The frist statement is executed in the empty environment,
-- the next statement in tne environment resulting from the first
-- statement, and so ono
-- The expression of the program is evaluated in the environment
-- produced by the last statement

run :: Program -> Expr 
run (Program statements e) =
    eval (foldl exec [] statements) e





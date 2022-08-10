module Mcc.Ast (Bop, Uop, Expr, Stmt) where

import Data.Char (chr)
import Data.Ratio (denominator, numerator)
import Data.Text (Text)
import Mcc.Ast.Type (Type)
import qualified Mcc.Ast.Type as Type
import Prettyprinter

-- | Binary operators
data Bop
  = Add
  | Sub
  | Mul
  | Div
  | Pow
  | Equal
  | Neq
  | Less
  | Leq
  | Greater
  | Geq
  | And
  | Or
  | BitAnd
  | BitOr
  deriving (Show, Eq)

-- | Unary operators
data Uop
  = Neg
  | Not
  deriving (Show, Eq)

-- | An expression in Micro C
data Expr
  = Int Integer
  | String Text
  | Char Integer
  | Float Double
  | Bool Bool
  | Null
  | Id Text
  | Binop Bop Expr Expr
  | Unop Uop Expr
  | Call Text [Expr]
  | Cast Type Expr
  | Dot Expr Expr
  | Deref Expr
  | Addr Expr
  | Assign Expr Expr
  | Sizeof Type
  deriving (Show, Eq)

-- | A statement in Micro C
data Stmt
  = -- | An expression whose only purpose is its side effects
    Expr Expr
  | Block [Stmt]
  | Return Expr
  | -- | if (e1) s1 else s2
    If Expr Stmt Stmt
  | -- | for (e1; e2; e3) s
    For Expr Expr Expr Stmt
  | -- | while (e) s
    While Expr Stmt
  deriving (Show, Eq)

instance Num Expr where
  (+) = Binop Add
  (-) = Binop Sub
  (*) = Binop Mul
  negate = Unop Neg
  signum = undefined
  abs = undefined
  fromInteger = Int

instance Fractional Expr where
  (/) = Binop Div
  fromRational rat = Int (numerator rat) / Int (denominator rat)
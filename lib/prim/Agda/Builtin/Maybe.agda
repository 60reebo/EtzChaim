
module Agda.Builtin.Maybe where

data Maybe {a} (A : Set a) : Set a where
  just : A → Maybe A
  nothing : Maybe A

{-# BUILTIN MAYBE Maybe #-}

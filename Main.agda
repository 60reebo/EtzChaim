module Main where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit using (⊤; tt)
open import Agda.Builtin.String
open import Data.List.Base using (List; []; _∷_)
open import Data.String.Base as Str using (_++_)

open import Hishtalshelut.Engine.Worlds.IgulimYosherEngine using (hierarchicalTraceText)

-- Convert list of strings to a single string with newlines
toTextList : List String → String
toTextList [] = ""
toTextList (x ∷ xs) = Str._++_ x (Str._++_ "\n" (toTextList xs))

postulate
  putStrLn : String → IO ⊤
{-# COMPILE GHC putStrLn putStrLn #-}

main : IO ⊤
main = putStrLn (toTextList hierarchicalTraceText)
{-# COMPILE GHC main main #-}

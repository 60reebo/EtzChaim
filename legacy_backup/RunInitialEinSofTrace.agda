module RunInitialEinSofTrace where

open import Hishtalshelut.Engine.Worlds.EinSofEngine
open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Data.List
open import Agda.Builtin.String

postulate putStrLn : String → IO ⊤
{-# COMPILE GHC putStrLn = putStrLn #-}

join : String → List String → String
join sep [] = ""
join sep (x ∷ xs) = x Str._++_ (if null xs then "" else sep Str._++_ join sep xs)

mainEn : IO ⊤
mainEn = putStrLn (join "\n" initialTraceTextEn)

mainHe : IO ⊤
mainHe = putStrLn (join "\n" initialTraceTextHe)

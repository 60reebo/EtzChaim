{-# OPTIONS --without-K #-}
module TestReshimuCompute where

open import Agda.Primitive using (Level; lzero)
open import Data.Nat using (ℕ; zero; suc)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; omega; _+_; fromNatO)

-- בדיקה מינימלית: חיבור omega עם fromNatO של סכום
test : Ordinal lzero
test = omega + fromNatO (suc zero) 
{-# OPTIONS --without-K #-}
--------------------------------------------------
-- Math Types (Domain/Math)
--------------------------------------------------
module Hishtalshelut.Domain.Math.Types where

open import Agda.Primitive using (Level)
open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

-- | טיפוס המייצג מספרים חיוביים
data Positive : Set where
  pos : ℕ → Positive

-- | המרה ממספר טבעי למספר חיובי
fromNat : ℕ → Positive
fromNat zero = pos 1 -- להגן מפני אפס
fromNat n = pos n

-- | הוספת מספרים חיוביים
_+p_ : Positive → Positive → Positive
pos n +p pos m = pos (n + m)

-- | כפל מספרים חיוביים
_*p_ : Positive → Positive → Positive
pos n *p pos m = pos (n * m) 
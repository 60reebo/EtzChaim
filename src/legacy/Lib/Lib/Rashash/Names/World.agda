module Hishtalshelut.Domain.Rashash.Names.World where

open import Data.Nat using (ℕ)
open import Relation.Binary.PropositionalEquality using (_≡_)
open import Data.Bool using (Bool; true; false)

-- | Spiritual worlds hierarchy
data OlamName : Set where
  EinSof   : OlamName
  Atzilut  : OlamName
  Beriah   : OlamName
  Yetzirah : OlamName
  Asiyah   : OlamName

-- | Boolean equality for worlds
_≟Olam_ : OlamName → OlamName → Bool
EinSof   ≟Olam EinSof   = true
Atzilut  ≟Olam Atzilut  = true
Beriah   ≟Olam Beriah   = true
Yetzirah ≟Olam Yetzirah = true
Asiyah   ≟Olam Asiyah   = true
_ ≟Olam _              = false

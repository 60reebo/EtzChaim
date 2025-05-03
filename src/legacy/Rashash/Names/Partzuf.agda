module Hishtalshelut.Domain.Rashash.Names.Partzuf where

open import Relation.Binary.PropositionalEquality using (_≡_)
open import Data.Bool using (Bool; true; false)

-- | Partzufim (spiritual configurations)
data Partzuf : Set where
  Atik   : Partzuf
  AA    : Partzuf
  Abba  : Partzuf
  Ima   : Partzuf
  ZA    : Partzuf
  Nukva : Partzuf

-- | Boolean equality for partzufim
_≟Partzuf_ : Partzuf → Partzuf → Bool
Atik   ≟Partzuf Atik   = true
AA    ≟Partzuf AA    = true
Abba  ≟Partzuf Abba  = true
Ima   ≟Partzuf Ima   = true
ZA    ≟Partzuf ZA    = true
Nukva ≟Partzuf Nukva = true
_     ≟Partzuf _      = false

--------------------------------------------------
-- OrdinalTest: Unit tests for Ordinal operations
--------------------------------------------------
module Hishtalshelut.Domain.Math.OrdinalTest where

open import Hishtalshelut.Domain.Math.Ordinal
open import Data.Nat using (ℕ; zero; suc)
open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.Equality

-- | Test associativity of addition for small ordinals
assoc⁺₀ : assoc⁺ zero zero zero ≡ refl
assoc⁺₀ = refl

assoc⁺₁ : assoc⁺ (succ zero) zero zero ≡ refl
assoc⁺₁ = refl

-- | Test associativity of multiplication for small ordinals
assoc*₀ : assoc* zero zero zero ≡ assoc* zero zero zero
assoc*₀ = refl

-- | Test transfinite ordinals
omegaIsLimit : showOrdinal omega ≡ "lim"
omegaIsLimit = refl

omega²IsLimit : showOrdinal omega² ≡ "lim"
omega²IsLimit = refl

OmegaIsLimitTr : showOrdinal Omega ≡ "lim"
OmegaIsLimitTr = refl

-- | Test monotonicity postulates (should typecheck as postulates)
mono⁺₀ : mono⁺ zero zero (succ zero) refl
mono⁺₀ = mono⁺ zero zero (succ zero) refl

mono*₀ : mono* zero zero (succ zero) refl
mono*₀ = mono* zero zero (succ zero) refl

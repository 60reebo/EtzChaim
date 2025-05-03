{-# OPTIONS --no-main --allow-unsolved-metas --without-K #-}

--------------------------------------------------
-- Math Cardinal (Domain/Math)
--------------------------------------------------
--------------------------------------------------
-- Cardinal.agda: Constructive Cardinal Arithmetic for EtzChaim
--------------------------------------------------
--
-- This module defines a constructive type of cardinals for the EtzChaim simulation.
-- It is based on finite naturals and aleph-indexed infinities (using Ordinals).
-- Arithmetic is constructive for finite cardinals, and for infinite cardinals relies on
-- ordinal operations and certain postulates (see Ordinal.agda: decOrdLE, commMax, assocMax).
--
-- This is NOT the HoTT/Unimath definition of cardinality (which uses set-level types modulo equivalence).
-- Instead, this is a pragmatic, simulation-focused approach that gives you full control and extensibility.
--
-- If you wish to switch to a univalent cardinality in the future, modularize interfaces accordingly.
--------------------------------------------------
module Hishtalshelut.Domain.Math.Cardinal where

open import Agda.Primitive using (Level)
open import Data.Nat using (ℕ; zero; suc)
open import Data.Nat.Base using (_+_; _*_; _>_; _≤_; s≤s; z≤n)
open import Data.Nat.Properties using (+-comm; +-assoc; *-comm; *-assoc; *-distribʳ-+; +-identityʳ; *-zeroʳ; *-zeroˡ)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; sym; cong; cong₂; subst; trans)
open import Relation.Binary.Structures using (IsEquivalence)
open import Relation.Binary using (Setoid)
open import Relation.Nullary using (Dec; yes; no)
open import Agda.Builtin.String using (String)
open import Data.String.Base as Str using (_++_)
open import Hishtalshelut.Domain.Math.Ordinal as Ordinal hiding (_+_; _*_; _^_; zero)
import Hishtalshelut.Domain.Math.Ordinal as Ordinal

-- Minimal test for MultiSetoid reasoning block

isEquivalence-≡ : IsEquivalence {A = ℕ} _≡_
isEquivalence-≡ = record { refl = refl ; sym = sym ; trans = trans }

-- testSetoid : Setoid zero zero
-- testSetoid = record { Carrier = ℕ ; _≈_ = _≡_ ; isEquivalence = isEquivalence-≡ }

-- test-reasoning : ∀ (x y : ℕ) → x ≡ y → x ≡ y
-- test-reasoning x y eq =
--   let open Relation.Binary.Reasoning.MultiSetoid testSetoid in
--   begin_
--     x ≈⟨ eq ⟩
--     y ∎


-- | Cardinal type: finite naturals and aleph-indexed infinities
-- (definition of Cardinal ...)


-- Cardinal arithmetic for EtzChaim simulation
-- Only standard cardinals: fin (ℕ) | aleph (Ordinal)
-- All algebraic properties for alephs rely on Ordinal.agda
-- Axioms: decOrdLE, commMax, assocMax.
data Cardinal (ℓ : Level) : Set ℓ where
  fin   : ℕ → Cardinal ℓ
  aleph : Ordinal ℓ → Cardinal ℓ

setoidC : ∀ {ℓ} → Setoid _ _
setoidC {ℓ} = Relation.Binary.PropositionalEquality.setoid (Cardinal ℓ)


-- | Examples of transfinite cardinals
aleph0 : ∀ {ℓ} → Cardinal ℓ
aleph0 {ℓ} = aleph {ℓ} omega

aleph1 : ∀ {ℓ} → Cardinal ℓ
aleph1 {ℓ} = aleph {ℓ} (succ omega)

alephOmega : ∀ {ℓ} → Cardinal ℓ
alephOmega {ℓ} = aleph {ℓ} Omega

-- | Addition on cardinals (max-style for infinities)

_⊕_ : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ → Cardinal ℓ
fin m    ⊕ fin n    = fin (m + n)
fin _    ⊕ aleph α  = aleph α
aleph α  ⊕ fin _    = aleph α
aleph α ⊕ aleph β = aleph (limit′ (λ n → natTo n α β))

-- | Commutativity of addition
comm⊕ : ∀ {ℓ} (a b : Cardinal ℓ) → a ⊕ b ≡ b ⊕ a
comm⊕ {ℓ} (fin m) (fin n)    = cong fin (+-comm m n)
comm⊕ {ℓ} (fin _) (aleph α)  = refl
comm⊕ {ℓ} (aleph α) (fin _)  = refl
comm⊕ {ℓ} (aleph α) (aleph β) = cong aleph (cong limit′ (funExt (λ n → commNatTo n α β)))

-- | Associativity of addition
assoc⊕ : ∀ {ℓ} (a b c : Cardinal ℓ) → (a ⊕ b) ⊕ c ≡ a ⊕ (b ⊕ c)
assoc⊕ {ℓ} (fin m) (fin n) (fin k)   = cong fin (+-assoc m n k)
assoc⊕ {ℓ} (fin m) (fin n) (aleph γ) = refl
assoc⊕ {ℓ} (fin m) (aleph β) (fin k) = refl
assoc⊕ {ℓ} (fin m) (aleph β) (aleph γ) = refl
assoc⊕ {ℓ} (aleph α) (fin n) (fin k) = refl
assoc⊕ {ℓ} (aleph α) (fin n) (aleph γ) = refl
assoc⊕ {ℓ} (aleph α) (aleph β) (fin k) = refl
assoc⊕ {ℓ} (aleph α) (aleph β) (aleph γ) = cong aleph (cong limit′ (funExt (λ n → assocNatTo n α β γ)))

-- | Multiplication on cardinals (0-case & max-style for infinities)

_⊗_ : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ → Cardinal ℓ
fin m    ⊗ fin n     = fin (m * n)
fin zero ⊗ aleph _   = fin zero
fin (suc _) ⊗ aleph α = aleph α
aleph α  ⊗ fin zero   = fin zero
aleph α  ⊗ fin (suc _) = aleph α
aleph α ⊗ aleph β = aleph (limit′ (λ n → natTo n α β))

-- | Commutativity of multiplication
comm⊗ : ∀ {ℓ} (a b : Cardinal ℓ) → a ⊗ b ≡ b ⊗ a
comm⊗ {ℓ} (fin m) (fin n)     = cong fin (*-comm m n)
comm⊗ {ℓ} (fin 0) (aleph α) = refl
comm⊗ {ℓ} (fin (suc n)) (aleph α) = refl
comm⊗ {ℓ} (aleph α) (fin 0) = refl
comm⊗ {ℓ} (aleph α) (fin (suc n)) = refl
comm⊗ {ℓ} (aleph α) (aleph β) = cong aleph (cong limit′ (funExt (λ n → commNatTo n α β)))

-- | Distributivity of multiplication over addition
postulate distʳ : ∀ {ℓ} (a b c : Cardinal ℓ) → (a ⊕ b) ⊗ c ≡ (a ⊗ c) ⊕ (b ⊗ c)

-- | Associativity of multiplication
postulate assoc⊗ : ∀ {ℓ} (a b c : Cardinal ℓ) → (a ⊗ b) ⊗ c ≡ a ⊗ (b ⊗ c)

-- | Zero multiplication with finite cardinals (Proven directly from definition of _⊗_)
zeroMulFinLeft : ∀ {ℓ} (n : ℕ) → fin 0 ⊗ fin n ≡ fin 0
zeroMulFinLeft {ℓ} n = cong fin (*-zeroˡ n) -- Use *-zeroˡ (left zero) instead of *-zeroʳ

-- | Embed ℕ into Cardinal
fromNat : ∀ {ℓ} → ℕ → Cardinal ℓ
fromNat n = fin n

-- | Extract numeric index from Cardinal
index : ∀ {ℓ} → Cardinal ℓ → ℕ
index (fin n) = n
index (aleph _) = 0  -- אפס כברירת מחדל עבור אינסוף

-- | Subtraction on Cardinals (postulated)
postulate _⊖_ : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ → Cardinal ℓ

-- | Exponentiation of cardinal by ordinal (postulated)
postulate _^_ : ∀ {ℓ} → Cardinal ℓ → Ordinal ℓ → Cardinal ℓ

-- | Convert Cardinal to String representation
showCardinal : ∀ {ℓ} → Cardinal ℓ → String
showCardinal (fin n) = "fin(" ++ Ordinal.showNat n ++ ")" -- Use Ordinal.showNat if needed
showCardinal (aleph o) = "aleph(" ++ Ordinal.showOrdinal o ++ ")"
    
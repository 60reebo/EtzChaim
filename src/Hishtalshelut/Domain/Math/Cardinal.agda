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
open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _*_)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.String using (String)

postulate _++_ : String → String → String
open import Hishtalshelut.Domain.Math.Ordinal as Ordinal hiding (_⊕_; _⊗_; _^_; zero; _++_)
import Hishtalshelut.Domain.Math.Ordinal as Ordinal

-- | Cardinal type: finite naturals and aleph-indexed infinities
data Cardinal (ℓ : Level) : Set ℓ where
  fin   : Nat → Cardinal ℓ
  aleph : Ordinal ℓ → Cardinal ℓ

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

-- | Associativity and commutativity for finite parts are postulated to avoid stdlib dependencies
postulate
  +-assoc : ∀ (m n k : Nat) → m + (n + k) ≡ (m + n) + k
  +-comm  : ∀ (m n : Nat) → m + n ≡ n + m
  *-comm  : ∀ (m n : Nat) → m * n ≡ n * m
  *-assoc : ∀ (m n k : Nat) → m * (n * k) ≡ (m * n) * k
  *-zeroˡ : ∀ (n : Nat) → 0 * n ≡ 0
  *-zeroʳ : ∀ (n : Nat) → n * 0 ≡ 0

-- | Multiplication on cardinals (0-case & max-style for infinities)
_⊗_ : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ → Cardinal ℓ
fin m    ⊗ fin n     = fin (m * n)
fin zero ⊗ aleph _   = fin zero
fin (suc _) ⊗ aleph α = aleph α
aleph α  ⊗ fin zero   = fin zero
aleph α  ⊗ fin (suc _) = aleph α
aleph α ⊗ aleph β = aleph (limit′ (λ n → natTo n α β))

-- | Zero multiplication with finite cardinals
zeroMulFinLeft : ∀ {ℓ} (n : Nat) → fin 0 ⊗ fin n ≡ fin 0
zeroMulFinLeft {ℓ} n = refl

-- | Embed Nat into Cardinal
fromNat : ∀ {ℓ} → Nat → Cardinal ℓ
fromNat n = fin n

-- | Extract numeric index from Cardinal
index : ∀ {ℓ} → Cardinal ℓ → Nat
index (fin n) = n
index (aleph _) = 0

-- | Subtraction on Cardinals (postulated)
postulate _⊖_ : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ → Cardinal ℓ

-- | Exponentiation of cardinal by ordinal (postulated)
postulate _^_ : ∀ {ℓ} → Cardinal ℓ → Ordinal ℓ → Cardinal ℓ

-- | Convert Cardinal to String representation
showCardinal : ∀ {ℓ} → Cardinal ℓ → String
showCardinal (fin n) = _++_ "fin(" (_++_ (Ordinal.showNat n) ")")
showCardinal (aleph o) = _++_ "aleph(" (_++_ (Ordinal.showOrdinal o) ")")
    
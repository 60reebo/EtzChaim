module Hishtalshelut.Domain.Math.TestOrdinalMonotonicity where

open import Agda.Primitive using (Level)
open import Data.Nat using (ℕ)
open import Data.Product using (Σ)

-- Minimal Ordinal type

data Ordinal (ℓ : Level) : Set ℓ where
  zero  : Ordinal ℓ
  succ  : Ordinal ℓ → Ordinal ℓ
  limit : (ℕ → Ordinal ℓ) → Ordinal ℓ

-- Minimal ≤ relation

data _≤_ {ℓ : Level} : Ordinal ℓ → Ordinal ℓ → Set ℓ where
  zero≤ : ∀ {b} → zero ≤ b
  suc≤  : ∀ {a b} (p : a ≤ b) → succ a ≤ succ b
  supL  : ∀ {f b} → (∀ n → f n ≤ b) → limit f ≤ b
  supR  : ∀ {a f} (p : Σ ℕ (λ n → a ≤ f n)) → a ≤ limit f

-- Dummy addition (not used)
_+_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
_+_ zero b = b
_+_ (succ a) b = succ (a + b)
_+_ (limit f) b = limit (λ n → f n + b)

postulate
  monoLplus : ∀ {ℓ} → (x y z : Ordinal ℓ) → x ≤ y → x + z ≤ y + z

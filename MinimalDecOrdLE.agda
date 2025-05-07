module MinimalDecOrdLE where

open import Agda.Primitive using (Level)
open import Relation.Nullary using (Dec; yes; no)

-- Minimal Ordinal type
data Ordinal (ℓ : Level) : Set ℓ where
  zero : Ordinal ℓ
  succ : Ordinal ℓ → Ordinal ℓ

-- Minimal ≤ relation
data _≤_ {ℓ : Level} : Ordinal ℓ → Ordinal ℓ → Set ℓ where
  zero≤ : ∀ {b} → zero ≤ b
  suc≤  : ∀ {a b} (p : a ≤ b) → succ a ≤ succ b

-- Postulate for decidability
postulate
decOrdLE : ∀ {ℓ} (x y : Ordinal ℓ) → Dec (x ≤ y)

_≤?_ : ∀ {ℓ} (x y : Ordinal ℓ) → Dec (x ≤ y)
_≤?_ = decOrdLE

-- max using ≤?
postulate
  max : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ

-- Example usage (should not cause meta error if Agda supports this pattern)
test : Ordinal _
test = max zero zero

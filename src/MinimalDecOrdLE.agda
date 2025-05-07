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

-- מימוש החלטיות של ≤ על אורדינלים מינימליים

decOrdLE : ∀ {ℓ} (x y : Ordinal ℓ) → Dec (x ≤ y)
decOrdLE zero       y          = yes zero≤
decOrdLE (succ _)   zero       = no (λ ())
decOrdLE (succ x)   (succ y) with decOrdLE x y
... | yes p = yes (suc≤ p)
... | no np = no (λ { (suc≤ p) → np p })

_≤?_ : ∀ {ℓ} (x y : Ordinal ℓ) → Dec (x ≤ y)
_≤?_ = decOrdLE

-- מימוש max קונסטרוקטיבי

max : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
max {ℓ} x y with decOrdLE {ℓ} x y
... | yes _ = y
... | no  _ = x

-- Example usage (should not cause meta error if Agda supports this pattern)
test : Ordinal _
test = max zero zero

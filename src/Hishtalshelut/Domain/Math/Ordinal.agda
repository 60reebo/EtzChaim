{-# OPTIONS --no-main --without-K #-}

--------------------------------------------------
-- Math Ordinal (Domain/Math)
--------------------------------------------------
{- |
מודול זה מגדיר את מבנה האורדינלים ופעולות עליהם.
-}
module Hishtalshelut.Domain.Math.Ordinal where

open import Agda.Primitive using (Level)
open import Agda.Builtin.String using (String)
postulate _++_ : String → String → String
open import Agda.Builtin.Nat using (Nat; zero; suc) ; open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.Sigma using (Σ; _,_)
open import Agda.Builtin.Maybe using (Maybe; just; nothing)

-- | Function extensionality (postulated)
postulate
  funExt : ∀ {ℓ ℓ'} {A : Set ℓ} {B : Set ℓ'} {f g : A → B} → (∀ x → f x ≡ g x) → f ≡ g

-- | Iterate f n times
iterate : ∀ {ℓ} {A : Set ℓ} → (A → A) → ℕ → A → A
iterate f zero x = x
iterate f (suc n) x = iterate f n (f x)

-- | Ordinal type: zero, successor, limit
data Ordinal (ℓ : Level) : Set ℓ where
  zero    : Ordinal ℓ
  succ    : Ordinal ℓ → Ordinal ℓ
  limit   : (ℕ → Ordinal ℓ) → Ordinal ℓ

-- | Helper to lift limit to be level-polymorphic
limit′ : ∀ {ℓ} → (ℕ → Ordinal ℓ) → Ordinal ℓ
limit′ {ℓ} f = limit f

-- | Ordinal addition
infixl 6 _⊕_
_⊕_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
zero  ⊕ b = b
succ a ⊕ b = succ (a ⊕ b)
limit f ⊕ b = limit (λ n → f n ⊕ b)

-- | Ordinal multiplication
infixl 7 _⊗_
_⊗_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
zero  ⊗ b = zero
succ a ⊗ b = b ⊕ (a ⊗ b)
limit f ⊗ b = limit (λ n → f n ⊗ b)

-- | Ordinal exponentiation
infixr 8 _^_
_^_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
a ^ zero       = succ zero
a ^ (succ b)   = a ⊗ (a ^ b)
a ^ (limit f)  = limit (λ n → a ^ (f n))

-- Constants and helpers
omega : ∀ {ℓ} → Ordinal ℓ
omega = limit (λ n → iterate succ n zero)

omega² : ∀ {ℓ} → Ordinal ℓ
omega² = limit (λ n → iterate (λ x → omega + x) n zero)

fromNatO : ∀ {ℓ} → ℕ → Ordinal ℓ
fromNatO n = iterate succ n zero

Omega : ∀ {ℓ} → Ordinal ℓ
Omega = limit (λ n → omega ^ succ (fromNatO n))

-- Basic show functions
showOrdinal : ∀ {ℓ} → Ordinal ℓ → String
showOrdinal zero = "0"
showOrdinal (succ o) = "S(" _++_ (showOrdinal o) _++_ ")"
showOrdinal (limit f) with f zero
... | o = "lim(" _++_ (showOrdinal o) _++_ ",...)"

showNat : ℕ → String
showNat zero = "0"
showNat (suc n) = "S(" _++_ (showNat n) _++_ ")"

-- Predicates
isLimit : ∀ {ℓ} → Ordinal ℓ → Bool
isLimit zero = false
isLimit (succ _) = false
isLimit (limit _) = true

isFinite : ∀ {ℓ} → Ordinal ℓ → Bool
isFinite zero = true
isFinite (succ o) = isFinite o
isFinite (limit _) = false

-- Algebraic laws (postulated or simplified)
postulate
  assoc⁺ : ∀ {ℓ} (a b c : Ordinal ℓ) → (a + b) + c ≡ a + (b + c)
  distrib*+ : ∀ {ℓ} (a b c : Ordinal ℓ) → (a + b) * c ≡ (a * c) + (b * c)
  assoc* : ∀ {ℓ} (a b c : Ordinal ℓ) → ((a * b) * c) ≡ (a * (b * c))

infix 4 _≤_
data _≤_ {ℓ} : Ordinal ℓ → Ordinal ℓ → Set ℓ where
  zero≤ : {b : Ordinal ℓ} → zero ≤ b
  suc≤  : {a b : Ordinal ℓ} → a ≤ b → succ a ≤ succ b
  supL  : {f : ℕ → Ordinal ℓ} {b : Ordinal ℓ} → (∀ n → f n ≤ b) → limit f ≤ b
  supR  : {a : Ordinal ℓ} {f : ℕ → Ordinal ℓ} → Σ ℕ (λ n → a ≤ f n) → a ≤ limit f

postulate 
  refl≤  : ∀ {ℓ} {a : Ordinal ℓ} → a ≤ a
  trans≤ : ∀ {ℓ} {a b c : Ordinal ℓ} → a ≤ b → b ≤ c → a ≤ c

-- Decision and boolean comparison (postulated)
postulate decOrdLE : ∀ {ℓ} (a b : Ordinal ℓ) → Bool

_≤?_ : ∀ {ℓ} → (a b : Ordinal ℓ) → Bool
a ≤? b = decOrdLE a b

ordLeq : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
ordLeq a b with a ≤? b
... | true  = true
... | false = false

-- Simple comparison (finite-first heuristic)
simpleOrdLeq : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
simpleOrdLeq zero _ = true
simpleOrdLeq (succ a) zero = false
simpleOrdLeq (succ a) (succ b) = simpleOrdLeq a b
simpleOrdLeq (succ a) (limit f) = true
simpleOrdLeq (limit f) zero = false
simpleOrdLeq (limit f) (succ b) = false
simpleOrdLeq (limit f) (limit g) = false

-- Monotonicity (postulated)
postulate
  monoLplus : ∀ {ℓ} → (x y z : Ordinal ℓ) → x ≤ y → (x + z) ≤ (y + z)
  mono*     : ∀ {ℓ} → (a b c : Ordinal ℓ) → b ≤ c → (a * b) ≤ (a * c)
  monoL*    : ∀ {ℓ} → (a b c : Ordinal ℓ) → a ≤ b → (a * c) ≤ (b * c)
  +-mono    : ∀ {ℓ} (x₁ y₁ x₂ y₂ : Ordinal ℓ) → x₁ ≤ y₁ → x₂ ≤ y₂ → (x₁ + x₂) ≤ (y₁ + y₂)

-- Max and helpers
maxO : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
maxO zero b = b
maxO a zero = a
maxO (succ a) (succ b) = succ (maxO a b)
maxO (limit f) (limit g) = limit (λ n → maxO (f n) (g n))
maxO (succ a) (limit g) = limit (λ n → maxO (succ a) (g n))
maxO (limit f) (succ b) = limit (λ n → maxO (f n) (succ b))

natTo : ∀ {ℓ} → ℕ → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
natTo n α β = maxO (fromNatO n) (maxO α β)

postulate
  limitNatToAssoc : ∀ {ℓ} (α β γ : Ordinal ℓ) →
    maxO (limit (λ m → natTo m α β)) γ ≡ maxO α (limit (λ m → natTo m β γ))
  maxSuccAssoc : ∀ {ℓ} (a b c : Ordinal ℓ) → maxO (maxO a b) c ≡ maxO a (maxO b c)
  assocMaxO-helper : ∀ {ℓ} → (o : Ordinal ℓ) → (a b : Ordinal ℓ) →
                    maxO (succ (maxO a b)) o ≡ maxO (succ a) (maxO (succ b) o)
  assocMaxO : ∀ {ℓ} (a b c : Ordinal ℓ) → maxO (maxO a b) c ≡ maxO a (maxO b c)

commMaxO : ∀ {ℓ} (a b : Ordinal ℓ) → maxO a b ≡ maxO b a
commMaxO zero zero = refl
commMaxO zero (succ b) = refl
commMaxO zero (limit g) = refl
commMaxO (succ a) zero = refl
commMaxO (succ a) (succ b) = refl
commMaxO (limit f) zero = refl
commMaxO (limit f) (limit g) = refl
commMaxO (succ a) (limit g) = refl
commMaxO (limit f) (succ b) = refl

maxZeroAssoc : ∀ {ℓ} (a b : Ordinal ℓ) → maxO (maxO zero a) b ≡ maxO zero (maxO a b)
maxZeroAssoc a b = refl

maxZeroLeft : ∀ {ℓ} (a : Ordinal ℓ) → maxO zero a ≡ a
maxZeroLeft a = refl

maxZeroRight : ∀ {ℓ} (a : Ordinal ℓ) → maxO a zero ≡ a
maxZeroRight zero = refl
maxZeroRight (succ a) = refl
maxZeroRight (limit f) = refl

commNatTo : ∀ {ℓ} (n : ℕ) (α β : Ordinal ℓ) → natTo n α β ≡ natTo n β α
commNatTo n α β = refl

assocNatTo : ∀ {ℓ} (n : ℕ) (α β γ : Ordinal ℓ) → 
             natTo n (limit′ (λ m → natTo m α β)) γ ≡ natTo n α (limit′ (λ m → natTo m β γ))
assocNatTo n α β γ = refl

limit≤limit : ∀ {ℓ} {f g : ℕ → Ordinal ℓ} → (∀ n → f n ≤ g n) → limit f ≤ limit g
limit≤limit {f = f} {g} f≤g = supL (λ n → f≤g n)

monoRplus : ∀ {ℓ} (x y z : Ordinal ℓ) → x ≤ y → (z + x) ≤ (z + y)
monoRplus x y zero x≤y = x≤y
monoRplus x y (succ z') x≤y = suc≤ (monoRplus x y z' x≤y)
monoRplus x y (limit h) x≤y = supL (λ n → monoRplus x y (h n) x≤y)

mono⁺ʳ : ∀ {ℓ} (a b c : Ordinal ℓ) → b ≤ c → (a + b) ≤ (a + c)
mono⁺ʳ a b c b≤c = monoRplus b c a b≤c

                                                             
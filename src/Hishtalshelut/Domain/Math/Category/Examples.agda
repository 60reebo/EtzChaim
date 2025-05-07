{-# OPTIONS --no-main --without-K #-}

module Hishtalshelut.Domain.Math.Category.Examples where

open import Agda.Primitive using (Level; _⊔_; lsuc)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Data.Nat using (ℕ; zero; suc)
open import Data.Nat.Properties using (≤-refl; ≤-trans)
open import Category.Core using (Category; _⟶_; id; _∘_; id-left; id-right; assoc)

-- | Example 1: Category of sets (objects = Set o, morphisms = functions)
SetCategory : ∀ {o ℓ} → Category {o = o} {ℓ = ℓ}
SetCategory {o}{ℓ} = record
  { Obj     = Set o
  ; _⟶_     = λ A B → A → B
  ; id      = λ {A} x → x
  ; _∘_     = λ {A}{B}{C} (g : B → C) (f : A → B) x → g (f x)
  ; id-left  = λ {A}{B} (f : A → B) → refl
  ; id-right = λ {A}{B} (f : A → B) → refl
  ; assoc    = λ {A}{B}{C}{D} (h : C → D) (g : B → C) (f : A → B) → refl
  }

-- | Example 2: Poset category on ℕ (objects = ℕ, morphisms = ≤)
Posetℕ : Category {o = zero} {ℓ = zero}
Posetℕ = record
  { Obj     = ℕ
  ; _⟶_     = λ m n → m ≤ n
  ; id      = λ {n} → ≤-refl {n}
  ; _∘_     = λ {m}{n}{p} (g : n ≤ p) (f : m ≤ n) → ≤-trans f g
  ; id-left  = λ {m}{n} (f : m ≤ n) → refl
  ; id-right = λ {m}{n} (f : m ≤ n) → refl
  ; assoc    = λ {a}{b}{c}{d} (h : c ≤ d) (g : b ≤ c) (f : a ≤ b) → refl
  }

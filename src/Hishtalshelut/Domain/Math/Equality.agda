{-# OPTIONS --without-K #-}
--------------------------------------------------
-- Math Equality (Domain/Math)
--------------------------------------------------
module Hishtalshelut.Domain.Math.Equality where

open import Agda.Primitive using (Level; _⊔_)
open import Relation.Binary.PropositionalEquality as Eq public using (_≡_; refl; sym; trans; cong; cong₂; subst)
open Eq.≡-Reasoning public

-- | Function extensionality
postulate
  funExt : ∀ {a b} {A : Set a} {B : A → Set b} {f g : (x : A) → B x} → 
          (∀ x → f x ≡ g x) → f ≡ g 
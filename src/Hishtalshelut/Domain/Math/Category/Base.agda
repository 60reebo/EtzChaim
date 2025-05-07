{-# OPTIONS --no-main --without-K #-}

module Hishtalshelut.Domain.Math.Category.Base where

open import Agda.Primitive using (Level; _⊔_; lsuc)

-- Basic categorical structures
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

record Category (o ℓ : Level) : Set (lsuc (o ⊔ ℓ)) where
  field
    Obj      : Set o
    _⟶_      : Obj → Obj → Set ℓ
    id       : ∀ {A} → A ⟶ A
    _∘_      : ∀ {A B C} → (B ⟶ C) → (A ⟶ B) → A ⟶ C
    id-left  : ∀ {A B} (f : A ⟶ B) → _∘_ id f ≡ f
    id-right : ∀ {A B} (f : A ⟶ B) → _∘_ f id ≡ f
    assoc    : ∀ {A B C D} (h : C ⟶ D) (g : B ⟶ C) (f : A ⟶ B) → _∘_ h (_∘_ g f) ≡ _∘_ (_∘_ h g) f

record Functor {o₁ ℓ₁ o₂ ℓ₂ : Level} (C₁ : Category o₁ ℓ₁) (C₂ : Category o₂ ℓ₂)
  : Set (lsuc ((o₁ ⊔ ℓ₁) ⊔ (o₂ ⊔ ℓ₂))) where
  field
    F-Obj : Category.Obj C₁ → Category.Obj C₂
    F-Mor : ∀ {A B} → Category._⟶_ C₁ A B → Category._⟶_ C₂ (F-Obj A) (F-Obj B)

record NaturalTransformation {o₁ ℓ₁ o₂ ℓ₂ : Level}
  {C₁ : Category o₁ ℓ₁} {C₂ : Category o₂ ℓ₂}
  (F G : Functor C₁ C₂) : Set (lsuc ((o₁ ⊔ ℓ₁) ⊔ (o₂ ⊔ ℓ₂))) where
  field
    η : ∀ {A} → Category._⟶_ C₂ (Functor.F-Obj F A) (Functor.F-Obj G A)

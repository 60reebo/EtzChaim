--------------------------------------------------
-- CardinalTest: Unit tests for Cardinal operations
--------------------------------------------------
module Hishtalshelut.Domain.Math.CardinalTest where

open import Hishtalshelut.Domain.Math.Cardinal
open import Data.Nat using (ℕ; zero; suc)
open import Agda.Builtin.Equality

-- | Aliases for convenience
zeroC : ∀ {ℓ} → Cardinal ℓ
zeroC {ℓ} = fin 0

oneC : ∀ {ℓ} → Cardinal ℓ
oneC {ℓ} = fin 1

twoC : ∀ {ℓ} → Cardinal ℓ
twoC {ℓ} = fin 2

-- | Basic addition tests
addFinFin : ∀ {ℓ} → (fin 2 ⊕ fin 5) ≡ fin 7
addFinFin = refl

addFinAleph : ∀ {ℓ} → (fin 3 ⊕ aleph0 {ℓ}) ≡ aleph0 {ℓ}
addFinAleph = refl

addAlephFin : ∀ {ℓ} → (aleph1 {ℓ} ⊕ fin 4) ≡ aleph1 {ℓ}
addAlephFin = refl

-- | Basic multiplication tests
mulFinFin : ∀ {ℓ} → (fin 3 ⊗ fin 4) ≡ fin 12
mulFinFin = refl

mulFinAleph : ∀ {ℓ} → (fin 5 ⊗ aleph1 {ℓ}) ≡ aleph1 {ℓ}
mulFinAleph = refl

mulAlephFin : ∀ {ℓ} → (alephOmega {ℓ} ⊗ fin 2) ≡ alephOmega {ℓ}
mulAlephFin = refl

-- | Algebraic properties (should typecheck)
commAdd : ∀ {ℓ} → (a b : Cardinal ℓ) → a ⊕ b ≡ b ⊕ a
commAdd {ℓ} = comm⊕

assocAdd : ∀ {ℓ} → (a b c : Cardinal ℓ) → (a ⊕ b) ⊕ c ≡ a ⊕ (b ⊕ c)
assocAdd {ℓ} = assoc⊕

commMul : ∀ {ℓ} → (a b : Cardinal ℓ) → a ⊗ b ≡ b ⊗ a
commMul {ℓ} = comm⊗

assocMul : ∀ {ℓ} → (a b c : Cardinal ℓ) → (a ⊗ b) ⊗ c ≡ a ⊗ (b ⊗ c)
assocMul {ℓ} = assoc⊗

distRight : ∀ {ℓ} → (a b c : Cardinal ℓ) → (a ⊕ b) ⊗ c ≡ (a ⊗ c) ⊕ (b ⊗ c)
distRight {ℓ} = distʳ

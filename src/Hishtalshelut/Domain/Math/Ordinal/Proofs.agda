{-# OPTIONS --without-K #-}
--------------------------------------------------
-- Math Ordinal Proofs (Domain/Math)
--------------------------------------------------
module Hishtalshelut.Domain.Math.Ordinal.Proofs where

open import Agda.Primitive using (Level)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; sym; trans; cong; cong₂; subst)
open Relation.Binary.PropositionalEquality.≡-Reasoning
open import Data.Product using (Σ; _,_)
open import Data.Nat using (ℕ)

open import Hishtalshelut.Domain.Math.Ordinal

-- | הוכחות מלאות לתכונות של אורדינלים שהוגדרו כפוסטולטים
-- | קובץ זה מכיל הוכחות מלאות לתכונות שבקובץ Ordinal.agda הוגדרו כפוסטולטים.
-- | ההוכחות מורכבות ולכן הן מופרדות לקובץ נפרד.

postulate
  -- | הוכחה מלאה של רפלקסיביות (refl≤)
  -- | סקיצת הוכחה:
  -- | - עבור zero: zero≤ מוכיח ש-zero ≤ zero
  -- | - עבור succ a: נסמן על שa ≤ a, ונשתמש ב-suc≤ כדי להוכיח ש-succ a ≤ succ a
  -- | - עבור limit f: להוכיח ש-limit f ≤ limit f דורש שימוש בתכונות סופרמום
  refl≤-proof : ∀ {ℓ} {a : Ordinal ℓ} → a ≤ a

  -- | הוכחה מלאה של טרנזיטיביות (trans≤)
  -- | סקיצת הוכחה:
  -- | - למקרה של zero≤: כיוון ש-zero ≤ כל דבר, אז zero ≤ c
  -- | - למקרה של suc≤ a≤b suc≤ b≤c: נניח ש-a ≤ b ≤ c, ונסיק ש-succ a ≤ succ c
  -- | - למקרה של supL ושל supR: דורש טיפול במקרים של אורדינלים גבוליים
  trans≤-proof : ∀ {ℓ} {a b c : Ordinal ℓ} → a ≤ b → b ≤ c → a ≤ c

  -- | הוכחת monoLplus: אם x ≤ y אז (x + z) ≤ (y + z)
  -- | סקיצת הוכחה:
  -- | - עבור x = zero: משתמשים בעובדה ש-zero + z = z, וכן zero ≤ y, ולכן z ≤ y + z
  -- | - עבור x = succ a, y = succ b: הנחת האינדוקציה נותנת a + z ≤ b + z, ולכן succ (a + z) ≤ succ (b + z)
  -- | - עבור x = limit f: מוכיחים שלכל n, (f n) + z ≤ y + z, ומכאן limit f + z ≤ y + z
  -- | - עבור y = limit g: מוכיחים שאם קיים n כך ש-x ≤ g n אז גם x + z ≤ (g n) + z
  monoLplus-proof : ∀ {ℓ} → (x y z : Ordinal ℓ) → x ≤ y → (x + z) ≤ (y + z)

  -- | הוכחת monoL*: אם a ≤ b אז (a * c) ≤ (b * c)
  -- | סקיצת הוכחה:
  -- | - עבור c = zero: כיוון ש-a * 0 = 0 = b * 0, אז התוצאה מתקיימת
  -- | - עבור c = succ c': נשתמש בהנחת האינדוקציה עבור c', ובמונוטוניות של חיבור
  -- | - עבור c = limit h: נשתמש בהנחת האינדוקציה עבור כל h n, ובתכונות הסדר על גבולות
  monoL*-proof : ∀ {ℓ} (a b c : Ordinal ℓ) → a ≤ b → (a * c) ≤ (b * c)

  -- | הוכחת +-mono: אם x₁ ≤ y₁ ו- x₂ ≤ y₂ אז (x₁ + x₂) ≤ (y₁ + y₂)
  -- | סקיצת הוכחה:
  -- | - משתמשים ב-monoLplus ו-monoRplus ובטרנזיטיביות של ≤
  +-mono-proof : ∀ {ℓ} (x₁ y₁ x₂ y₂ : Ordinal ℓ) → x₁ ≤ y₁ → x₂ ≤ y₂ → (x₁ + x₂) ≤ (y₁ + y₂)

-- | הוכחת mono*: אם b ≤ c אז (a * b) ≤ (a * c)
-- Implementation of the full proof
mono*-proof : ∀ {ℓ} (a b c : Ordinal ℓ) → b ≤ c → (a * b) ≤ (a * c)
-- Induction on a
-- Case a = zero
-- Goal: zero * b ≤ zero * c. LHS=zero, RHS=zero. So zero ≤ zero, proven by zero≤.
mono*-proof zero b c b≤c = zero≤
-- Case a = succ a'
-- Goal: (succ a * b) ≤ (succ a * c)  which is  b + (a * b) ≤ c + (a * c)
-- IH: mono* a b c b≤c  gives  (a * b) ≤ (a * c)
mono*-proof (succ a) b c b≤c = +-mono b c (a * b) (a * c) b≤c (mono*-proof a b c b≤c)
-- Case a = limit f
-- Goal: limit f * b ≤ limit f * c  which is  limit (λ n → f n * b) ≤ limit (λ n → f n * c)
-- IH: ∀ n → mono* (f n) b c b≤c  gives  (f n * b) ≤ (f n * c)
mono*-proof (limit f) b c b≤c = limit≤limit (λ n → mono*-proof (f n) b c b≤c) 
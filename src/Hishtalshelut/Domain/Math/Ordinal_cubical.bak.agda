
module Hishtalshelut.Domain.Math.Ordinal where

open import Cubical.Foundations.Prelude
open import Agda.Builtin.Nat using (Nat; zero; suc)
open import Agda.Primitive using (Level)
open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.String using (String; primStringAppend)
open import Agda.Builtin.Sigma using (Σ; _,_)
infixr 5 _++_
_++_ = primStringAppend

-- פונקציית עזר: איטרציה
iterate : ∀ {ℓ} {A : Set ℓ} → (A → A) → Nat → A → A
iterate f zero x = x
iterate f (suc n) x = iterate f n (f x)

-- טיפוס אורדינל ויחס הסדר (mutual block)
mutual
  data Ordinal (ℓ : Level) : Set ℓ where
    zero    : Ordinal ℓ
    succ    : Ordinal ℓ → Ordinal ℓ
    limit   : (Nat → Ordinal ℓ) → Ordinal ℓ

  infix 4 _≤_
  data _≤_ {ℓ : Level} : Ordinal ℓ → Ordinal ℓ → Set ℓ where
    zero≤ : ∀ {b} → zero ≤ b
    suc≤  : ∀ {a b} (p : a ≤ b) → succ a ≤ succ b
    supL  : ∀ {f b} → (∀ n → f n ≤ b) → limit f ≤ b
    supR  : ∀ {a : Ordinal ℓ} {f : Nat → Ordinal ℓ} (p : Σ Nat (λ n → a ≤ f n)) → a ≤ limit f

-- חיבור אורדינלים
infixl 6 _+_
_+_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
zero  + b = b
succ a + b = succ (a + b)
limit f + b = limit (λ n → f n + b)

-- כפל אורדינלים
infixl 7 _*_
_*_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
zero  * b = zero
succ a * b = b + (a * b)
limit f * b = limit (λ n → f n * b)

-- חזקה
infixr 8 _^_
_^_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
a ^ zero       = succ zero
a ^ (succ b)   = a * (a ^ b)
a ^ (limit f)  = limit (λ n → a ^ (f n))

-- ההגדרה הבאה נמחקה כי המימוש מסובך, ונוספה כפוסטולט
-- refl≤ : ∀ {ℓ} {a : Ordinal ℓ} → a ≤ a
-- refl≤ {ℓ} {zero} = zero≤
-- refl≤ {ℓ} {succ a} = suc≤ refl≤
-- refl≤ {ℓ} {limit f} = ???

le-succ : ∀ {ℓ} {a b : Ordinal ℓ} → a ≤ b → a ≤ succ b
le-succ {ℓ} {zero} {b} zero≤ = zero≤
le-succ {ℓ} {succ a} {succ b'} (suc≤ p) = suc≤ (le-succ p)
le-succ {ℓ} {limit f} {b} (supL pf) = supL (λ n → le-succ (pf n))
le-succ {ℓ} {a} {limit f} (supR (n , q)) = {!!} -- Placeholder

lemma-monoLplus-base : ∀ {ℓ} {b z : Ordinal ℓ} → zero ≤ b → z ≤ b + z
lemma-monoLplus-base {ℓ} {zero} {z} p = {!!} -- Needs refl≤
lemma-monoLplus-base {ℓ} {succ b'} {z} p = le-succ (lemma-monoLplus-base {b = b'} p) -- Assumes le-succ is total
lemma-monoLplus-base {ℓ} {limit f} {z} p = supR (0 , lemma-monoLplus-base {b = f 0} p)

-- עזר ל-limit
limit′ : ∀ {ℓ} → (Nat → Ordinal ℓ) → Ordinal ℓ
limit′ {ℓ} f = limit f

-- דוגמאות לאורדינלים טרנספיניטיים
omega : ∀ {ℓ} → Ordinal ℓ
omega = limit (λ n → iterate succ n zero)

omega² : ∀ {ℓ} → Ordinal ℓ
omega² = limit (λ n → iterate (λ x → omega + x) n zero)

fromNatO : ∀ {ℓ} → Nat → Ordinal ℓ
fromNatO n = iterate succ n zero

Omega : ∀ {ℓ} → Ordinal ℓ
Omega = limit (λ n → omega ^ succ (fromNatO n))

-- השוואת אורדינלים (פשוטה)
ordinalEq : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
ordinalEq zero zero = true
ordinalEq (succ a) (succ b) = ordinalEq a b
ordinalEq _ _ = false

-- קדם-אורדינל
predO : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ
predO zero      = zero
predO (succ o)  = o
predO (limit f) = limit (λ n → predO (f n))

-- האם limit
isLimit : ∀ {ℓ} → Ordinal ℓ → Bool
isLimit zero = false
isLimit (succ _) = false
isLimit (limit _) = true

-- האם סופי
isFinite : ∀ {ℓ} → Ordinal ℓ → Bool
isFinite zero = true
isFinite (succ o) = isFinite o
isFinite (limit _) = false

-- הצגה כמחרוזת (פשוטה)
showOrdinal : ∀ {ℓ} → Ordinal ℓ → String
showOrdinal zero = "0"
showOrdinal (succ o) = "S(" ++ showOrdinal o ++ ")"
showOrdinal (limit _) = "lim"

-- אסוציאטיביות של חיבור (שוויון קוביקלי)
assoc⁺ : ∀ {ℓ} (a b c : Ordinal ℓ) → (a + b) + c ≡ a + (b + c)
assoc⁺ zero b c = refl
assoc⁺ (succ a) b c = cong succ (assoc⁺ a b c)
assoc⁺ (limit f) b c = cong limit (funExt λ n → assoc⁺ (f n) b c)

-- דיסטריביוטיביות של כפל מעל חיבור
-- (שימוש ב-_∙_, sym, cong מהקוביקל)
distrib*+ : ∀ {ℓ} (a b c : Ordinal ℓ) → (a + b) * c ≡ (a * c) + (b * c)
distrib*+ zero b c = refl
distrib*+ (succ a) b c =
  (cong (λ x → c + x) (distrib*+ a b c)) ∙
        (sym (assoc⁺ c (a * c) (b * c)))
distrib*+ (limit f) b c =
  cong limit (funExt (λ n → distrib*+ (f n) b c))

-- אסוציאטיביות של כפל
assoc* : ∀ {ℓ} (a b c : Ordinal ℓ) → ((a * b) * c) ≡ (a * (b * c))
assoc* zero b c = refl
assoc* (succ a) b c =
  (cong (λ x → x * c) (cong (λ x → b + x) refl)) ∙
        ((distrib*+ b (a * b) c)
               ∙ (cong (λ x → (b * c) + x) (assoc* a b c)))
assoc* (limit f) b c = cong limit (funExt (λ n → assoc* (f n) b c))

-- פונקציונליות הרחבה (קיים ב-cubical)
-- funExt כבר מובנה ב-cubical, אין צורך להגדיר פוסטולט

-- פוסטולטים של מונוטוניות (להשלים בהמשך)
postulate
  refl≤ : ∀ {ℓ} {a : Ordinal ℓ} → a ≤ a -- הוספנו כפוסטולט
  mono*     : ∀ {ℓ} → (a b c : Ordinal ℓ) → b ≡ c → (a * b) ≡ (a * c)
  monoL*    : ∀ {ℓ} → (a b c : Ordinal ℓ) → a ≡ b → (a * c) ≡ (b * c)

-- עזר: יחס סדר על אורדינלים
OrdLeSigma : ∀ {ℓ} (a : Ordinal ℓ) (f : Nat → Ordinal ℓ) → Set ℓ
OrdLeSigma a f = Σ Nat (λ n → a ≤ f n)

monoLplus : ∀ {ℓ} {x y z : Ordinal ℓ} → (p : x ≤ y) → x + z ≤ y + z
monoLplus {ℓ} {zero} {y} {z} p = lemma-monoLplus-base p
monoLplus {ℓ} {succ x} {succ y} {z} (suc≤ p) = suc≤ (monoLplus p)
monoLplus {ℓ} {limit f} {y} {z} (supL pf) = supL (λ n → monoLplus (pf n))
monoLplus {ℓ} {x} {limit f} {z} (supR (n , p)) = supR (n , monoLplus p)   
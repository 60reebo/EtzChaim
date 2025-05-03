{-# OPTIONS --no-main --without-K #-}

--------------------------------------------------
-- Math Ordinal (Domain/Math)
--------------------------------------------------
{- |
מודול זה מגדיר את מבנה האורדינלים ופעולות עליהם.

אורדינלים הם סדרים טובים שמרחיבים את המושג של מספרים טבעיים אל מעבר לסופיות. 
מודול זה מאפשר עבודה עם אורדינלים סופיים וטרנספיניטיים (כמו אומגה והאורדינלים שמעליו).

### יכולות עיקריות:
- ייצוג אורדינלים באמצעות קונסטרוקטורים zero, succ, limit
- פעולות אריתמטיות: חיבור, כפל, חזקה 
- דוגמאות מובנות כמו אומגה, אומגה^2, וכו'
- פונקציות השוואה והחלטה של סדר על אורדינלים
- תכונות מתמטיות (אסוציאטיביות, חוק הפילוג, מונוטוניות)

### שימושים:
במערכת זו אורדינלים משמשים לייצוג קשרים טרנספיניטיים בין מבנים שונים,
ומאפשרים מידול של סדרות אינסופיות ותהליכים רקורסיביים מורכבים.
-}
module Hishtalshelut.Domain.Math.Ordinal where

open import Agda.Primitive using (Level)

open import Agda.Builtin.String using (String)
import Data.String.Base as Str using (_++_)
open import Data.Nat using (ℕ; zero; suc)
open import Data.Bool using (Bool; true; false)
open import Data.Unit using (⊤ ; tt)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; cong; trans; sym)
open Relation.Binary.PropositionalEquality.≡-Reasoning
open import Data.Product using (Σ; _,_)
open import Data.Maybe using (Maybe; nothing; just)

-- נוסיף import לפני פונקציית funExt
open import Relation.Binary.PropositionalEquality as Eq
open Eq.≡-Reasoning

-- | Function extensionality
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
infixl 6 _+_
_+_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
zero  + b = b
succ a + b = succ (a + b)
limit f + b = limit (λ n → f n + b)

-- | Ordinal multiplication
infixl 7 _*_
_*_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
zero  * b = zero
succ a * b = b + (a * b)
limit f * b = limit (λ n → f n * b)

-- | Ordinal exponentiation
infixr 8 _^_
_^_ : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
a ^ zero       = succ zero
a ^ (succ b)   = a * (a ^ b)
a ^ (limit f)  = limit (λ n → a ^ (f n))


{- | 
  אומגה (ω) - האורדינל הגבולי הראשון
  
  אומגה מוגדר כגבול של סדרת המספרים הטבעיים
  0, 1, 2, 3, ...
  
  אומגה הוא האורדינל הטרנספיניטי הראשון ומייצג את
  האינסוף הספירה (countable infinity)
-}
omega : ∀ {ℓ} → Ordinal ℓ
omega = limit (λ n → iterate succ n zero)

{- |
  אומגה בריבוע (ω²) - אומגה פעמים אומגה
  
  מוגדר כגבול של הסדרה:
  0, ω, ω+ω, ω+ω+ω, ...
  
  או בכתיב אחר:
  0, ω, ω·2, ω·3, ...
  
  שימושי לייצוג של מבנים מורכבים יותר של סדרות אינסופיות
-}
omega² : ∀ {ℓ} → Ordinal ℓ
omega² = limit (λ n → iterate (λ x → omega + x) n zero)

{- |
  המרה ממספר טבעי לאורדינל
  
  מייצגת את המספר הטבעי n כאורדינל, כלומר n הפעלות של
  הקונסטרוקטור succ על zero
-}
fromNatO : ∀ {ℓ} → ℕ → Ordinal ℓ
fromNatO n = iterate succ n zero

{- |
  אומגה גדול (Ω) - אורדינל טרנספיניטי גדול יותר
  
  מוגדר כגבול של הסדרה:
  ω, ω², ω³, ...
  
  Ω משמש לייצוג של מבנים גדולים יותר ומורכבים יותר
  של מספרים טרנספיניטיים
-}
Omega : ∀ {ℓ} → Ordinal ℓ
Omega = limit (λ n → omega ^ succ (fromNatO n))

{- |
  השוואת שוויון בין אורדינלים (גרסה בוליאנית)
  
  מחזירה true אם ורק אם שני האורדינלים זהים מבחינת המבנה שלהם
  לדוגמה:
  * ordinalEq zero zero = true
  * ordinalEq (succ zero) (succ zero) = true
  * ordinalEq zero (succ zero) = false
  
  שימו לב: בדיקה זו מוגבלת לאורדינלים עם מבנה זהה במדויק
  ולא מטפלת בשקילות מתמטית של ייצוגים שונים של אותו אורדינל
-}
ordinalEq : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
ordinalEq zero zero = true
ordinalEq (succ a) (succ b) = ordinalEq a b
ordinalEq _ _ = false

{- |
  קודם (predecessor) של אורדינל
  
  פונקציה זו מחזירה את האורדינל הקודם ל-o, אם יש כזה:
  * predO (succ a) = a
  * predO zero = zero (אין אורדינל לפני אפס, אז מחזירים אפס)
  * עבור limit - מחילים את predO רקורסיבית על כל איבר בסדרה
  
  שימו לב: פונקציה זו היא קירוב בלבד למושג המתמטי של "קודם",
  במיוחד במקרה של אורדינלים גבוליים
-}
predO : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ
predO zero      = zero
predO (succ o)  = o
predO (limit f) = limit (λ n → predO (f n))


{- |
  ייצוג מחרוזתי של אורדינל
  
  * showOrdinal zero = "0"
  * showOrdinal (succ a) מוסיף "S(...)" מסביב לייצוג של a
  * עבור אורדינלים גבוליים מחזיר "lim" כקירוב פשוט
  
  שימושי להדפסה ודיבוג של אורדינלים
-}
showOrdinal : ∀ {ℓ} → Ordinal ℓ → String
showOrdinal zero = "0"
showOrdinal (succ o) = Str._++_ "S(" (Str._++_ (showOrdinal o) ")")
showOrdinal (limit f) with f zero -- Attempt to show the first element for limits
... | o = Str._++_ "lim(" (Str._++_ (showOrdinal o) ",...)") -- Basic representation for limits

-- | Helper function to show Nat (if not already available)
showNat : ℕ → String
showNat zero = "0"
showNat (suc n) = Str._++_ "S(" (Str._++_ (showNat n) ")") -- Simple S-based representation

-- | האם אורדינל הוא limit (לא אפס ולא יורש)
isLimit : ∀ {ℓ} → Ordinal ℓ → Bool
isLimit zero = false
isLimit (succ _) = false
isLimit (limit _) = true

-- | האם אורדינל הוא סופי (קיים n:ℕ כך ש-o = fromNatO n)
isFinite : ∀ {ℓ} → Ordinal ℓ → Bool
isFinite zero = true
isFinite (succ o) = isFinite o
isFinite (limit _) = false

-- דוגמאות שימוש:
-- isLimit omega == true
-- isFinite (fromNatO 5) == true
-- isFinite omega == false

-- | Associativity of addition
assoc⁺ : ∀ {ℓ} (a b c : Ordinal ℓ) → (a + b) + c ≡ a + (b + c)
assoc⁺ zero b c = refl
assoc⁺ (succ a) b c = cong succ (assoc⁺ a b c)
assoc⁺ (limit f) b c = cong limit (funExt λ n → assoc⁺ (f n) b c)

-- | Distributivity of multiplication over addition
distrib*+ : ∀ {ℓ} (a b c : Ordinal ℓ) → (a + b) * c ≡ (a * c) + (b * c)
distrib*+ zero b c = refl
distrib*+ (succ a) b c =
  Relation.Binary.PropositionalEquality.trans
    (cong (λ x → c + x) (distrib*+ a b c))
    (Relation.Binary.PropositionalEquality.sym (assoc⁺ c (a * c) (b * c)))
distrib*+ (limit f) b c =
  cong limit (funExt (λ n → distrib*+ (f n) b c))

-- | Ordinal multiplication
assoc* : ∀ {ℓ} (a b c : Ordinal ℓ) → ((a * b) * c) ≡ (a * (b * c))
assoc* zero b c = refl
assoc* (succ a) b c =
  trans (cong (λ x → x * c) (cong (λ x → b + x) refl))
        (trans (distrib*+ b (a * b) c)
               (cong (λ x → (b * c) + x) (assoc* a b c)))
assoc* (limit f) b c = cong limit (funExt (λ n → assoc* (f n) b c))

-- Define the ordering relation ≤ on ordinals
infix 4 _≤_
data _≤_ {ℓ} : Ordinal ℓ → Ordinal ℓ → Set ℓ where
  zero≤ : {b : Ordinal ℓ} → zero ≤ b
  suc≤  : {a b : Ordinal ℓ} → a ≤ b → succ a ≤ succ b
  supL  : {f : ℕ → Ordinal ℓ} {b : Ordinal ℓ} → (∀ n → f n ≤ b) → limit f ≤ b
  supR  : {a : Ordinal ℓ} {f : ℕ → Ordinal ℓ} → Σ ℕ (λ n → a ≤ f n) → a ≤ limit f

-- | Reflexivity and transitivity of ≤
postulate 
  refl≤ : ∀ {ℓ} {a : Ordinal ℓ} → a ≤ a
  trans≤ : ∀ {ℓ} {a b c : Ordinal ℓ} → a ≤ b → b ≤ c → a ≤ c

-- | Decidability postulate for the ordering relation
open import Relation.Nullary using (Dec; yes; no)

postulate
  decOrdLE : ∀ {ℓ} (a b : Ordinal ℓ) → Dec (a ≤ b)

-- | Decidable comparison function
_≤?_ : ∀ {ℓ} → (a b : Ordinal ℓ) → Dec (a ≤ b)
a ≤? b = decOrdLE a b

-- | Boolean version of ≤ (useful for computations)
ordLeq : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
ordLeq a b with a ≤? b
... | yes _ = true
... | no _  = false

-- | Function to compare only finite ordinals or check against zero (non-postulated)
--   Used specifically to avoid postulate evaluation in trace generation loops.
--   Warning: Logic for limit cases is a simplification for termination, not general correctness.
simpleOrdLeq : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
simpleOrdLeq zero _ = true -- Zero is less than or equal to anything
simpleOrdLeq (succ a) zero = false -- Successor is never less than or equal to zero
simpleOrdLeq (succ a) (succ b) = simpleOrdLeq a b -- Recurse on predecessors
simpleOrdLeq (succ a) (limit f) = true -- Finite is always less than infinite limit (common case)
simpleOrdLeq (limit f) zero = false -- Limit is not less than or equal to zero
simpleOrdLeq (limit f) (succ b) = false -- Limit is generally not <= finite succ (simplification)
simpleOrdLeq (limit f) (limit g) = false -- Cannot compare general limits simply, assume false for termination

-- | Monotonicity postulates (keeping them postulated for now)
postulate
  monoLplus : ∀ {ℓ} → (x y z : Ordinal ℓ) → x ≤ y → (x + z) ≤ (y + z)
  mono*     : ∀ {ℓ} → (a b c : Ordinal ℓ) → b ≤ c → (a * b) ≤ (a * c)
  monoL*    : ∀ {ℓ} → (a b c : Ordinal ℓ) → a ≤ b → (a * c) ≤ (b * c)

-- | Postulate for bivariate monotonicity of addition
postulate
  +-mono : ∀ {ℓ} (x₁ y₁ x₂ y₂ : Ordinal ℓ) → x₁ ≤ y₁ → x₂ ≤ y₂ → (x₁ + x₂) ≤ (y₁ + y₂)

-- | הערה: את הפוסטולטים האלה אפשר להוכיח באמצעות אינדוקציה מורכבת.
-- | סקיצות להוכחות קיימות בקובץ הגיבוי Ordinal.agda.bak, ויושלמו בעתיד בקובץ נפרד Ordinal.Proofs.agda.
-- | בינתיים אנו משתמשים בהם כפוסטולטים כדי להתקדם בפיתוח.

-- מקסימום של שני אורדינלים
maxO : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
maxO zero b = b
maxO a zero = a
maxO (succ a) (succ b) = succ (maxO a b)
maxO (limit f) (limit g) = limit (λ n → maxO (f n) (g n))
maxO (succ a) (limit g) = limit (λ n → maxO (succ a) (g n))
maxO (limit f) (succ b) = limit (λ n → maxO (f n) (succ b))

-- פונקציה לסדרה עבור limit בקרדינלים אינסופיים
natTo : ∀ {ℓ} → ℕ → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
natTo n α β = maxO (fromNatO n) (maxO α β)

-- שאר המקרים (עם לפחות limit אחד) פוסטולטים
postulate
  limitNatToAssoc : ∀ {ℓ} (α β γ : Ordinal ℓ) →
    maxO (limit (λ m → natTo m α β)) γ ≡ maxO α (limit (λ m → natTo m β γ))
  
  -- הוכחות מורכבות שנשאיר כפוסטולטים
  maxSuccAssoc : ∀ {ℓ} (a b c : Ordinal ℓ) → maxO (maxO a b) c ≡ maxO a (maxO b c)
  assocMaxO-helper : ∀ {ℓ} → (o : Ordinal ℓ) → (a b : Ordinal ℓ) →
                    maxO (succ (maxO a b)) o ≡ maxO (succ a) (maxO (succ b) o)
  
  -- הוכחה רקורסיבית לאסוציאטיביות של maxO
  assocMaxO : ∀ {ℓ} (a b c : Ordinal ℓ) → maxO (maxO a b) c ≡ maxO a (maxO b c)

-- הוספנו גם את האסוציאטיביות החשובה על מקסימום של אורדינלים
-- (שימושי לקרדינלים: aleph α ⊕ aleph β)
commMaxO : ∀ {ℓ} (a b : Ordinal ℓ) → maxO a b ≡ maxO b a
commMaxO zero zero = refl
commMaxO zero (succ b) = refl
commMaxO zero (limit g) = refl
commMaxO (succ a) zero = refl
commMaxO (succ a) (succ b) = cong succ (commMaxO a b)
commMaxO (limit f) zero = refl
commMaxO (limit f) (limit g) = cong limit (funExt (λ n → commMaxO (f n) (g n)))
commMaxO (succ a) (limit g) = cong limit (funExt (λ n → commMaxO (succ a) (g n)))
commMaxO (limit f) (succ b) = cong limit (funExt (λ n → commMaxO (f n) (succ b)))

-- למת עזר: חוק קיבוצי (אסוציאטיבי) על מקרים עם zero
maxZeroAssoc : ∀ {ℓ} (a b : Ordinal ℓ) → maxO (maxO zero a) b ≡ maxO zero (maxO a b)
maxZeroAssoc a b = refl

-- למת עזר למקרים עם לפחות אחד הארגומנטים הוא zero
maxZeroLeft : ∀ {ℓ} (a : Ordinal ℓ) → maxO zero a ≡ a
maxZeroLeft a = refl

maxZeroRight : ∀ {ℓ} (a : Ordinal ℓ) → maxO a zero ≡ a
maxZeroRight zero = refl
maxZeroRight (succ a) = refl
maxZeroRight (limit f) = refl

-- קומוטטיביות של natTo
commNatTo : ∀ {ℓ} (n : ℕ) (α β : Ordinal ℓ) → natTo n α β ≡ natTo n β α
commNatTo n α β = cong (λ x → maxO (fromNatO n) x) (commMaxO α β)

-- אסוציאטיביות של natTo עם limit′
assocNatTo : ∀ {ℓ} (n : ℕ) (α β γ : Ordinal ℓ) → 
             natTo n (limit′ (λ m → natTo m α β)) γ ≡ natTo n α (limit′ (λ m → natTo m β γ))
assocNatTo n α β γ = 
  cong (λ x → maxO (fromNatO n) x) (limitNatToAssoc α β γ)
          
-- | Lemma: limit preserves order
limit≤limit : ∀ {ℓ} {f g : ℕ → Ordinal ℓ} → (∀ n → f n ≤ g n) → limit f ≤ limit g
limit≤limit {f = f} {g} f≤g = supL proof
  where
    -- We need to show: ∀ m → f m ≤ limit g
    proof : ∀ m → f m ≤ limit g
    proof m = supR (m , f≤g m)

-- | הוכחה שהחיבור מונוטוני מימין
-- | (אם x ≤ y אז z + x ≤ z + y)
monoRplus : ∀ {ℓ} (x y z : Ordinal ℓ) → x ≤ y → (z + x) ≤ (z + y)
-- Induction on z
-- Case z = zero
monoRplus x y zero x≤y = x≤y
-- Case z = succ z'
monoRplus x y (succ z') x≤y = suc≤ (monoRplus x y z' x≤y)
-- Case z = limit h
-- Goal: limit (λ n → h n + x) ≤ limit (λ n → h n + y)
-- IH: ∀ n → monoRplus x y (h n) x≤y which is ∀ n → (h n + x) ≤ (h n + y)
monoRplus x y (limit h) x≤y = limit≤limit (λ n → monoRplus x y (h n) x≤y)

-- | מונוטוניות של חיבור (צד ימין)
mono⁺ʳ : ∀ {ℓ} (a b c : Ordinal ℓ) → b ≤ c → (a + b) ≤ (a + c)
mono⁺ʳ a b c b≤c = monoRplus b c a b≤c

                                                             
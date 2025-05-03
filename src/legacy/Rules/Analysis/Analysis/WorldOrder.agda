------------------------------------------------------------------------
-- Hishtalshelut.Rules.Analysis.WorldOrder.agda
-- חקירה: סדר השתלשלות העולמות והסבר סיבת הבריאה בזמן מסוים
------------------------------------------------------------------------

module Hishtalshelut.Rules.Analysis.WorldOrder where

open import Data.List using (List; map; zip)
open import Data.List.Membership.Propositional using (_∈_)
open import Data.Bool using (Bool; true; false)
open import Data.String using (String; _++_)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Nat using (ℕ; _<_)

-- | טיפוס מייצג עולם (פשטני, להרחבה)
data WorldName : Set where
  EinSof   : WorldName
  AdamKadmon : WorldName
  Nekudim  : WorldName
  Atzilut  : WorldName
  Beriah   : WorldName
  Yetzirah : WorldName
  Asiyah   : WorldName

record WorldInstance : Set where
  field
    name  : WorldName
    order : ℕ  -- מספר שלב בהשתלשלות (קטן=מוקדם)

-- | בדיקת תקינות סדר השתלשלות
isWorldOrderValid : List WorldInstance → Bool
isWorldOrderValid ws = all (λ { (w , n) → n ≡ indexOf w ws }) (zip (map WorldInstance.name ws) (map WorldInstance.order ws))
  where
    indexOf : WorldName → List WorldInstance → ℕ
    indexOf w ws = go 0 ws
      where
        go : ℕ → List WorldInstance → ℕ
        go n [] = 0
        go n (x ∷ xs) = if WorldInstance.name x ≡ w then n else go (n + 1) xs

-- | הפקת הסבר טקסטואלי לסיבת הבריאה בזמן מסוים
explainWorldCreation : List WorldInstance → List String
explainWorldCreation ws = map explain ws
  where
    explain : WorldInstance → String
    explain w =
      let n = WorldInstance.order w in
      if n ≡ 0 then show (WorldInstance.name w) ++ " נברא ראשון (אין עולם מעליו)"
      else show (WorldInstance.name w) ++ " נברא אחרי " ++ show (getParent n ws)
    getParent : ℕ → List WorldInstance → WorldName
    getParent n ws = WorldInstance.name (ws !! (n - 1))
    -- (!!) = index, יש להוסיף פונקציה בטוחה בהמשך

-- | הסבר חקירה:
--   ציטוט: "...ולא היה אפשר להקדים או לאחר בריאת עוה"ז, כי כל עולם ועולם נברא אחר בריאת עולם שלמעלה ממנו..."
--   בלשון קלה: כל עולם נברא רק לאחר שהעולם שמעליו הושלם, ולכן הסדר הכרחי.
--   יישום: בדיקת תקינות הסדר, הפקת הסבר מפורש לסיבת הזמן.
--   שימוש: קרא isWorldOrderValid עם רשימת עולמות. קבל הסבר עם explainWorldCreation.

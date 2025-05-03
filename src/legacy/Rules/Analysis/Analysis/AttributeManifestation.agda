------------------------------------------------------------------------
-- Hishtalshelut.Rules.Analysis.AttributeManifestation.agda
-- חקירה: האם כל הכינויים/שמות האלוקיים באים לידי ביטוי בבריאה?
------------------------------------------------------------------------

module Hishtalshelut.Rules.Analysis.AttributeManifestation where

open import Data.List using (List; filter)
open import Data.List.Membership.Propositional using (_∈_)
open import Data.Bool using (Bool; true; false; not)
open import Data.String using (String)

-- | טיפוס מייצג כינוי/שם אלוקי (דוגמה - להרחבה לפי הצורך)
data Attribute : Set where
  Havayah : Attribute  -- הוי"ה
  Adnut   : Attribute  -- אדנות
  Merciful : Attribute -- רחום
  Gracious : Attribute -- חנון
  LongSuffering : Attribute -- ארך אפים
  -- ... הוסף כינויים נוספים

-- | בדיקה: האם כל הכינויים התממשו בפועל?
--   קלט: רשימת כל הכינויים, רשימת כינויים שהתגלו בפועל
--   פלט: האם כולם התממשו?
allAttributesManifested : List Attribute → List Attribute → Bool
allAttributesManifested all manifested =
  all (λ a → a ∈ manifested) all

-- | החזרת רשימת כינויים שעדיין לא התממשו
missingAttributes : List Attribute → List Attribute → List Attribute
missingAttributes all manifested = filter (λ a → not (a ∈ manifested)) all

-- | הסבר חקירה:
--   ציטוט: "...אם לא היה מוציא פעולותיו וכוחותיו לידי פועל ומעשה לא היה כביכול נקרא שלם..."
--   בלשון קלה: רק כאשר כל הכינויים/הכוחות באים לידי ביטוי בפועל, מתגלה שלמות הכינויים האלוקיים.
--   יישום: בעזרת הפונקציות אפשר לבדוק האם הבריאה מממשת את כל הכינויים, ולזהות מה חסר.
--   שימוש: קרא allAttributesManifested עם רשימת כל הכינויים ורשימת הכינויים שהופיעו בפועל. אפשר לקבל את החסרים עם missingAttributes.

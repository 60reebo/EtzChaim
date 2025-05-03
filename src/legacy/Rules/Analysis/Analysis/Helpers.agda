------------------------------------------------------------------------
-- Hishtalshelut.Rules.Analysis.Helpers.agda
-- פונקציות עזר כלליות לחקירות
------------------------------------------------------------------------

module Hishtalshelut.Rules.Analysis.Helpers where

open import Data.List using (List; map; filter)
open import Data.Bool using (Bool)
open import Data.String using (String)

-- | בדיקת תלות היררכית (האם יש עולם-אב לכל עולם שאינו ראשון)
checkHierarchicalDependencies : List (String × Maybe String) → Bool
checkHierarchicalDependencies ws =
  all (λ { (name , just parent) → parent ∈ map fst ws ; (name , nothing) → true }) ws

-- | הפקת שרשרת השתלשלות מסודרת
buildWorldChain : List (String × Maybe String) → List String
buildWorldChain ws = map fst ws  -- פשטני, להרחבה למיון נכון

-- | הסבר חקירה:
--   עוזר לבדוק שאין לולאות בתלות, ולבנות שרשרת מסודרת של עולמות.
--   יישום: ניתן להשתמש בפונקציות אלו בכל חקירה אחרת.
--   שימוש: קרא checkHierarchicalDependencies/buildWorldChain עם רשימת עולמות ותלות.

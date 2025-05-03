------------------------------------------------------------------------
-- Hishtalshelut.Rules.Analysis.WorldTimeAnalysis.agda
-- חקירה: חישוב זמני בריאת העולמות לאחור עד הצמצום
------------------------------------------------------------------------

module Hishtalshelut.Rules.Analysis.WorldTimeAnalysis where

open import Hishtalshelut.Domain.All public

-- | טיפוס מייצג שלב/עולם עם מרווח זמן
record WorldStep : Set where
  field
    name   : String
    delta  : ℕ  -- מרווח הזמן מהעולם הבא (למטה)

-- | חישוב זמני הבריאה לאחור
calcCreationTimesBackward : List WorldStep → String → ℕ → List (String × ℕ)
calcCreationTimesBackward [] _ _ = []
calcCreationTimesBackward (w ∷ ws) knownName knownTime =
  if WorldStep.name w ≡ knownName then
    (WorldStep.name w , knownTime) ∷ calc ws knownTime
  else calcCreationTimesBackward ws knownName knownTime
  where
    calc : List WorldStep → ℕ → List (String × ℕ)
    calc [] _ = []
    calc (w ∷ ws) t =
      let t' = t - WorldStep.delta w in
      (WorldStep.name w , t') ∷ calc ws t'

-- | הסבר חקירה:
--   ציטוט: "...אפשר...לחשב אחורה...ולדעת קודם בריאת העולם מתי נברא כל עולם עד להסקה מתי היה זמן הצמצום..."
--   בלשון קלה: אם יודעים את זמן בריאת העולם הזה, אפשר לחשב מתי נברא כל עולם עד הצמצום.
--   יישום: חישוב זמני בריאה לכל עולם לפי מרווחים.
--   שימוש: קרא calcCreationTimesBackward עם רשימת שלבים, שם העולם הידוע, והזמן הידוע.

{-# OPTIONS --no-main --without-K #-}
--------------------------------------------------
-- CoreTypes/Keli (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.Keli (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level; lsuc)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ
open import Data.Maybe using (Maybe; just; nothing)
open import Data.List using (List; _++_; []; _∷_)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; _⊕_; _⊗_; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit)
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (SefirahId; LightKind)
open import Hishtalshelut.Domain.Kelim.KeliSubstance using (KeliSubstance)
open import Agda.Builtin.String using (String)
open import Hishtalshelut.Domain.Math.Cardinal.Properties as CardP using (cardStronger)
open import Data.Bool using (Bool; true; false; if_then_else_)

--------------------------------------------------
-- מצבי הכלי (Keli State)
--------------------------------------------------
data KeliState : Set where
  Whole      : KeliState  -- כלי שלם
  Broken     : KeliState  -- כלי שבור
  Clarifying : KeliState  -- כלי בתהליך בירור
  Rectified  : KeliState  -- כלי מתוקן

--------------------------------------------------
-- שכבות הכלי (Keli Layers)
--------------------------------------------------
-- | שכבה אחת בכלי, המקבילה לרמה אחת של נרנח"י
record KeliLayer : Set (lsuc ℓ) where
  constructor mkKeliLayer
  field
    attired_light    : Maybe (Light)  -- האור המתלבש בשכבה
    purity           : Ordinal ℓ      -- דרגת הזיכוך של השכבה
    capacity_portion : Cardinal ℓ     -- חלק הקיבולת של השכבה
    tzelem_letter    : TzelemLetter   -- אות הצלם המקושרת לשכבה זו (צ/ל/ם)
open KeliLayer public

-- | A Keli (vessel) can contain light and has properties that determine how it interacts with light.
record Keli : Set (lsuc ℓ) where
  constructor mkKeli
  field
    seph      : SefirahId     -- Which sefirah this vessel belongs to (שיוך לספירה)
    kind      : LightKind     -- What kind of light it can hold (בהתאם לסוג האור שיכול להכיל)
    substance : KeliSubstance -- Material of the vessel (חומר הכלי) - determines its properties
    capacity  : Cardinal ℓ    -- How much light it can contain (כמה אור יכול להכיל)
    content   : Light         -- Current light contained (אור שנמצא בתוכו כרגע)
    label     : String        -- Identifier/name for the vessel (זיהוי/שם לכלי)
    tzelem_letters : List TzelemLetter -- אותיות צלם המשויכות לכלי זה (צ-ל-ם)
    -- מצב הכלי
    state     : KeliState     -- מצב הכלי (שלם/שבור/בתיקון/מתוקן)
    -- שכבות פנימיות לפי שיטת הרש"ש
    inner_layer   : Maybe KeliLayer  -- שכבה פנימית (גידים-עצמות) - לנשמה
    middle_layer  : Maybe KeliLayer  -- שכבה אמצעית (בשר) - לרוח
    outer_layer   : Maybe KeliLayer  -- שכבה חיצונית (עור) - לנפש
    -- מקיפים
    surrounding_makif_chozer  : Maybe Light  -- אור מקיף חוזר (חיה 'ל')
    surrounding_makif_yashar  : Maybe Light  -- אור מקיף ישר (יחידה 'ם')
open Keli public

-- | עדכון תוכן הכלי (updateKeliContent) מחליף את האור הנוכחי באור חדש.
-- | אין לבצע בדיקת יכולת הכלה בפונקציה זו; יש לבדוק חיצונית לפני קריאה לפונקציה זו.
updateKeliContent : Keli → Light → Keli
updateKeliContent keli newLight =
  record keli { content = newLight }

-- | יצירת שכבת כלי חדשה
createKeliLayer : Maybe Light → Ordinal ℓ → Cardinal ℓ → TzelemLetter → KeliLayer
createKeliLayer = λ mlight purity capacity letter → mkKeliLayer mlight purity capacity letter

-- | עדכון מצב הכלי
updateKeliState : Keli → KeliState → Keli
updateKeliState keli newState =
  record keli { state = newState }

-- | התלבשות אור נר"ן בשכבות הכלי
-- | מחזיר Maybe Keli - כלי מעודכן או nothing אם הכלי נשבר
attireNaRaNInKeliLayers : Light → Light → Light → Keli → Maybe Keli
attireNaRaNInKeliLayers nefeshLight ruachLight neshamaLight keli =
  let 
    -- יצירת שכבות עם אורות מתאימים
    newOuterLayer = createKeliLayer (just nefeshLight) zero (fin 10) TzelemLetter.Tzadi
    newMiddleLayer = createKeliLayer (just ruachLight) zero (fin 20) TzelemLetter.Tzadi
    newInnerLayer = createKeliLayer (just neshamaLight) zero (fin 30) TzelemLetter.Tzadi
    
    -- בדיקת קיבולת
    nefeshOverCapacity = CardP.cardStronger (power nefeshLight) (capacity keli)
  in
    if nefeshOverCapacity
    then nothing  -- הכלי עלול להישבר
    else just (updateKeliState keli Whole)  -- פשטות לצורך קימפול

-- | הקפת אורות חיה ויחידה סביב הכלי
surroundChaYAroundKeli : Light → Light → Keli → Keli
surroundChaYAroundKeli chayaLight yechidaLight keli = 
  updateKeliContent keli chayaLight  -- פשטות לצורך קימפול
  
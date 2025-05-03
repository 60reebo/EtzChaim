{-# OPTIONS --without-K --no-main #-}
--------------------------------------------------
-- Rules/Light/TzelemTransformationsAdvanced
-- הרחבה של טרנספורמציות צל"ם לפי שיטת הרש"ש
--------------------------------------------------
module Hishtalshelut.Rules.Light.TzelemTransformationsAdvanced (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (lzero; lsuc)
open import Data.Bool using (Bool; true; false; _∧_; _∨_; if_then_else_)
open import Data.List using (List; _∷_; []; map; foldr; filter; any)
open import Data.Nat using (ℕ) renaming (_+_ to _+ℕ_; _*_ to _*ℕ_; _^_ to _^ℕ_; _>_ to _>ℕ_; _≥_ to _≥ℕ_)
open import Data.String using (String; _++_)
open import Data.Maybe using (Maybe; just; nothing; maybe′)
open import Data.Product using (_×_; _,_; proj₁; proj₂)
open import Data.Sum using (_⊎_; inj₁; inj₂)
open import Function using (_∘_; id)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

open import Hishtalshelut.Domain.CoreTypes.Light ℓ using (Light; TzelemLetter; Tzadi; Lamed; Mem; power; structure; category; mergeLight; createNaRaNLight; createChayaLight; createYechidaLight; TzelemAssignment; mkTzelemAssignment; LightMode; Pnimi; Makif_Chozer; Makif_Yashar; mkLight)
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ using (Keli; mkKeli; updateKeliContent; seph; kind; capacity; content; state; attireNaRaNInKeliLayers; surroundChaYAroundKeli; inner_layer; middle_layer; outer_layer; surrounding_makif_chozer; surrounding_makif_yashar)
                                            using () renaming (KeliState to KeliCondition; Whole to WholeKeli; Broken to BrokenKeli)
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (SefirahId; LightCategory; Undifferentiated_LightCategory; Nefesh; Ruach; Neshama; Chaya; Yechida; LightKind; Pnimi; Makif)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; _⊕_; fin; aleph)
open import Hishtalshelut.Domain.Math.Cardinal.Properties using (cardStronger)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit) renaming (_+_ to _+Ord_)
open import Hishtalshelut.State.Worlds.IgulimYosherFullState ℓ
open import Hishtalshelut.State.Light.KeliState ℓ

--------------------------------------------------
-- פונקציות מתקדמות להתאמת אורות נר"ן וח"י לפי שיטת הרש"ש
--------------------------------------------------

-- | סוג נתונים המכיל את מגוון אורות הנר"ן
record PnimiLights : Set (lsuc ℓ) where
  constructor mkPnimiLights
  field
    nefesh  : Light
    ruach   : Light
    neshama : Light
open PnimiLights public

-- | סוג נתונים המכיל את אורות המקיפים (חיה ויחידה)
record MakifLights : Set (lsuc ℓ) where
  constructor mkMakifLights
  field
    chaya   : Light
    yechida : Light
open MakifLights public

-- | סוג נתונים המתאר את ההקשר של הפרצוף והספירה
record Context : Set where
  constructor mkContext
  field
    olamId     : String  -- מזהה העולם (א"ק, אצילות, בריאה, וכו')
    partzufId  : String  -- מזהה הפרצוף (א"א, או"א, ז"א, נוק', וכו')
    sefirahId  : String  -- מזהה הספירה (כתר, חכמה, בינה, וכו')
    level      : ℕ       -- רמה מספרית (1-10)
open Context public

-- | מידע על רמת הספירה
record SefirahLevelInfo : Set (lsuc ℓ) where
  constructor mkSefirahLevelInfo
  field
    index     : ℕ         -- מספר (1-10, כתר=1, מלכות=10)
    power     : Cardinal ℓ -- עוצמת הספירה
    structure : Ordinal ℓ  -- מבנה/סדר הספירה
open SefirahLevelInfo public

-- | פונקציה לקביעת אורות נר"ן פנימיים מסוג צלם צ'
determinePnimiNaRaNTzelem : Context → SefirahLevelInfo → PnimiLights
determinePnimiNaRaNTzelem ctx lvl =
  let
    -- חישוב ערכי בסיס לפי רמת הספירה (נוסחה משוערת)
    basePower = SefirahLevelInfo.power lvl
    baseStructure = SefirahLevelInfo.structure lvl
    
    -- חישוב ערכים מותאמים לכל רמת נר"ן
    -- נפש מקבלת את העוצמה הבסיסית
    nefeshPower = basePower
    nefeshStructure = baseStructure
    
    -- רוח מקבלת פי שניים עוצמה וסדר גבוה יותר
    ruachPower = basePower ⊕ basePower
    ruachStructure = baseStructure +Ord (succ zero)
    
    -- נשמה מקבלת פי שלושה עוצמה וסדר גבוה יותר
    neshamaPower = (basePower ⊕ basePower) ⊕ basePower 
    neshamaStructure = baseStructure +Ord (succ (succ zero))
    
    -- בניית מקורות ייחודיים לאורות
    sourcePrefix = Context.olamId ctx ++ "." ++ Context.partzufId ctx ++ "." ++ Context.sefirahId ctx
    nefeshSource = sourcePrefix ++ ".nefesh"
    ruachSource = sourcePrefix ++ ".ruach"
    neshamaSource = sourcePrefix ++ ".neshama"
    
    -- יצירת אורות נר"ן
    nefeshLight = createNaRaNLight nefeshPower nefeshStructure LightCategory.Nefesh nefeshSource baseStructure
    ruachLight = createNaRaNLight ruachPower ruachStructure LightCategory.Ruach ruachSource baseStructure
    neshamaLight = createNaRaNLight neshamaPower neshamaStructure LightCategory.Neshama neshamaSource baseStructure
  in
    mkPnimiLights nefeshLight ruachLight neshamaLight

-- | פונקציה לקביעת אורות מקיפים ח"י מסוג צלם ל'-ם'
determineMakifChaYTzelem : Context → SefirahLevelInfo → PnimiLights → MakifLights
determineMakifChaYTzelem ctx lvl pnimi =
  let
    -- חישוב ערכי בסיס למקיפים (גבוהים יותר מהפנימיים)
    basePower = (SefirahLevelInfo.power lvl) ⊕ (SefirahLevelInfo.power lvl)
    baseStructure = (SefirahLevelInfo.structure lvl) +Ord (succ (succ (succ zero)))
    
    -- בניית מקורות ייחודיים לאורות המקיפים
    sourcePrefix = Context.olamId ctx ++ "." ++ Context.partzufId ctx ++ "." ++ Context.sefirahId ctx
    chayaSource = sourcePrefix ++ ".chaya.makif_chozer"
    yechidaSource = sourcePrefix ++ ".yechida.makif_yashar"
    
    -- חיה (מקיף חוזר) - עוצמה גבוהה יותר מנשמה
    chayaPower = basePower ⊕ (power (neshama pnimi))
    chayaStructure = baseStructure +Ord (structure (neshama pnimi))
    
    -- יחידה (מקיף ישר) - העוצמה הגבוהה ביותר
    yechidaPower = chayaPower ⊕ chayaPower
    yechidaStructure = chayaStructure +Ord (succ (succ zero))
    
    -- יצירת אורות המקיפים
    chayaLight = createChayaLight chayaPower chayaStructure chayaSource baseStructure
    yechidaLight = createYechidaLight yechidaPower yechidaStructure yechidaSource baseStructure
  in
    mkMakifLights chayaLight yechidaLight

-- | פונקציה להתלבשות אורות נר"ן בכלי, עם טיפול בשבירה אפשרית
attireNaRaNInKeli : PnimiLights → Keli → String ⊎ Keli
attireNaRaNInKeli pnimi keli =
  let
    -- בדיקת קיבולת לפני התלבשות
    totalPower = (power (nefesh pnimi)) ⊕ ((power (ruach pnimi)) ⊕ (power (neshama pnimi)))
    isWithinCapacity = cardStronger (capacity keli) totalPower
    
    -- אם סך האורות גדול מקיבולת הכלי, יווצר כלי שבור
    keliAfterAttire = attireNaRaNInKeliLayers (nefesh pnimi) (ruach pnimi) (neshama pnimi) keli
  in
    maybe′ (λ k → inj₂ k) (inj₁ "Vessel broken - capacity exceeded") keliAfterAttire

-- | פונקציה עזר לבדיקה האם ערך maybe מכיל just
isJust : ∀ {a} {A : Set a} → Maybe A → Bool
isJust nothing = false
isJust (just _) = true

-- | פונקציה להקפת אורות חיה ויחידה סביב כלי
surroundChaYAroundKeliWithGlobal : MakifLights → Keli → Context → (Keli × Bool)
surroundChaYAroundKeliWithGlobal makifs keli ctx =
  let
    -- הקפת הכלי עם אורות ח"י
    updatedKeli = surroundChaYAroundKeli (chaya makifs) (yechida makifs) keli
    
    -- רישום גלובלי של השפעת היחידה כלפי מטה (ערך אמת אם הצליח)
    globalRegistrationSuccess = true -- בפועל, כאן יהיה קוד שרושם את ההשפעה במערכת הגלובלית
  in
    (updatedKeli , globalRegistrationSuccess)

-- | פונקציה לבדיקת הצורך בשבירת כלים
checkKeliBreaking : Keli → KeliCondition
checkKeliBreaking keli =
  let
    dummyLight = mkLight (fin 0) zero LightCategory.Undifferentiated_LightCategory LightKind.Pnimi "dummy" zero nothing
    emptyPower = fin 0
    
    -- בדיקות האם שכבה קיימת
    hasInnerLayer = isJust (inner_layer keli)
    hasMiddleLayer = isJust (middle_layer keli)
    hasOuterLayer = isJust (outer_layer keli)
    
    -- חישוב עוצמת האור בכל שכבה - גישה פשוטה יותר
    innerLightPower = 
      if hasInnerLayer then fin 1 else emptyPower
        
    middleLightPower = 
      if hasMiddleLayer then fin 1 else emptyPower
        
    outerLightPower = 
      if hasOuterLayer then fin 1 else emptyPower
    
    totalLight = innerLightPower ⊕ (middleLightPower ⊕ outerLightPower)
    
    -- אם סך האור גדול מקיבולת הכלי, יש לשבור
    isOverCapacity = cardStronger totalLight (capacity keli)
  in
    if isOverCapacity then BrokenKeli else state keli

-- | פונקציה משולבת להחלת מלוא תהליך הצל"ם על כלי
applyFullTzelemProcess : Context → SefirahLevelInfo → Keli → String ⊎ (Keli × Bool)
applyFullTzelemProcess ctx lvl keli =
  let
    -- 1. יצירת אורות נר"ן פנימיים
    pnimiLights = determinePnimiNaRaNTzelem ctx lvl
    
    -- 2. יצירת אורות ח"י מקיפים
    makifLights = determineMakifChaYTzelem ctx lvl pnimiLights
    
    -- 3. התלבשות אורות נר"ן בכלי
    result = attireNaRaNInKeli pnimiLights keli
  in
    Data.Sum.[ 
      inj₁ , 
      (λ keliWithNaRaN → 
        let
          -- 4. הקפת הכלי באורות ח"י
          (finalKeli , globalSuccess) = surroundChaYAroundKeliWithGlobal makifLights keliWithNaRaN ctx
        in
          inj₂ (finalKeli , globalSuccess)) 
    ] result
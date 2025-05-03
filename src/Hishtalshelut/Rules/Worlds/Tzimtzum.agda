{-# OPTIONS --without-K #-}
module Hishtalshelut.Rules.Worlds.Tzimtzum where

-- חוקים לצמצום טרנספיניטי - שימוש באורדינלים וקרדינלים

open import Agda.Primitive using (Level; lzero; lsuc)
open import Agda.Builtin.Unit public using (⊤; tt)
open import Data.List public using (List; _∷_; []; _++_; map; length; reverse)
open import Hishtalshelut.Domain.Worlds.Tzimtzum public using (
    TzimtzumStatus; NoTzimtzum; InProgress; AfterTzimtzum;
    WillForCreation; NoWill; PotentialWill;
    ReshimuLevel; NoReshimu; PartialReshimu; CompleteReshimu;
    ContractionStep; StepStartEinSof; StepPotentialWill; StepExecuteTzimtzum; StepLeaveReshimu;
    CenterPoint; Midpoint; TzimtzumSpec; CircleShape; OrdinalLayer)
open import Hishtalshelut.State.Worlds.TzimtzumState lzero public using (
    ContractionState; initialContractionState; afterContractionStep; completeContraction;
    OrdinalLayerState; maxRadius; originalLight; reshimuByLayer; spaceIsFullOfLight; _EinSofStage; _TzimtzumStage)
open import Hishtalshelut.State.Worlds.EinSofState public using (EinSofState; initialEinSofState)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; omega; Omega; ordinalEq; ordLeq; simpleOrdLeq)
open import Hishtalshelut.Domain.CoreTypes.Light lzero using (Light; mkLight; power; structure; category; kind; source; timestamp; tzelem_letter; Yechida)
open import Hishtalshelut.Domain.Worlds.IgulimYosher lzero using (LightCategory; LightKind)
open import Hishtalshelut.Domain.Worlds.IgulimYosherReshimu lzero using (
    ReshimuSpec; ReshimuQuality; toReshimuSpec; createReshimuFromLight; computeReshimuStructure; Kelim_Root_Potential; minusOrdinal)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Bool using (Bool; true; false; if_then_else_)
open import Data.Nat using (ℕ)
open import Data.Product using (_×_; _,_; proj₁; proj₂)
open import Agda.Builtin.String using (String)

-- | יצירת אור אין-סוף מקורי עם ערכים גבוהים
createOriginalEinSofLight : Light
createOriginalEinSofLight =
  mkLight (aleph omega) Omega LightCategory.Undifferentiated_LightCategory LightKind.Pnimi "EinSof-Original" zero nothing

-- | אתחול הצמצום עם אור אין-סוף מלא
startWithFullEinSof : ⊤ → ContractionState
startWithFullEinSof _ = 
  let light = createOriginalEinSofLight in 
  initialContractionState light initialEinSofState

-- | הופעת רצון פוטנציאלי לבריאה
potentialWillForCreation : ContractionState → ContractionState
potentialWillForCreation c = record c { will = PotentialWill }

-- | ביצוע שלב צמצום עם אינדקס אורדינלי
executeOrdinalContractionStep : ContractionState → Ordinal lzero → ContractionState
executeOrdinalContractionStep c ordIndex =
  if ordinalEq ordIndex (maxRadius c)
  then completeContraction c
  else afterContractionStep c ordIndex

-- | ביצוע צמצום כללי - עדכון הסטטוס בלבד
executeTzimtzum : ContractionState → ContractionState
executeTzimtzum c = record c { status = InProgress }

-- | יצירת רשימו בשכבה אורדינלית ספציפית
leaveReshimuAtLayer : ContractionState → Ordinal lzero → ContractionState
leaveReshimuAtLayer c ordIndex =
  let
    origLight = originalLight c
    maxOrd    = maxRadius c
    computedReshimu = createReshimuFromLight origLight ordIndex maxOrd
    updatedReshimuByLayer = (ordIndex , just origLight) ∷ reshimuByLayer c
  in
    record c {
      reshimu = PartialReshimu ;
      reshimuByLayer = updatedReshimuByLayer
    }

-- | השארת רשימו סופי בכל השכבות
leaveReshimu : ContractionState → ContractionState
leaveReshimu c = completeContraction c

-- | יוצר אוסף דינמי שלבי צמצום עם שלבי ביניים אורדינליים לכל השכבות
{-# NON_TERMINATING #-}
buildContractionSteps : Ordinal lzero → List (ContractionStep lzero)
buildContractionSteps maxOrd = StepStartEinSof ∷ StepPotentialWill ∷ generateSteps zero
  where
    -- יוצר צעדים דינמית מ-0 עד maxOrd: לכל שכבה צעד ביצוע והות רשימו
    generateSteps : Ordinal lzero → List (ContractionStep lzero)
    generateSteps ord with ordLeq ord maxOrd
    ... | true  = StepExecuteTzimtzum ord ∷ StepLeaveReshimu ord ∷ generateSteps (succ ord)
    ... | false = []

-- | מממש לולאת צמצום דינמית עם אורדינלים
{-# NON_TERMINATING #-}
dynamicContractionLoop : ContractionState → Ordinal lzero → Ordinal lzero → ContractionState
dynamicContractionLoop initialState currentOrd maxOrd =
  if_then_else_ (ordLeq currentOrd maxOrd)
    (let 
      -- ביצוע צעד צמצום נוכחי
      afterContraction = executeOrdinalContractionStep initialState currentOrd
      -- השארת רשימו בשכבה הנוכחית
      afterReshimu = leaveReshimuAtLayer afterContraction currentOrd
      -- המשך לשכבה הבאה
      nextOrd = succ currentOrd
    in
      dynamicContractionLoop afterReshimu nextOrd maxOrd)
    (-- סיום הלולאה - החזרת המצב המעודכן
     completeContraction initialState)

-- | פונקציה המבצעת צמצום דינמי עד למגבלה אורדינלית
runDynamicContraction : ⊤ → Ordinal lzero → ContractionState
runDynamicContraction _ maxOrd =
  let 
    initialState = startWithFullEinSof tt
    willState = potentialWillForCreation initialState
    startState = executeTzimtzum willState
  in
    dynamicContractionLoop startState zero maxOrd

-- | Generate the list of contraction steps up to a given ordinal
{-# NON_TERMINATING #-}
generateSteps : Ordinal lzero → Ordinal lzero → ContractionState → List ContractionState
generateSteps ord maxOrd state = generateStepsHelper ord state
  where
    -- Define step helper function within the scope
    step : Ordinal lzero → ContractionState
    step ord' = executeOrdinalContractionStep state ord'

    -- Recursive helper that now has access to step
    generateStepsHelper : Ordinal lzero → ContractionState → List ContractionState
    generateStepsHelper currentOrd currentState =
      if_then_else_ (simpleOrdLeq currentOrd maxOrd) -- Use simpleOrdLeq
        (currentState ∷ generateStepsHelper (succ currentOrd) (step currentOrd))
        []

-- Note: hasLayer definition was missing, removed signature for now.
-- hasLayer : Map Ordinal OrdinalLayerState → Ordinal lzero → Bool

-- | Recursive helper function to run the contraction loop
{-# NON_TERMINATING #-}
runContractionLoop : Ordinal lzero → Ordinal lzero → ContractionState → ContractionState
runContractionLoop currentOrd maxOrd state =
  if_then_else_ (simpleOrdLeq currentOrd maxOrd) -- Use simpleOrdLeq
    ( let afterStep = executeOrdinalContractionStep state currentOrd
          afterReshimu = leaveReshimuAtLayer afterStep currentOrd
        in runContractionLoop (succ currentOrd) maxOrd afterReshimu
    )
    state
 
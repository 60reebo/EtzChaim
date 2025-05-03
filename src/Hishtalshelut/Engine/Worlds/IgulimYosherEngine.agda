{-# OPTIONS --guardedness --no-termination-check #-}

module Hishtalshelut.Engine.Worlds.IgulimYosherEngine where
--------------------------------------------------
-- IgulimYosherEngine (Engine Layer)
--------------------------------------------------
-- קובץ זה מריץ את הסימולציה בפועל על בסיס חוקי הבנייה מה-Rules.
--------------------------------------------------

-- Core imports
open import Agda.Builtin.String
import Data.String.Base as Str using (_++_)
open import Data.String renaming (_==_ to stringEq) hiding (show; map; _++_; head; tail)
open import Data.String.Base using (_++_)
open import Data.Bool
open import Data.Product using (proj₁; proj₂; _×_; _,_)
open import Data.Nat.Show using (show)
open import Data.Nat using (ℕ; zero; suc; _+_; _^_)
open import Data.List.Base as DList using (List; []; _∷_; map; concat; concatMap)
open DList using (_∷_; [])

-- Kabbalistic rules and identifiers
open import Hishtalshelut.Rules.Worlds.IgulimYosherRules hiding (simulateHierarchicalTrace)
open import Hishtalshelut.Domain.Worlds.IgulimYosher
open OlamId
open SefirahId

-- State definitions
open import Hishtalshelut.State.Worlds.IgulimYosherFullState
  using (IgulimYosherFullState; initialIgulimYosherFullState)
open IgulimYosherFullState public

-- Helper: test if a natural is zero
zero? : ℕ → Bool
zero? zero    = true
zero? (suc _) = false

-- | Convert hierarchical step to Hebrew text
stepToText : HierarchicalStepLocal → String
stepToText (InitKav ol) = "המשיך האין סוף את אורו בבחינת קו א' ישר בעולם " ++ name ol
stepToText (EnterPartzuf olam p) = "מתחילים לבנות את פרצוף " ++ PartzufId.name p ++ " ד" ++ name olam
stepToText (ExitPartzuf olam p) = "סיימנו לבנות את פרצוף " ++ PartzufId.name p ++ " ד" ++ name olam
stepToText (CircleInnerV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "תכף בתחלת התפשטותו נתגלגל כעין גלגל עגול "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (CircleOuterV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "ונעשה כעין גלגל אחד מוקף "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (CircleInnerL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור פנימי של גלגל "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (CircleOuterL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור מקיף של גלגל "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (YosherInnerV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "הקו הזה מתפשט ביושר "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (YosherOuterV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור המקיף "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (YosherInnerL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור פנימי ביושר של "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (YosherOuterL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור מקיף ביושר של "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ show purity ++ ")"
stepToText (UpdateMakifDist olam p sf d) with stringEq (name sf) "מלכות"
... | true =
  let base = "המקיף הכולל של הפרצוף ד" ++ PartzufId.name p ++ " ד" ++ name olam in
  if zero? d then
    base ++ " עדיין חופף לפנימי – כל העיגולים דבוקים זה בזה, והחיבור ביניהם הוא רק דרך הקו."
  else
    base ++ " מתרחק מהפנימי ויוצר חלל פנוי לפרצוף/עולם הבא.\nכעת מתחיל להיבנות עולם חדש בחלל זה, כשם שבעת הצמצום נוצר עיגול חדש – תחילה יצטיירו עשרה עיגולים של העולם הבא, ואחריהם יושר ומקיפים."
... | false =
  let base = "המקיף הפרטי דיושר ד" ++ name sf ++ " ד" ++ PartzufId.name p ++ " ד" ++ name olam in
  Str._++_ base " עדיין חופף לפנימי – דבוק לעיגול הפנימי, ומקושר רק דרך הקו."
stepToText (UpdateWorldMakifDist olam sf d) =
  let base = "המקיף הכולל של כל הפרצופים ד" ++ name olam in
  if zero? d then
    base ++ " עדיין חופף לפנימי – כל העיגולים דבוקים זה בזה, והחיבור ביניהם הוא רק דרך הקו."
  else
    base ++ " מתרחק מהפנימי ויוצר חלל פנוי לכל הפרצופים ולעולם הבא.\nכעת מתחיל להיבנות עולם חדש בחלל זה."

-- | Trace היררכי: כל שלב בתהליך ההשתלשלות
--hierarchicalExpansionSteps : DList.List HierarchicalStepLocal
--hierarchicalExpansionSteps = buildHierarchicalSteps partzufimOrder

-- | מריץ את כל שלבי ההשתלשלות ויוצר Trace (רשימת מצבים)
simulateHierarchicalTrace : DList.List IgulimYosherFullState
simulateHierarchicalTrace = goSteps (buildHierarchicalSteps partzufimOrder) initialIgulimYosherFullState where
  goSteps : DList.List HierarchicalStepLocal → IgulimYosherFullState → DList.List IgulimYosherFullState
  goSteps [] s = s ∷ []
  goSteps (st ∷ xs) s = s ∷ goSteps xs (stepHierarchical st s)

-- | Trace טקסטואלי ברור של כל שלב
hierarchicalTraceText : DList.List String
hierarchicalTraceText = DList.map stepToText (buildHierarchicalSteps partzufimOrder)

-- | דוגמה:
--   hierarchicalTraceText !! n  -- השלב ה-n בטקסט קריא

-- | Map נפש לרמת אור
narnahToLightCategory : Narnah → LightCategory
narnahToLightCategory Nepesh   = Nefesh
narnahToLightCategory Ruach    = Ruach
narnahToLightCategory Neshamah = Neshama

-- | Generate steps from full SefirahUnit
unitSteps : (OlamId × PartzufId) × SefirahUnit → List HierarchicalStepLocal
unitSteps _ = []

-- | Build steps based on full SefirahUnits
buildHierarchicalStepsUnits : List HierarchicalStepLocal
buildHierarchicalStepsUnits = []

-- | Full simulation from SefirahUnits-based steps
simulateUnits : List IgulimYosherFullState
simulateUnits = goHierarchicalTrace buildHierarchicalStepsUnits initialIgulimYosherFullState

-- | סימולציה מלאה: יצירת עיגולים ויושר עד סוף ההתפשטות (כל החלל מלא)
simulateFullIgulimYosher : IgulimYosherFullState
simulateFullIgulimYosher = fillChallalWithIgulimYosher

-- רשימת שמות העולמות
olamNames : DList.List String
olamNames = DList.map (λ o → name o) olamotOrder

-- | רשימת זרמי אור בכל מצב
lightsAtState : IgulimYosherFullState → DList.List Light
lightsAtState s =
  let
    k           = kavState s
    circlePairs = circlesByPartzuf s
    yosherPairs = yosherByPartzuf s
    circleLights = DList.concatMap (λ pair → DList.map (λ c → internalStream c k) (proj₂ pair)) circlePairs
    yosherLights = DList.concatMap (λ pair → DList.map (λ y → externalStream y k) (proj₂ pair)) yosherPairs
  in DList.concat (circleLights ∷ yosherLights ∷ [])

-- | Trace של זרמי אור
lightsTrace : DList.List (DList.List Light)
lightsTrace = DList.map lightsAtState simulateHierarchicalTrace

-- Pixelization: coinductive codata for infinite subdivision
open import Agda.Builtin.Coinduction

record Delay (A : Set) : Set where
  coinductive
  constructor delay
  field force : A

open Delay public

record Stream (A : Set) : Set where
  coinductive
  constructor _∷s_
  field head : A; tail : Delay (Stream A)

infixr 5 _∷s_

open Stream public

-- | Map hierarchical steps to 3D geometry
open import Hishtalshelut.Engine.Geometry3D using (Vec3; _·_; GeometryStep; DrawLine; DrawSphere; geometryStepToText)
origin : Vec3
origin = _·_ 0 0 0

centerOfPartzuf : PartzufId → Vec3
centerOfPartzuf p = let n = PartzufId.level p in _·_ n n n

growth : ℕ → ℕ
growth i = 2 ^ i

toGeometryStep : HierarchicalStepLocal → GeometryStep
toGeometryStep (InitKav _)                = DrawLine   origin (_·_ 0 0 100)
toGeometryStep (CircleInnerV _ p sf _)     = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf)) false
toGeometryStep (CircleOuterV _ p sf purity)= DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf) + purity) true
toGeometryStep (CircleInnerL _ p sf _)     = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf)) false
toGeometryStep (CircleOuterL _ p sf purity) = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf) + purity) true
toGeometryStep (YosherInnerV _ p sf _)      = DrawLine   origin (centerOfPartzuf p)
toGeometryStep (YosherOuterV _ p sf _)      = DrawLine   origin (centerOfPartzuf p)
toGeometryStep (YosherInnerL _ p sf _)      = DrawLine   (centerOfPartzuf p) origin
toGeometryStep (YosherOuterL _ p sf _)      = DrawLine   (centerOfPartzuf p) origin
toGeometryStep (UpdateMakifDist _ p sf d)  = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf) + d) true
toGeometryStep (UpdateWorldMakifDist _ sf d)= DrawSphere origin                        (growth (SefirahId.index sf) + d) true
toGeometryStep _                           = DrawLine   origin origin

-- | Geometry trace as list of strings
geometryTraceText : DList.List String
geometryTraceText = DList.map geometryStepToText (DList.map toGeometryStep (buildHierarchicalSteps partzufimOrder))

-- | Main: print both text and geometry traces
-- simulateAtDepth : ℕ → DList.List IgulimYosherFullState
-- simulateAtDepth n = take n infiniteStates

-- IO imports and join for printing moved to bottom
open import Agda.Builtin.IO public using (IO)
open import Agda.Builtin.String public using (String)
open import Agda.Builtin.Unit public using (⊤; tt)

{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}

postulate putStrLn : String → IO ⊤
{-# COMPILE GHC putStrLn = TIO.putStrLn #-}

-- | Join list of strings with separator
join : String → DList.List String → String
join _ []       = ""
join sep (x ∷ xs) = x ++ sep ++ join sep xs

main : IO ⊤
main = putStrLn (join "\n" hierarchicalTraceText ++ "\n--- Geometry ---\n" ++ join "\n" geometryTraceText)

-- | זרם אינסופי של שלבי ההשתלשלות (cycle)
cycleSteps : Stream HierarchicalStepLocal
cycleSteps = go (buildHierarchicalSteps partzufimOrder) where
  go : DList.List HierarchicalStepLocal → Stream HierarchicalStepLocal
  go (x ∷ xs) = x ∷s delay (go (DList._++_ xs (buildHierarchicalSteps partzufimOrder)))
  go [] = go (buildHierarchicalSteps partzufimOrder)

-- | זרם אינסופי של מצבים ע"פ השלבים
infiniteStates : Stream IgulimYosherFullState
infiniteStates = initialIgulimYosherFullState ∷s delay (go initialIgulimYosherFullState cycleSteps) where
  go : IgulimYosherFullState → Stream HierarchicalStepLocal → Stream IgulimYosherFullState
  go s steps = let st = head steps in let s' = stepHierarchical st s in s' ∷s delay (go s' (force (tail steps)))

-- | פונקציה לחיתוך N הראשונים מתוך סטרים
-- take : ∀ {A : Set} → ℕ → Stream A → DList.List A
-- take zero _ = []
-- take (suc n) stream = head stream ∷ take n (force (tail stream))

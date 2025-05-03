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
-- showCardinal is used for Cardinal purity
open import Data.Nat using (ℕ; zero; suc; _+_; _^_) -- ℕ only for geometry indices, not purity
open import Data.List.Base as DList using (List; []; _∷_; map; concat; concatMap)
open DList using (_∷_; [])

-- Kabbalistic rules and identifiers
open import Hishtalshelut.Rules.Worlds.IgulimYosherRules lzero hiding (simulateHierarchicalTrace)
open import Hishtalshelut.Domain.Worlds.IgulimYosher lzero hiding (Microcosm; Macrocosm)
open OlamId public
open SefirahId public
open import Hishtalshelut.Engine.Geometry3D using (Vec3; _·_; GeometryStep; DrawLine; DrawSphere; geometryStepToText)

-- State definitions
open import Hishtalshelut.State.Worlds.IgulimYosherFullState
  using (IgulimYosherFullState; initialIgulimYosherFullState; circlesByPartzuf; yosherByPartzuf; ordinalLevels; cardinalLevels)
open IgulimYosherFullState public
open import Hishtalshelut.Domain.Ordinal using (Ordinal)
open import Hishtalshelut.Domain.Cardinal using (Cardinal; showCardinal; fromNatCard; index)

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
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (CircleOuterV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "ונעשה כעין גלגל אחד מוקף "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (CircleInnerL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור פנימי של גלגל "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (CircleOuterL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור מקיף של גלגל "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (YosherInnerV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "הקו הזה מתפשט ביושר "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (YosherOuterV olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור המקיף "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (YosherInnerL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור פנימי ביושר של "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
stepToText (YosherOuterL olam p sf purity) =
  let nameSf = name sf; nameP = PartzufId.name p; nameO = name olam
      prefix = "אור מקיף ביושר של "
  in prefix ++ nameSf ++ " ד" ++ nameP ++ " ד" ++ nameO ++ " (purity=" ++ showCardinal (fromNatCard purity) ++ ")"
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
stepToText (UpdateWorldMakifDist olam sf d)=
  let base = "המקיף הכולל של כל הפרצופים ד" ++ name olam in
  if zero? d then
    base ++ " עדיין חופף לפנימי – כל העיגולים דבוקים זה בזה, והחיבור ביניהם הוא רק דרך הקו."
  else
    base ++ " מתרחק מהפנימי ויוצר חלל פנוי לכל הפרצופים ולעולם הבא.\nכעת מתחיל להיבנות עולם חדש בחלל זה."
stepToText (InitMiddle ol) = "התחלת בניית אמצעי בעולם " ++ name ol
stepToText (RecordCircleReshimu ol p sf _) = "נרשם רשימו לעיגול " ++ name sf ++ " בפרצוף " ++ PartzufId.name p ++ " בעולם " ++ name ol
stepToText (RecordYosherReshimu ol p sf _) = "נרשם רשימו ליושר " ++ name sf ++ " בפרצוף " ++ PartzufId.name p ++ " בעולם " ++ name ol
stepToText TzimtzumCenter                = "האור מצמצם את עצמו מהמרכז לצדדים ויוצר חלל פנוי במרכז"
stepToText (ContractStep r)              = "הצמצום התרחב לרדיוס " ++ show r
stepToText (RecordContractionReshimu r _) = "נרשם רשימו הצמצום ברדיוס " ++ show r

-- | Trace היררכי: כל שלב בתהליך ההשתלשלות (מריצים שלבי Rules לגלות מצבים)
simulateHierarchicalTrace : DList.List IgulimYosherFullState
simulateHierarchicalTrace = goSteps (buildHierarchicalSteps partzufimOrder) initialIgulimYosherFullState where
  goSteps : DList.List HierarchicalStepLocal → IgulimYosherFullState → DList.List IgulimYosherFullState
  goSteps [] s = s ∷ []
  goSteps (st ∷ xs) s = s ∷ goSteps xs (stepHierarchical st s)

-- | Returns the final state after all hierarchical steps (full simulation)
simulateFullIgulimYosher : IgulimYosherFullState
simulateFullIgulimYosher = lastOrInit (DList.reverse simulateHierarchicalTrace)
  where
    lastOrInit : DList.List IgulimYosherFullState → IgulimYosherFullState
    lastOrInit []      = initialIgulimYosherFullState
    lastOrInit (x ∷ _) = x

-- | Trace of ordinal levels per hierarchical step
ordinalTrace : DList.List (List (OlamId × PartzufId × Ordinal))
ordinalTrace = DList.map ordinalLevels simulateHierarchicalTrace

-- | Trace of cardinal levels per hierarchical step
cardinalTrace : DList.List (List (OlamId × PartzufId × Cardinal))
cardinalTrace = DList.map cardinalLevels simulateHierarchicalTrace

-- | Textual hierarchical trace of all steps
hierarchicalTraceText : DList.List String
hierarchicalTraceText = DList.map stepToText (buildHierarchicalSteps partzufimOrder)

-- | 3D geometry helpers
origin : Vec3
origin = _·_ 0 0 0

centerOfPartzuf : PartzufId → Vec3
centerOfPartzuf p = let n = PartzufId.level p in _·_ n n n

growth : ℕ → ℕ
growth i = 2 ^ i

depthVec : ℕ → Vec3
depthVec r = _·_ 0 (growth r) 0

addVec3 : Vec3 → Vec3 → Vec3
addVec3 (_·_ x1 y1 z1) (_·_ x2 y2 z2) = _·_ (x1 + x2) (y1 + y2) (z1 + z2)

toGeometryStep : HierarchicalStepLocal → GeometryStep
toGeometryStep (InitKav _)                = DrawLine   origin (_·_ 0 0 100)
toGeometryStep (CircleInnerV _ p sf _)     = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf)) false
toGeometryStep (CircleOuterV _ p sf purity)= DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf) + index (fromNatCard purity)) true
toGeometryStep (CircleInnerL _ p sf _)     = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf)) false
toGeometryStep (CircleOuterL _ p sf purity)= DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf) + index (fromNatCard purity)) true
toGeometryStep (YosherInnerV _ p _ _)      = DrawLine   origin (centerOfPartzuf p)
toGeometryStep (YosherOuterV _ p _ _)      = DrawLine   origin (centerOfPartzuf p)
toGeometryStep (YosherInnerL _ p _ _)      = DrawLine   (centerOfPartzuf p) origin
toGeometryStep (YosherOuterL _ p _ _)      = DrawLine   (centerOfPartzuf p) origin
toGeometryStep (UpdateMakifDist _ p sf d)  = DrawSphere (centerOfPartzuf p) (growth (SefirahId.index sf) + d) true
toGeometryStep (UpdateWorldMakifDist _ sf d)= DrawSphere origin (growth (SefirahId.index sf) + d) true
toGeometryStep TzimtzumCenter              = DrawSphere origin 1 false
toGeometryStep (ContractStep r)            = DrawLine   origin (depthVec r)
toGeometryStep (RecordContractionReshimu r _) = DrawSphere (depthVec r) (growth r) true
toGeometryStep _                           = DrawLine   origin origin

-- | Build steps based on full SefirahUnits
buildHierarchicalStepsUnits : List HierarchicalStepLocal
buildHierarchicalStepsUnits = []

-- | Full simulation from SefirahUnits-based steps
simulateUnits : List IgulimYosherFullState
simulateUnits = goHierarchicalTrace buildHierarchicalStepsUnits initialIgulimYosherFullState

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

-- | Trace of infinite hierarchical steps (cycle)
cycleSteps : Stream HierarchicalStepLocal
cycleSteps = go (buildHierarchicalSteps partzufimOrder) where
  go : DList.List HierarchicalStepLocal → Stream HierarchicalStepLocal
  go (x ∷ xs) = x ∷s delay (go (DList._++_ xs (buildHierarchicalSteps partzufimOrder)))
  go [] = go (buildHierarchicalSteps partzufimOrder)

-- | Trace of infinite states based on cycleSteps
infiniteStates : Stream IgulimYosherFullState
infiniteStates = initialIgulimYosherFullState ∷s delay (go initialIgulimYosherFullState cycleSteps) where
  go : IgulimYosherFullState → Stream HierarchicalStepLocal → Stream IgulimYosherFullState
  go s steps = let st = head steps in let s' = stepHierarchical st s in s' ∷s delay (go s' (force (tail steps)))

-- IO imports and postulate for main
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
postulate putStrLn : String → IO ⊤
{-# COMPILE GHC putStrLn = Prelude.putStrLn . Data.Text.unpack #-}

-- | Join list of strings with separator
join : String → DList.List String → String
join _ []       = ""
join sep (x ∷ xs) = x ++ sep ++ join sep xs

-- | Geometry trace: text representation of geometry steps
geometryTrace : DList.List GeometryStep
geometryTrace = DList.map toGeometryStep (buildHierarchicalSteps partzufimOrder)

geometryTraceText : DList.List String
geometryTraceText = DList.map geometryStepToText geometryTrace

-- | Show ordinalTrace and cardinalTrace in text form
open import Hishtalshelut.Domain.Ordinal using (showOrdinal)
open import Hishtalshelut.Domain.Cardinal using (showCardinal)

showOrdinalTriple : OlamId × PartzufId × Ordinal → String
showOrdinalTriple (o , p , ord) =
  name o ++ ":" ++ PartzufId.name p ++ "=" ++ showOrdinal ord

showCardinalTriple : OlamId × PartzufId × Cardinal → String
showCardinalTriple (o , p , card) =
  name o ++ ":" ++ PartzufId.name p ++ "=" ++ showCardinal card

ordinalTraceText : DList.List String
ordinalTraceText = DList.map (λ lvlList →
  join " " (DList.map showOrdinalTriple lvlList)) ordinalTrace

cardinalTraceText : DList.List String
cardinalTraceText = DList.map (λ lvlList →
  join " " (DList.map showCardinalTriple lvlList)) cardinalTrace

-- רשימת שמות העולמות
olamNames : DList.List String
olamNames = DList.map (λ o → name o) olamotOrder

-- | Main: print text, geometry, and level traces
main : IO ⊤
main = putStrLn (
    join "\n" hierarchicalTraceText ++
    "\n--- Geometry ---\n" ++ join "\n" geometryTraceText ++
    "\n--- Ordinal Levels ---\n" ++ join "\n" ordinalTraceText ++
    "\n--- Cardinal Levels ---\n" ++ join "\n" cardinalTraceText)
{-# COMPILE GHC main = main #-}

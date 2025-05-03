--------------------------------------------------
-- IgulimYosherRules (Rules Layer)
--------------------------------------------------
module Hishtalshelut.Rules.Worlds.IgulimYosherRules where

open import Data.List as List hiding (any)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Data.Bool using (if_then_else_ ; _∧_)
open import Data.Bool.ListAction using (any)
open import Data.Nat using (ℕ; zero; suc; _≤_)
open import Agda.Builtin.Nat using (_-_)
open import Agda.Builtin.String using (String)
-- open import Agda.Builtin.Nat using (_-) 
open import Data.String renaming (_==_ to stringEq)

open import Agda.Builtin.Nat renaming (_==_ to natEq)

open import Data.Product using ( Σ ; _,_ ; proj₁ ; proj₂ ; _×_ )

mapSigmaToPair : ∀ {a b} {A : Set a} {B : Set b} → List (Σ A (λ _ → B)) → List (A × B)
mapSigmaToPair = List.map (λ s → (proj₁ s , proj₂ s))

open import Relation.Binary.PropositionalEquality using (_≡_)
open import Hishtalshelut.Domain.Worlds.IgulimYosher using (PartzufId ; CircleDesc ; YosherDesc ; OlamId ; SefirahId ; LightCategory ; Nefesh ; Ruach ; KavState ; einsofValue ; sefirahUnitById ; SefirahUnit)
open PartzufId public
open import Hishtalshelut.Domain.Worlds.IgulimYosher using (World; allWorlds; worldToId; Partzuf; allPartzufs; partzufToId; Sefirah; allSefirot; sefirahToId)
open import Hishtalshelut.Domain.Worlds.IgulimYosher using (World; allWorlds; worldToId; Partzuf; allPartzufs; partzufToId; Sefirah; allSefirot; sefirahToId)
open import Hishtalshelut.Domain.LightChain using (initialStream; buildChain; LightStream; StreamUnit; VesselKind; InnerVessel; OuterVessel)

open OlamId public

olamIdEq : OlamId → OlamId → Bool
olamIdEq o1 o2 = stringEq (OlamId.name o1) (OlamId.name o2) ∧ natEq (OlamId.level o1) (OlamId.level o2)

partzufIdEq : PartzufId → PartzufId → Bool
partzufIdEq p1 p2 =
  stringEq (name p1) (name p2)
  ∧ olamIdEq (olam p1) (olam p2)
  ∧ natEq    (level p1) (level p2)

id : {A : Set} → A → A
id x = x
open import Hishtalshelut.State.Worlds.IgulimYosherFullState using (IgulimYosherFullState ; initialIgulimYosherFullState ; kavState)

-- | רשימת כל העולמות לפי סדר ההשתלשלות



olamotOrder : List OlamId
olamotOrder = List.map worldToId allWorlds

-- | רשימת כל הפרצופים בכל עולם
partzufimOrder : List PartzufId
partzufimOrder = List.concatMap (λ w → List.map (λ p → partzufToId w p) allPartzufs) allWorlds

-- | רשימת כל הספירות
data HierarchicalStepLocal : Set where
  InitKav              : OlamId → HierarchicalStepLocal
  EnterPartzuf         : OlamId → PartzufId → HierarchicalStepLocal
  ExitPartzuf          : OlamId → PartzufId → HierarchicalStepLocal

  -- Circle phases
  CircleInnerV         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  CircleOuterV         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  CircleInnerL         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  CircleOuterL         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal

  -- Yosher phases
  YosherInnerV         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  YosherOuterV         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  YosherInnerL         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  YosherOuterL         : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal

  UpdateMakifDist : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal -- עדכון מרחק מקיף דישר
  UpdateWorldMakifDist : OlamId → SefirahId → ℕ → HierarchicalStepLocal  -- world-level Makif retreat

open HierarchicalStepLocal public

open import Data.Product using (_×_ ; proj₁ ; proj₂ ; Σ)
open import Data.Maybe using (Maybe ; just ; nothing)


defaultDummy : String
defaultDummy = ""

sefirosOrder : List SefirahId
sefirosOrder = List.map sefirahToId allSefirot

-- Minimal concatMap test for type debugging
minimalConcatMapTest : List HierarchicalStepLocal
minimalConcatMapTest = List.concatMap (λ (sf : SefirahId) → CircleInnerV (record { name = "" ; level = 0 }) (record { name = "" ; olam = record { name = "" ; level = 0 } ; level = 0 }) sf 0 ∷ []) sefirosOrder

testList : List HierarchicalStepLocal
testList = CircleInnerV (record { name = "" ; level = 0 }) (record { name = "" ; olam = record { name = "" ; level = 0 } ; level = 0 }) (record { name = "" ; index = 0 }) 0 ∷ []

-- Type assertions for debugging Σ-type error
_ : List SefirahId
_ = sefirosOrder

_ : SefirahId → List HierarchicalStepLocal
_ = λ (sf : SefirahId) → CircleInnerV (record { name = "" ; level = 0 }) (record { name = "" ; olam = record { name = "" ; level = 0 } ; level = 0 }) sf 0 ∷ []

_ : List HierarchicalStepLocal
_ = List.concatMap (λ (sf : SefirahId) → CircleInnerV (record { name = "" ; level = 0 }) (record { name = "" ; olam = record { name = "" ; level = 0 } ; level = 0 }) sf 0 ∷ []) sefirosOrder

-- | הוספת עיגול חדש לפרצוף מסוים במצב
addCircle : PartzufId → ℕ → Bool → ℕ → IgulimYosherFullState → IgulimYosherFullState
addCircle p i makif purity s =
  let
    sf = record { name = "" ; index = i }
    newCircle = record { olam = olam p ; partzuf = p ; sefirah = sf ; isMakif = makif ; lightCat = Nefesh ; purity = purity }
    cByP = IgulimYosherFullState.circlesByPartzuf s
    found = any (λ pair → partzufIdEq (proj₁ pair) p) cByP
    newCircles = if_then_else_ found (List.map (λ (q , cs) → if partzufIdEq q p then (q , List._++_ cs (newCircle ∷ [])) else (q , cs)) cByP) ((p , (newCircle ∷ [])) ∷ cByP)
  in record s { circlesByPartzuf = newCircles }

-- | הוספת יושר חדש לפרצוף מסוים במצב
addYosher : PartzufId → Bool → Bool → ℕ → IgulimYosherFullState → IgulimYosherFullState
addYosher p isPnimi makif purity s =
  let
    newYosher = record { olam = olam p ; partzuf = p ; isPnimi = isPnimi ; isMakif = makif ; covers = [] ; distance = 0 ; lightCat = Ruach ; purity = purity }
    yByP = IgulimYosherFullState.yosherByPartzuf s
    found = any (λ pair → partzufIdEq (proj₁ pair) p) yByP
    newYosherList = if_then_else_ found (List.map (λ (q , cs) → if partzufIdEq q p then (q , List._++_ cs (newYosher ∷ [])) else (q , cs)) yByP) ((p , (newYosher ∷ [])) ∷ yByP)
  in record s { yosherByPartzuf = newYosherList }

-- | פונקציות פעולה היררכיות
addCircleH : PartzufId → ℕ → Bool → ℕ → IgulimYosherFullState → IgulimYosherFullState
addCircleH = addCircle
addYosherH : PartzufId → SefirahId → Bool → Bool → ℕ → IgulimYosherFullState → IgulimYosherFullState
addYosherH p sf isPnimi makif purity s =
  let
    newYosher = record { olam = olam p ; partzuf = p ; isPnimi = isPnimi ; isMakif = makif ; covers = [] ; distance = 0 ; lightCat = Ruach ; purity = purity }
    yByP = IgulimYosherFullState.yosherByPartzuf s
    found = any (λ pair → partzufIdEq (proj₁ pair) p) yByP
    newYosherList = if_then_else_ found (List.map (λ (q , cs) → if partzufIdEq q p then (q , List._++_ cs (newYosher ∷ [])) else (q , cs)) yByP) ((p , (newYosher ∷ [])) ∷ yByP)
  in record s { yosherByPartzuf = newYosherList }

-- | Build list of full SefirahUnit triples for one Partzuf in a world
buildUnitList : OlamId → PartzufId → List (OlamId × PartzufId × SefirahUnit)
buildUnitList ol p = List.map (λ sf → (ol , p , sefirahUnitById sf)) sefirosOrder

-- | Build all SefirahUnit triples for all worlds and Partzufs
buildHierarchicalUnits : List (OlamId × PartzufId × SefirahUnit)
buildHierarchicalUnits =
  let byOlam = List.map (λ ol → (ol , List.filterᵇ (λ p → olamIdEq (olam p) ol) partzufimOrder)) olamotOrder
  in List.concatMap (λ (ol , ps) → List.concatMap (λ p → buildUnitList ol p) ps) byOlam

-- | מיון בוליאני עבור רשימות

 
-- | Pair stream units into inner/outer per Sefirah
pairUnits : List StreamUnit → List (StreamUnit × StreamUnit)
pairUnits (u₁ ∷ u₂ ∷ xs) = (u₁ , u₂) ∷ pairUnits xs
pairUnits _             = []

-- | Makif flag per vessel kind
isMakifVessel : VesselKind → Bool
isMakifVessel InnerVessel = false
isMakifVessel OuterVessel = true

-- | Build circle (4 phases) per Sefirah
buildCircleSteps : OlamId → PartzufId → List HierarchicalStepLocal
buildCircleSteps ol p =
  List.concatMap f (pairUnits (buildChain initialStream allSefirot))
  where
    f : StreamUnit × StreamUnit → List HierarchicalStepLocal
    f (inner , outer) =
      let sfid    = sefirahToId (StreamUnit.seph inner)
          pureIn  = LightStream.purity (StreamUnit.innerLight inner)
          pureOut = LightStream.purity (StreamUnit.outerLight outer)
      in CircleInnerV ol p sfid pureIn ∷ CircleOuterV ol p sfid pureOut ∷ CircleInnerL ol p sfid pureIn ∷ CircleOuterL ol p sfid pureOut ∷ []

-- | Build yosher (4 phases) per Sefirah
buildYosherSteps : OlamId → PartzufId → List HierarchicalStepLocal
buildYosherSteps ol p =
  List.concatMap g (pairUnits (buildChain initialStream allSefirot))
  where
    g : StreamUnit × StreamUnit → List HierarchicalStepLocal
    g (inner , outer) =
      let sfid    = sefirahToId (StreamUnit.seph inner)
          pureIn  = LightStream.purity (StreamUnit.innerLight inner)
          pureOut = LightStream.purity (StreamUnit.outerLight outer)
      in YosherInnerV ol p sfid pureIn ∷ YosherOuterV ol p sfid pureOut ∷ YosherInnerL ol p sfid pureIn ∷ YosherOuterL ol p sfid pureOut ∷ []

-- | Build vessel steps (circle + yosher) per Partzuf
buildVesselSteps : OlamId → PartzufId → List HierarchicalStepLocal
buildVesselSteps ol p = List._++_ (buildCircleSteps ol p) (buildYosherSteps ol p)

-- | Build for Olam (hierarchical stepping)
buildForOlam : OlamId × List PartzufId → List HierarchicalStepLocal
buildForOlam (ol , partzufs) =
  InitKav ol ∷ List.concatMap (λ p →
      let middle = buildVesselSteps ol p
      in  EnterPartzuf ol p ∷ List._++_ middle [ ExitPartzuf ol p ]) partzufs

buildHierarchicalSteps : List PartzufId → List HierarchicalStepLocal
buildHierarchicalSteps ps =
  let byOlam = List.map (λ ol → (ol , List.filterᵇ (λ p → olamIdEq (olam p) ol) ps)) olamotOrder
  in List.concatMap buildForOlam byOlam

adjacentPairs : {A : Set} → List A → List (A × A)
adjacentPairs (x ∷ y ∷ xs) = (x , y) ∷ adjacentPairs (y ∷ xs)
adjacentPairs _ = []

pairs : List (PartzufId × PartzufId)
pairs = List.concatMap (λ (_ , ps) → adjacentPairs ps) (List.map (λ o → (o , List.filterᵇ (λ p → olamIdEq (olam p) o) partzufimOrder)) olamotOrder)

getChildren : PartzufId → List PartzufId
getChildren p1 = List.map proj₂ (List.filterᵇ (λ pair → partzufIdEq (proj₁ pair) p1) pairs)

buildHierarchy : List (PartzufId × List PartzufId)
buildHierarchy = List.map (λ p1 → (p1 , getChildren p1)) partzufimOrder

fullHierarchy : IgulimYosherFullState → IgulimYosherFullState
fullHierarchy s = record s { hierarchy = buildHierarchy }

-- | helper: שלבי עליה לפי הסדר הקבלי המלא

makifBaseDistance : OlamId → ℕ
makifBaseDistance olam with OlamId.level olam
... | 0 = 5  -- א"ק
... | 1 = 4  -- אצילות
... | 2 = 3  -- בריאה
... | 3 = 2  -- יצירה
... | 4 = 1  -- עשיה
... | _ = 0

leq : ℕ → ℕ → Bool
leq zero    _        = true
leq (suc _) zero     = false
leq (suc m) (suc n)  = leq m n

dynamicMakifDistance : OlamId → SefirahId → ℕ
dynamicMakifDistance olam sf =
  let base = makifBaseDistance olam in
  if_then_else_ (leq base (SefirahId.index sf)) 0 (base - SefirahId.index sf)

buildStepList' : OlamId → PartzufId → SefirahId → List HierarchicalStepLocal
buildStepList' ol p sf =
  let d = dynamicMakifDistance ol sf in
  if stringEq (SefirahId.name sf) "מלכות" then
    CircleInnerV ol p sf 0 ∷ CircleOuterV ol p sf d ∷ YosherInnerV ol p sf 0 ∷ YosherOuterV ol p sf d ∷ UpdateMakifDist ol p sf 0 ∷ UpdateMakifDist ol p sf d ∷ ExitPartzuf ol p ∷ []
  else
    CircleInnerV ol p sf 0 ∷ CircleOuterV ol p sf d ∷ YosherInnerV ol p sf 0 ∷ YosherOuterV ol p sf d ∷ UpdateMakifDist ol p sf 0 ∷ []

buildStepList = buildStepList'

-- | world-level Makif retreat at end of each world
extraMakifStep : OlamId → List PartzufId → List HierarchicalStepLocal
extraMakifStep ol partzufs with List.reverse sefirosOrder
... | (sf ∷ _) =
    let d         = makifBaseDistance ol
        worldUpd  = UpdateWorldMakifDist ol sf d
        ysherMakfs = List.map (λ p → YosherOuterV ol p sf d) partzufs
    in worldUpd ∷ ysherMakfs
... | _ = List.[]

-- | יצירת כל העיגולים לכל הפרצופים באמצעות addCircle (מאוחד)
createAllCircles : IgulimYosherFullState → IgulimYosherFullState
createAllCircles s₀ =
  List.foldl (λ s pair → addCircle (proj₁ pair) (SefirahId.index (proj₂ pair)) false 0 s)
        s₀
        (List.concatMap (λ p → List.map (λ sf → p , sf) sefirosOrder) partzufimOrder)

-- | יצירת כל היושר (פנימי ומקיף) לכל הפרצופים באמצעות addYosher (מאוחד)
createAllYosher : IgulimYosherFullState → IgulimYosherFullState
createAllYosher s₀ =
  List.foldl (λ s pair → addYosher (proj₁ pair) (proj₂ pair) false 0 s)
        s₀
        (List._++_ (List.map (λ p → p , true) partzufimOrder) (List.map (λ p → p , false) partzufimOrder))

-- | סדרת שלבי ההשתלשלות המלאה לכל הסימולציה
hierarchicalExpansionSteps : List HierarchicalStepLocal
hierarchicalExpansionSteps = buildHierarchicalSteps partzufimOrder

-- | החל את השלב ההיררכי על מצב IgulimYosherFullState
stepHierarchical : HierarchicalStepLocal → IgulimYosherFullState → IgulimYosherFullState
stepHierarchical (InitKav _) s                        = s
stepHierarchical (EnterPartzuf _ _) s                  = s
stepHierarchical (ExitPartzuf _ _) s                   = s
stepHierarchical (CircleInnerV _ p sf purity) s            = addCircle p (SefirahId.index sf) false purity s
stepHierarchical (CircleOuterV _ p sf purity) s            = addCircle p (SefirahId.index sf) true purity s
stepHierarchical (CircleInnerL _ _ _ _) s             = s
stepHierarchical (CircleOuterL _ _ _ _) s             = s
stepHierarchical (YosherInnerV _ p sf purity) s            = addYosher p true false purity s
stepHierarchical (YosherOuterV _ p sf purity) s            = addYosher p false true purity s
stepHierarchical (YosherInnerL _ _ _ _) s             = s
stepHierarchical (YosherOuterL _ _ _ _) s             = s
stepHierarchical (UpdateMakifDist _ _ _ _) s           = s
stepHierarchical (UpdateWorldMakifDist _ _ _) s        = s

-- | מריץ את כל שלבי ההשתלשלות ויוצר Trace (רשימת מצבים)
simulateHierarchicalTrace : List IgulimYosherFullState
goHierarchicalTrace : List HierarchicalStepLocal → IgulimYosherFullState → List IgulimYosherFullState
goHierarchicalTrace [] s = s ∷ []
goHierarchicalTrace (st ∷ xs) s = s ∷ goHierarchicalTrace xs (stepHierarchical st s)

simulateHierarchicalTrace =
  goHierarchicalTrace hierarchicalExpansionSteps initialIgulimYosherFullState

-- | סימולציה מלאה: יצירת עיגולים ויושר עד סוף ההתפשטות
fillChallalWithIgulimYosher : IgulimYosherFullState
fillChallalWithIgulimYosher = List.foldl (λ s st → stepHierarchical st s) initialIgulimYosherFullState hierarchicalExpansionSteps

--------------------------------------------------
-- קובץ זה מכיל רק את חוקי הבנייה והשלבים, ללא סימולציה בפועל.
--------------------------------------------------

-- (הייבוא של String/Show וכו' לא דרוש כאן)

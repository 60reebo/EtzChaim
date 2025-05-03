--------------------------------------------------
-- IgulimYosherRules (Rules Layer)
--------------------------------------------------
open import Agda.Primitive using (Level; lzero; lsuc)
module Hishtalshelut.Rules.Worlds.IgulimYosherRules (ℓ : Level) where

open import Agda.Primitive using (Level; lzero; lsuc)
open import Agda.Builtin.Unit

open import Data.List as List hiding (any)
open import Agda.Builtin.Bool using (Bool; true; false)
open import Data.Bool using (if_then_else_ ; _∧_ ; not)
open import Data.Bool.ListAction using (any)
open import Data.Nat using (ℕ; zero; suc; _≤_)
open import Agda.Builtin.Nat using (_-_)
open import Agda.Builtin.String using (String; primStringEquality)
-- open import Agda.Builtin.Nat using (_-) 
open import Data.String renaming (_==_ to stringEq)

open import Agda.Builtin.Nat renaming (_==_ to natEq)

open import Data.Product using (Σ ; _,_ ; proj₁ ; proj₂ ; _×_)
open import Data.Maybe using (Maybe ; just ; nothing)

open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (OlamId; PartzufId; SefirahId; allWorlds; worldToId; allPartzufs; partzufToId; allSefirot; sefirahToId; SefirahUnit; sefirahUnitById; Sefirah; CircleDesc; YosherDesc; LightCategory; LightKind; Pnimi; Makif; Nefesh; Ruach; KavState; einsofValue; World; Partzuf)
open import Hishtalshelut.Domain.Worlds.IgulimYosherReshimu ℓ using (ReshimuSpec; toReshimuSpec; seph)
open import Hishtalshelut.Domain.Worlds.Tzimtzum ℓ using (TzimtzumSpec; CenterPoint; Midpoint; ReshimuLevel)
open import Relation.Binary.PropositionalEquality using (_≡_)

-- גישה לשוויון וסטרינג ומספרים
stringEqLocal : String → String → Bool
stringEqLocal = primStringEquality
natEqLocal : ℕ → ℕ → Bool
natEqLocal zero zero = true
natEqLocal zero (suc _) = false
natEqLocal (suc _) zero = false
natEqLocal (suc n) (suc m) = natEqLocal n m

-- התאמת משתני עזר לפונקציות מותאמות אישית
boolEq : Bool → Bool → Bool
boolEq true true = true
boolEq false false = true
boolEq _ _ = false

nameEq : String → String → Bool
nameEq = stringEqLocal

-- הגדרה מקומית של sefirahToId למניעת התנגשויות
sefirahToIdLocal : Sefirah → SefirahId
sefirahToIdLocal s = sefirahToId s

-- | רשימת כל העולמות לפי סדר ההשתלשלות
olamotOrder : List OlamId
olamotOrder = List.map worldToId allWorlds

-- | רשימת כל הפרצופים בכל עולם
partzufimOrder : List PartzufId
partzufimOrder = List.concatMap (λ w → List.map (λ p → partzufToId w p) allPartzufs) allWorlds

-- | רשימת כל הספירות לפי סדר השתלשלות
sefirosOrder : List SefirahId
sefirosOrder = List.map sefirahToIdLocal allSefirot

-- | רשימת כל הספירות
data HierarchicalStepLocal : Set (lsuc ℓ) where
  -- Core operations
  NullStep                 : HierarchicalStepLocal
  InitMiddle               : OlamId → HierarchicalStepLocal
  InitKav                  : OlamId → HierarchicalStepLocal
  EnterPartzuf             : OlamId → PartzufId → HierarchicalStepLocal
  ExitPartzuf              : OlamId → PartzufId → HierarchicalStepLocal
  SetMacrocosm             : OlamId → HierarchicalStepLocal
  SetArch                  : OlamId → PartzufId → HierarchicalStepLocal
  SetSephUnit              : OlamId → PartzufId → SefirahId → HierarchicalStepLocal

  -- Circles
  CircleInnerV             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  CircleOuterV             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  CircleInnerL             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  CircleOuterL             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal

  -- Yosher (upright)
  YosherInnerV             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  YosherOuterV             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  YosherInnerL             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  YosherOuterL             : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal

  -- Distances
  UpdateMakifDist           : OlamId → PartzufId → SefirahId → ℕ → HierarchicalStepLocal
  UpdateWorldMakifDist      : OlamId → SefirahId → ℕ → HierarchicalStepLocal

  -- Reshimu events
  RecordCircleReshimu       : OlamId → PartzufId → SefirahId → ReshimuSpec → HierarchicalStepLocal
  RecordYosherReshimu       : OlamId → PartzufId → SefirahId → ReshimuSpec → HierarchicalStepLocal

  -- Contraction events
  TzimtzumCenter            : HierarchicalStepLocal
  ContractStep              : ℕ → HierarchicalStepLocal
  RecordContractionReshimu  : ℕ → TzimtzumSpec → HierarchicalStepLocal

  -- TzelemTransformations
  ApplyTzelemTransformations : HierarchicalStepLocal

open HierarchicalStepLocal public

open import Relation.Binary.PropositionalEquality using (_≡_)
open import Hishtalshelut.Domain.LightChain ℓ using (initialLight; buildChain; StreamUnit; VesselKind; InnerVessel; OuterVessel)
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ as CoreK using (Keli; mkKeli; updateKeliContent; seph; kind; capacity; content; KeliState; Whole)
open import Hishtalshelut.Domain.Kelim.KeliSubstance as KSub using (Zahav)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ using (Light; mkLight)
open Light public
-- מקבל פרצוף ומחזיר את זיהוי העולם שלו
olam : PartzufId → OlamId
olam p = PartzufId.olam p
open import Hishtalshelut.State.Worlds.IgulimYosherFullState ℓ using (IgulimYosherFullState; initialIgulimYosherFullState; reshimuState; kavState; contractionState; ordinalLevels; cardinalLevels; keliStates)
open import Hishtalshelut.State.Worlds.TzimtzumState ℓ using (ContractionState; afterContractionStep; PartialReshimu)
open import Hishtalshelut.State.Worlds.IgulimYosherReshimuState ℓ using (ReshimuState; reshimuByPartzuf)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; iterate)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; _⊕_; fin; aleph; index) renaming (fromNat to fromNatCard)
open import Hishtalshelut.Rules.Light.TzelemTransformations ℓ using (applyTzelemTransformations)

-- ייבוא הטרנספורמציות המתקדמות של צלם
open import Hishtalshelut.Rules.Light.TzelemTransformationsAdvanced ℓ using (applyFullTzelemProcess; Context; mkContext; SefirahLevelInfo; mkSefirahLevelInfo)

olamIdEq : OlamId → OlamId → Bool
olamIdEq o1 o2 = stringEqLocal (OlamId.name o1) (OlamId.name o2) ∧ natEqLocal (OlamId.level o1) (OlamId.level o2)

partzufIdEq : PartzufId → PartzufId → Bool
partzufIdEq p1 p2 = nameEq (PartzufId.name p1) (PartzufId.name p2)
            ∧ olamIdEq (olam p1) (olam p2)

id : {A : Set} → A → A
id x = x

-- הוספת הגדרות עבור הפונקציות החסרות
zeroC : ∀ {ℓ} → Cardinal ℓ
zeroC = fromNatCard 0

succC : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ
succC c = fromNatCard 1 ⊕ c  -- נשתמש ב-⊕ במקום להוסיף ישירות

-- | Iterate function for Cardinals
iterateCard : (Cardinal ℓ → Cardinal ℓ) → Cardinal ℓ → Cardinal ℓ → Cardinal ℓ
iterateCard f (fin 0) x = x
iterateCard f (fin (suc n)) x = iterateCard f (fin n) (f x)
iterateCard _ _ x = x  -- במקרה של cardinal אינסופי, נחזיר את המקור

iterateOrd : (Ordinal ℓ → Ordinal ℓ) → Cardinal ℓ → Ordinal ℓ → Ordinal ℓ
iterateOrd f (fin 0) ord = ord
iterateOrd f (fin (suc n)) ord = iterateOrd f (fin n) (f ord)
iterateOrd _ _ ord = ord  -- במקרה של cardinal עם aleph, נחזיר את המקור כפי שהוא

-- | המרה מקרדינל לאורדינל
toOrdinal : ∀ {ℓ} → Cardinal ℓ → ℕ
toOrdinal (fin n) = n
toOrdinal (aleph _) = 0  -- במקרה של aleph, אנו מחזירים 0 כברירת מחדל

-- | המרת אורדינל למספר טבעי (ℕ)
-- | מספרים אורדינליים סופיים מומרים לערכם המספרי
-- | אורדינלים אינסופיים מומרים ל-0 כברירת מחדל
ordinalToNat : ∀ {ℓ} → Ordinal ℓ → ℕ
ordinalToNat zero = 0
ordinalToNat (succ o) = suc (ordinalToNat o)
ordinalToNat _ = 0  -- במקרה של אורדינל אינסופי, מחזירים 0 כברירת מחדל

-- | המרת מספר טבעי (ℕ) לאורדינל
-- | מספר טבעי n מומר לאורדינל (succ zero) בהפעלה n פעמים
natToOrdinal : ∀ {ℓ} → ℕ → Ordinal ℓ
natToOrdinal zero = zero
natToOrdinal (suc n) = succ (natToOrdinal n)

defaultDummy : String
defaultDummy = ""

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
addCircle : PartzufId → Cardinal ℓ → Bool → Cardinal ℓ → IgulimYosherFullState → IgulimYosherFullState
-- | Add a new circle to a partzuf in the state, using Ordinal/Cardinal algebra
addCircle p i makif purity s =
  let ol      = olam p
      -- Ordinal and Cardinal algebra for the new levels
      newOrd  = iterateOrd succ i zero
      newCard = iterateCard succC purity zeroC
      ords    = ordinalLevels s
      cards   = cardinalLevels s
      ords'   = (ol , p , newOrd) ∷ ords
      cards'  = (ol , p , newCard) ∷ cards
  in record s { ordinalLevels = ords' ; cardinalLevels = cards' }

-- | הוספת יושר חדש לפרצוף מסוים במצב
addYosher : PartzufId → Bool → Bool → Cardinal ℓ → IgulimYosherFullState → IgulimYosherFullState
-- | Add a new yosher (upright line) to a partzuf in the state, using Ordinal/Cardinal algebra
addYosher p isPnimi makif purity s =
  let ol      = olam p
      -- Ordinal and Cardinal algebra for the new levels
      purN    = index purity
      newOrd  = iterateOrd succ (fin purN) zero
      newCard = iterateCard succC purity zeroC
      ords    = ordinalLevels s
      cards   = cardinalLevels s
      -- Use max to combine with any existing level for this partzuf (if needed)
      ords'   = (ol , p , newOrd) ∷ ords
      cards'  = (ol , p , newCard) ∷ cards
  in record s { ordinalLevels = ords' ; cardinalLevels = cards' }

-- | פונקציות פעולה היררכיות עם ממשק נוח
addCircleH : PartzufId → ℕ → Bool → ℕ → IgulimYosherFullState → IgulimYosherFullState
addCircleH p n makif purity s = addCircle p (fin n) makif (fin purity) s

addYosherH : PartzufId → SefirahId → Bool → Bool → ℕ → IgulimYosherFullState → IgulimYosherFullState
addYosherH p sf isPnimi makif purity s = addYosher p isPnimi makif (fin purity) s

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

-- | Convert vessel classification into a light kind
vesselKindToLightKind : VesselKind → LightKind
vesselKindToLightKind InnerVessel = Pnimi
vesselKindToLightKind OuterVessel = Makif

-- | Convert a stream unit into a Keli vessel
streamUnitToKeli : StreamUnit → CoreK.Keli
streamUnitToKeli su = CoreK.mkKeli (sefirahToIdLocal (StreamUnit.seph su))
                              (vesselKindToLightKind (StreamUnit.kind su))
                              KSub.Zahav
                              cap
                              initCont
                              ""               -- label
                              []               -- tzelem_letters
                              CoreK.Whole      -- state
                              nothing          -- inner_layer
                              nothing          -- middle_layer
                              nothing          -- outer_layer
                              nothing          -- surrounding_makif_chozer
                              nothing          -- surrounding_makif_yashar
  where
    initCont = if_then_else_ (isMakifVessel (StreamUnit.kind su))
                             (StreamUnit.outerLight su)
                             (StreamUnit.innerLight su)
    cap = power initCont

-- | Build circle (4 phases) per Sefirah
buildCircleSteps : OlamId → PartzufId → List HierarchicalStepLocal
buildCircleSteps ol p =
  List.concatMap f (pairUnits (buildChain initialLight allSefirot))
  where
    f : StreamUnit × StreamUnit → List HierarchicalStepLocal
    f (inner , outer) =
      let sfid    = sefirahToIdLocal (StreamUnit.seph inner)
          pureIn  = timestamp (StreamUnit.innerLight inner)
          pureOut = timestamp (StreamUnit.outerLight outer)
          pureInNat = ordinalToNat pureIn
          pureOutNat = ordinalToNat pureOut
      in CircleInnerV ol p sfid pureInNat ∷ CircleOuterV ol p sfid pureOutNat ∷ CircleInnerL ol p sfid pureInNat ∷ CircleOuterL ol p sfid pureOutNat ∷ []

-- | Build yosher (4 phases) per Sefirah
buildYosherSteps : OlamId → PartzufId → List HierarchicalStepLocal
buildYosherSteps ol p =
  List.concatMap g (pairUnits (buildChain initialLight allSefirot))
  where
    g : StreamUnit × StreamUnit → List HierarchicalStepLocal
    g (inner , outer) =
      let sfid    = sefirahToIdLocal (StreamUnit.seph inner)
          pureIn  = timestamp (StreamUnit.innerLight inner)
          pureOut = timestamp (StreamUnit.outerLight outer)
          pureInNat = ordinalToNat pureIn
          pureOutNat = ordinalToNat pureOut
      in YosherInnerV ol p sfid pureInNat ∷ YosherOuterV ol p sfid pureOutNat ∷ YosherInnerL ol p sfid pureInNat ∷ YosherOuterL ol p sfid pureOutNat ∷ []

-- | Build vessel steps (circle + yosher) per Partzuf
buildVesselSteps : OlamId → PartzufId → List HierarchicalStepLocal
buildVesselSteps ol p = List._++_ (buildCircleSteps ol p) (buildYosherSteps ol p)

-- | Build for Olam (hierarchical stepping)
buildForOlam : OlamId × List PartzufId → List HierarchicalStepLocal
buildForOlam (ol , partzufs) =
  List.concatMap (λ p →
      let middle = buildVesselSteps ol p
      in EnterPartzuf ol p ∷ List._++_ middle [ ExitPartzuf ol p ]) partzufs

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
  if stringEqLocal (SefirahId.name sf) "מלכות" then
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

-- | Build contraction steps for Tzimtzum

-- | Range from 1 to n
rangeAsc : ℕ → List ℕ
rangeAsc zero    = []
rangeAsc (suc n) = List._++_ (rangeAsc n) (suc n ∷ [])

-- | Build contraction steps for Tzimtzum
buildContractionSteps : ℕ → List HierarchicalStepLocal
buildContractionSteps maxR =
  let radii = rangeAsc maxR
      steps = List.map ContractStep radii
      spec  = record { center = Midpoint ; maxRadius = natToOrdinal maxR }
  in TzimtzumCenter ∷ (List._++_ steps (RecordContractionReshimu maxR spec ∷ []))

-- | סדרת שלבי ההשתלשלות המלאה לכל הסימולציה - כולל טרנספורמציות צל"ם
hierarchicalExpansionSteps : List HierarchicalStepLocal
hierarchicalExpansionSteps = 
  List._++_ 
    (buildContractionSteps zero) 
    (List._++_
      (buildHierarchicalSteps partzufimOrder) 
      (ApplyTzelemTransformations ∷ []))

-- | helper: שלבי עליה לפי הסדר הקבלי המלא

-- | Boolean equality on SefirahId (vs propositional) and VesselKind
sefirahIdEq : SefirahId → SefirahId → Bool
sefirahIdEq sf1 sf2 = stringEqLocal (SefirahId.name sf1) (SefirahId.name sf2) ∧ natEqLocal (SefirahId.index sf1) (SefirahId.index sf2)

vesselKindEq : VesselKind → VesselKind → Bool
vesselKindEq InnerVessel InnerVessel = true
vesselKindEq OuterVessel OuterVessel = true
vesselKindEq _ _ = false

-- | יצירת כל העיגולים לכל הפרצופים באמצעות addCircle (מאוחד)
createAllCircles : IgulimYosherFullState → IgulimYosherFullState
createAllCircles s₀ =
  List.foldl (λ s pair → addCircle (proj₁ pair) (fin (SefirahId.index (proj₂ pair))) false (fin 0) s)
        s₀
        (List.concatMap (λ p → List.map (λ sf → p , sf) sefirosOrder) partzufimOrder)

-- | יצירת כל היושר (פנימי ומקיף) לכל הפרצופים באמצעות addYosher (מאוחד)
createAllYosher : IgulimYosherFullState → IgulimYosherFullState
createAllYosher s₀ =
  List.foldl (λ s pair → addYosher (proj₁ pair) (proj₂ pair) false (fin 0) s)
        s₀
        (List._++_ (List.map (λ p → p , true) partzufimOrder) (List.map (λ p → p , false) partzufimOrder))

-- | החל את השלב ההיררכי על מצב IgulimYosherFullState
stepHierarchical : HierarchicalStepLocal → IgulimYosherFullState → IgulimYosherFullState
stepHierarchical (InitMiddle _) s                        = s
stepHierarchical (InitKav _) s                        = s
stepHierarchical (EnterPartzuf olam p) s                  = record s { keliStates = (olam , p , List.map streamUnitToKeli (buildChain initialLight allSefirot)) ∷ keliStates s }
stepHierarchical (ExitPartzuf olam p) s =
  record s { keliStates =
      List.concatMap (λ t →
        let o   = proj₁ t
            pr  = proj₂ t
            p'  = proj₁ pr
        in if_then_else_ (olamIdEq o olam ∧ partzufIdEq p' p)
             [] (t ∷ [])) (keliStates s) }
stepHierarchical (CircleInnerV olam p sf purityN) s =
  let purity = fromNatCard purityN
      purityOrd = natToOrdinal (toOrdinal purity)
      s' = addCircle p (fromNatCard (SefirahId.index sf)) false purity s
      updated = List.map (λ (ol' , p' , kl) →
        if_then_else_
          ((olamIdEq ol' olam ∧ partzufIdEq p' p))
          (ol' , p' , List.map (λ k →
            if_then_else_
              ((sefirahIdEq (sefirahToIdLocal (seph k)) sf) ∧ (vesselKindEq (kind k) InnerVessel))
              (updateKeliContent k (mkLight ((capacity k) ⊕ (power (content k))) (natToOrdinal (ordinalToNat (structure (content k)) + ordinalToNat purityOrd)) (category (content k)) (kind (content k)) (source (content k)) purityOrd))
              k) kl)
          (ol' , p' , kl)) (keliStates s')
  in record s' { keliStates = updated }
stepHierarchical (CircleOuterV olam p sf purityN) s =
  let purity = fromNatCard purityN
      purityOrd = natToOrdinal (toOrdinal purity)
      s' = addCircle p (fromNatCard (SefirahId.index sf)) true purity s
      updated = List.map (λ (ol' , p' , kl) →
        if_then_else_
          ((olamIdEq ol' olam ∧ partzufIdEq p' p))
          (ol' , p' , List.map (λ k →
            if_then_else_
              ((sefirahIdEq (sefirahToIdLocal (seph k)) sf) ∧ (vesselKindEq (kind k) OuterVessel))
              (updateKeliContent k (mkLight ((capacity k) ⊕ (power (content k))) (natToOrdinal (ordinalToNat (structure (content k)) + ordinalToNat purityOrd)) (category (content k)) (kind (content k)) (source (content k)) purityOrd))
              k) kl)
          (ol' , p' , kl)) (keliStates s')
  in record s' { keliStates = updated }
stepHierarchical (CircleInnerL _ _ _ _) s             = s
stepHierarchical (CircleOuterL _ _ _ _) s             = s
stepHierarchical (YosherInnerV olam p sf purityN) s =
  let purity = fromNatCard purityN
      purityOrd = natToOrdinal (toOrdinal purity)
      s' = addYosher p true false purity s
      updated = List.map (λ (ol' , p' , kl) →
        if_then_else_
          ((olamIdEq ol' olam ∧ partzufIdEq p' p))
          (ol' , p' , List.map (λ k →
            if_then_else_
              ((sefirahIdEq (sefirahToIdLocal (seph k)) sf) ∧ (vesselKindEq (kind k) InnerVessel))
              (updateKeliContent k (mkLight ((capacity k) ⊕ (power (content k))) (natToOrdinal (ordinalToNat (structure (content k)) + ordinalToNat purityOrd)) (category (content k)) (kind (content k)) (source (content k)) purityOrd))
              k) kl)
          (ol' , p' , kl)) (keliStates s')
  in record s' { keliStates = updated }
stepHierarchical (YosherOuterV olam p sf purityN) s =
  let purity = fromNatCard purityN
      purityOrd = natToOrdinal (toOrdinal purity)
      s' = addYosher p false true purity s
      updated = List.map (λ (ol' , p' , kl) →
        if_then_else_
          ((olamIdEq ol' olam ∧ partzufIdEq p' p))
          (ol' , p' , List.map (λ k →
            if_then_else_
              ((sefirahIdEq (sefirahToIdLocal (seph k)) sf) ∧ (vesselKindEq (kind k) OuterVessel))
              (updateKeliContent k (mkLight ((capacity k) ⊕ (power (content k))) (natToOrdinal (ordinalToNat (structure (content k)) + ordinalToNat purityOrd)) (category (content k)) (kind (content k)) (source (content k)) purityOrd))
              k) kl)
          (ol' , p' , kl)) (keliStates s')
  in record s' { keliStates = updated }
stepHierarchical (YosherInnerL _ _ _ _) s             = s
stepHierarchical (YosherOuterL _ _ _ _) s             = s
stepHierarchical (UpdateMakifDist _ _ _ _) s           = s
stepHierarchical (UpdateWorldMakifDist _ _ _) s        = s
stepHierarchical (RecordCircleReshimu ol p sf rs) s =
  let rsS      = reshimuState s
      triples  = reshimuByPartzuf rsS
      updated  = List.map (λ (ol' , p' , specs) →
                            if (olamIdEq ol' ol ∧ partzufIdEq p' p)
                            then (ol' , p' , rs ∷ specs)
                            else (ol' , p' , specs)) triples
      rsS'     = record rsS { reshimuByPartzuf = updated }
  in record s { reshimuState = rsS' }
stepHierarchical (RecordYosherReshimu ol p sf rs) s =
  let rsS      = reshimuState s
      triples  = reshimuByPartzuf rsS
      updated  = List.map (λ (ol' , p' , specs) →
                            if (olamIdEq ol' ol ∧ partzufIdEq p' p)
                            then (ol' , p' , rs ∷ specs)
                            else (ol' , p' , specs)) triples
      rsS'     = record rsS { reshimuByPartzuf = updated }
  in record s { reshimuState = rsS' }
stepHierarchical TzimtzumCenter s =
  let cs  = contractionState s
      cs' = afterContractionStep cs zero
  in record s { contractionState = cs' }
stepHierarchical (ContractStep r) s =
  let cs  = contractionState s
      cs' = record cs { radius = r }
  in record s { contractionState = cs' }
stepHierarchical (RecordContractionReshimu r _) s =
  let cs  = contractionState s
      cs' = record cs { reshimu = PartialReshimu }
  in record s { contractionState = cs' }

-- | שלב הטיפול באותיות הצל"ם - מוסיף תמיכה בטרנספורמציות צל"ם לכל הכלים
stepHierarchical (ApplyTzelemTransformations) s = applyTzelemTransformations s

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
     
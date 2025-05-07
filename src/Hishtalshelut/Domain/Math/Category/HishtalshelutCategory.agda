{-# OPTIONS --without-K #-}

open import Agda.Primitive using (Level; lsuc; _⊔_)

module Hishtalshelut.Domain.Math.Category.HishtalshelutCategory (o : Level) where

open import Relation.Binary.PropositionalEquality using (_≡_; refl; cong; sym; trans; subst)
open import Hishtalshelut.Domain.Math.Category.Base using (Category)
open Category public
open import Hishtalshelut.State.Worlds.IgulimYosherFullState o using (IgulimYosherFullState; contractionState)
open import Hishtalshelut.Domain.Worlds.IgulimYosher o using (OlamId; PartzufId; SefirahUnit)
open import Hishtalshelut.Rules.Worlds.Tzimtzum o using (executeTzimtzum)
open import Hishtalshelut.Rules.Worlds.IgulimYosherRules o using (stepHierarchical; InitKav)
open import Data.List public using (List; []; _∷_; _++_)
open import Data.List.Properties using (++-identityˡ; ++-identityʳ; ++-assoc)
open import Hishtalshelut.Rules.Light.TzelemTransformations o using (applyTzelemTransformations)
open import Data.Nat using (ℕ) -- ensure ℕ is in scope
open import Function.Base using (_∘_)

-- | Execute Makif distancing logic in RULES layer
postulate
  R_executeMakifDistancing : PartzufId → ℕ → IgulimYosherFullState → IgulimYosherFullState

-- | Execute Sefirah emanation logic in RULES layer
postulate
  executeSefirahEmanationStep : SefirahUnit → IgulimYosherFullState → IgulimYosherFullState

-- | Elementary simulation rules as morphisms
data ElementaryRule : Set (lsuc o) where
  E-Id   : ElementaryRule
  E-Tzim : ElementaryRule
  E-Kav  : OlamId → ElementaryRule

-- | הפעלת חוק על מצב
applyRule : ElementaryRule → IgulimYosherFullState → IgulimYosherFullState
applyRule E-Id       s = s
applyRule E-Tzim     s = record s { contractionState = executeTzimtzum (contractionState s) }
applyRule (E-Kav w)  s = stepHierarchical (InitKav w) s

-- | יישום סדרת חוקים
applyRuleSeq : List ElementaryRule → IgulimYosherFullState → IgulimYosherFullState
applyRuleSeq []       s = s
applyRuleSeq (r ∷ rs) s = applyRuleSeq rs (applyRule r s)

-- | Distributes over concatenation
applyRuleSeq-++ : ∀ {a b c} → List ElementaryRule → List ElementaryRule → IgulimYosherFullState → IgulimYosherFullState
applyRuleSeq-++ rs1 rs2 s = applyRuleSeq rs2 (applyRuleSeq rs1 s)

-- | Description of which functions are considered legal rule functions
data isRuleFunction : (IgulimYosherFullState → IgulimYosherFullState) → Set (lsuc o) where
  isId        : isRuleFunction (λ s → s)
  isTzimtzum  : isRuleFunction (λ s → record s { contractionState = executeTzimtzum (contractionState s) })
  isKav       : ∀ (oid : OlamId) → isRuleFunction (λ s → stepHierarchical (InitKav oid) s)
  isMakifDist : ∀ (pid : PartzufId) (dist : ℕ) → isRuleFunction (λ st → R_executeMakifDistancing pid dist st)
  isSefEman   : ∀ (u : SefirahUnit) → isRuleFunction (λ st → executeSefirahEmanationStep u st)
  isTzelem    : isRuleFunction applyTzelemTransformations
  isComp      : ∀ {f g} → isRuleFunction f → isRuleFunction g → isRuleFunction (λ s → g (f s))

-- | New definition of StateTransition with direct reliance on the "real" functions from the RULES layer
record StateTransition (a b : IgulimYosherFullState) : Set (lsuc o) where
  field
    apply : IgulimYosherFullState → IgulimYosherFullState
    spec : isRuleFunction apply
    outcome : (s : IgulimYosherFullState) → a ≡ s → b ≡ apply s

open StateTransition

-- | Identity transition
id-transition : ∀ {a} → StateTransition a a
id-transition = record
  { apply = λ s → s
  ; spec = isId
  ; outcome = λ s eq → eq
  }

-- | Composition of transitions
compose-transition : {a b c : IgulimYosherFullState} → StateTransition b c → StateTransition a b → StateTransition a c
compose-transition t2 t1 = record
  { apply = λ s → t2 .apply (t1 .apply s)
  ; spec = isComp (t1 .spec) (t2 .spec)
  ; outcome = λ s → λ eq → let intermediate = t1 .apply s; result = t2 .apply intermediate in subst (λ x → _ ≡ x) (sym (trans (t1 .outcome s eq) (t2 .outcome intermediate (refl {x = intermediate})))) refl
  }

-- | Proof of category axioms
id-left-his : ∀ {a b} (f : StateTransition a b) → compose-transition id-transition f ≡ f
id-left-his f = refl

id-right-his : ∀ {a b} (f : StateTransition a b) → compose-transition f id-transition ≡ f
id-right-his f = refl

assoc-his : ∀ {a b c d} (f : StateTransition a b) (g : StateTransition b c) (h : StateTransition c d) → compose-transition (compose-transition f g) h ≡ compose-transition f (compose-transition g h)
assoc-his f g h = refl

-- | Concrete transitions for rules
mkTzimtzumMorph : ∀ (s : IgulimYosherFullState) → StateTransition s (record s { contractionState = executeTzimtzum (contractionState s) })
mkTzimtzumMorph s = record
 { apply = λ x → applyRule E-Tzim x
 ; spec = isTzimtzum
 ; outcome = λ x eq → eq
 }

mkKavMorph : ∀ (w : OlamId) (s : IgulimYosherFullState) → StateTransition s (stepHierarchical (InitKav w) s)
mkKavMorph w s = record
  { apply = λ x → applyRule (E-Kav w) x
  ; spec = isKav w
  ; outcome = λ x eq → eq
  }

mkMakifDistancingMorph : ∀ s pid dist → StateTransition s (R_executeMakifDistancing pid dist s)
mkMakifDistancingMorph s pid dist = record
  { apply = λ st → R_executeMakifDistancing pid dist st
  ; spec = isMakifDist pid dist
  ; outcome = λ st eq → eq
  }

mkEmanateSefirahMorph : ∀ s u → StateTransition s (executeSefirahEmanationStep u s)
mkEmanateSefirahMorph s u = record
  { apply = λ st → executeSefirahEmanationStep u st
  ; spec = isSefEman u
  ; outcome = λ st eq → eq
  }

-- | The specific category for Hishtalshelut simulation
HishtalshelutCategory : Category (lsuc o) (lsuc o)
HishtalshelutCategory = record
  { Obj      = IgulimYosherFullState
  ; _⟶_      = StateTransition
  ; id       = id-transition
  ; _∘_      = compose-transition
  ; id-left  = id-left-his
  ; id-right = id-right-his
  ; assoc    = assoc-his
  }

-- | Concrete morphisms for core simulation steps
mkInitialTzimtzumMorph : (s : IgulimYosherFullState) → StateTransition s (record s { contractionState = executeTzimtzum (contractionState s) })
mkInitialTzimtzumMorph s = mkTzimtzumMorph s

mkKavInsertionMorph : ∀ (w : OlamId) (s : IgulimYosherFullState) → StateTransition s (stepHierarchical (InitKav w) s)
mkKavInsertionMorph w s = mkKavMorph w s

-- | After choosing a specific Sefirah unit, apply tzelem transformations on all tools
mkEmanateSefirahUnitMorph : (s : IgulimYosherFullState) (u : SefirahUnit) → StateTransition s (applyTzelemTransformations s)
mkEmanateSefirahUnitMorph s _ = record
  { apply = applyTzelemTransformations s
  ; spec = isTzelem
  ; outcome = λ x eq → eq
  }

-- | After Makif distancing, wrap RULES logic via R_executeMakifDistancing
mkMakifDistancingMorph2 : ∀ s pid dist → StateTransition s (R_executeMakifDistancing pid dist s)
mkMakifDistancingMorph2 s pid dist = mkMakifDistancingMorph s pid dist

-- | After Sefirah emanation, wrap RULES logic via executeSefirahEmanationStep
mkEmanateSefirahMorph2 : ∀ s u → StateTransition s (executeSefirahEmanationStep u s)
mkEmanateSefirahMorph2 s u = mkEmanateSefirahMorph s u

                                                                                                                                                                    
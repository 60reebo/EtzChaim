--------------------------------------------------
-- Olam Akudim (The World of Binding)
--
-- STATE LAYER: This module defines the dynamic state of Olam Akudim for simulation purposes.
-- All types here represent the mutable, runtime state of Akudim.
--
-- Separation of Concerns:
--   * Domain/OlamAkudim.agda - defines the static conceptual structure of Akudim (types, constants).
--   * State/Olam/Akudim.agda - defines the dynamic state (what changes during simulation).
--   * Rules/Emanation/Akudim.agda - defines the logic and transitions between states.
--------------------------------------------------
module Hishtalshelut.State.Olam.Akudim where

open import Agda.Primitive public
open import Data.List.Base using (List; []; _∷_; length)
open import Agda.Builtin.Nat public -- Always exports Nat and zero. For stdlib, use Data.Nat.Base.
open import Data.Maybe using (Maybe; nothing)
open import Data.Bool using (Bool; false)
open import Data.Product using (_×_; _,_)
open import Function using (_∘_)
open import Relation.Nullary using (Dec; yes; no)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Hishtalshelut.Domain.All public
open import Hishtalshelut.Lib.EqDec public -- TODO: fix metas in EqDec to allow 'using (_s==?_)'
open import Hishtalshelut.Rules.Emanation.AdamKadmon public using (AdamKadmonState)
open import Hishtalshelut.Rules.Emanation.Chotem public using (ChotemState)

open import Hishtalshelut.Domain.OlamAkudim public

------------------------------------------------------------------------
-- | KeliStateAkudim: State of the single Keli in Akudim.
--   * NoKeli_Ak         - No vessel formed yet.
--   * Forming_Ak        - Vessel is forming (with current capacity and progress).
--   * Finalized_All_Ak  - Vessel is finalized (with capacity and internal ZON presence).
data KeliStateAkudim : Set where
  NoKeli_Ak         : KeliStateAkudim
  Forming_Ak        : Capacity → KeliFormationProgress → KeliStateAkudim
  Finalized_All_Ak  : Capacity → InternalZONPresence → KeliStateAkudim

-- | initialKeliProgress: The initial (empty) progress for Keli formation.
initialKeliProgress : KeliFormationProgress
initialKeliProgress = mkKFP 0 0 false false NoInternalZON

-- | initialKeliStateAkudim: The initial state (no Keli formed).
initialKeliStateAkudim : KeliStateAkudim
initialKeliStateAkudim = NoKeli_Ak

------------------------------------------------------------------------
-- | AkudimState: The full dynamic state of Olam Akudim during simulation.
--   * lightsStatus   - Mapping from Sefirah to its AkudimLightStatus.
--   * theOneKeli     - The current state of the single Keli.
--   * reshimuMap     - Mapping from Sefirah to its Reshimu (impression) level.
--   * ascendedLights - List of Sefirot that have ascended in the process.
--   * activeMvMSef   - The Sefirah currently active in the MvM phase (if any).
record AkudimState : Set where
  constructor mkAkudimState
  field
    lightsStatus   : Sefirah → AkudimLightStatus
    theOneKeli     : KeliStateAkudim
    reshimuMap     : Sefirah → Maybe ReshimuLevel
    ascendedLights : List Sefirah
    activeMvMSef   : Maybe Sefirah

------------------------------------------------------------------------
-- NOTE: All logic for state transitions (emanation, hitalkut, MvM, etc.) should be implemented
--       in the Rules layer (see Rules/Emanation/Akudim.agda). This file should contain only
--       state representations and pure utility functions for state construction.
------------------------------------------------------------------------
-- Phase 0: Emanation from Peh (Setting up Akudim)
---------------------------------------------------------

-- | Function creating the initial state for Akudim dynamics
createInitialAkudimLightMap : Sefirah → AkudimLightStatus
createInitialAkudimLightMap _ = LightNotEmanated

-- | Initial Akudim state as emanated from Peh
initialAkudimStateFromPeh : AkudimState
initialAkudimStateFromPeh = mkAkudimState createInitialAkudimLightMap NoKeli_Ak (λ _ → nothing) [] nothing

-- | Conceptual function for emanation from Peh
emanateFromPeh : AdamKadmonState → ChotemState → (AdamKadmonState × AkudimState)
emanateFromPeh akState chotemState = (akState , initialAkudimStateFromPeh)
-- Placeholder: Extracts Taamim Tachtonim / Otiyot, returns starting state for Akudim Phase 1.
-- Keli formation starts later, during Hitalkut.

---------------------------------------------------------
-- Phase 1: Initial Emanation (Bottom-up, NaRaNChaY Revelation)
---------------------------------------------------------

open import Data.List.Base using (List; []; _∷_; map; filter; foldl)
open import Data.List.Membership.Decidable using (_∈?_)
open import Data.Nat using (_+_)
open import Data.Bool using (Bool; true; false; not; if_then_else_)
open import Data.Maybe using (Maybe; just; nothing; maybe)
open import Function using (_∘_)
open import Relation.Nullary using (Dec; yes; no)

emanationOrder : List Sefirah
emanationOrder = Malchut ∷ Yesod ∷ Hod ∷ Netzach ∷ Tiferet ∷ Gevurah ∷ Chesed ∷ Daat ∷ Binah ∷ Chochmah ∷ Keter ∷ []

-- Helper to get next Sefirah to emanate
findFirstNotIn : List Sefirah → List Sefirah → Maybe Sefirah
findFirstNotIn [] _ = nothing
findFirstNotIn (x ∷ xs) ys with x ∈? ys
... | yes _ = findFirstNotIn xs ys
... | no _ = just x

-- Helper for looking up AkudimLightStatus (not Maybe)
lookupMap : Sefirah → (Sefirah → AkudimLightStatus) → AkudimLightStatus
lookupMap s m = m s

-- Helper to update revealed light
revealLight : LightLevelStatus → LightLevel → LightLevelStatus
revealLight status amount = record status { revealed = status .LightLevelStatus.revealed + amount }

-- Helper to check if a Sefirah is part of Z"A
isZA : Sefirah → Bool
isZA s = s ==? Chesed || s ==? Gevurah || s ==? Tiferet || s ==? Netzach || s ==? Hod || s ==? Yesod

-- Updates the light state of sBelow based on sEmanating emerging
updateLowerSefirah : (sEmanating : Sefirah) (sBelow : Sefirah) (currentLightStateBelow : LightStateAkudim) → LightStateAkudim
updateLowerSefirah sEmanating sBelow lightStateBelow = {!!} -- Placeholder using NRNChY revelation logic

-- Helper: Update function map
updateMapSefirah : (Sefirah → A) → Sefirah → A → (Sefirah → A)
updateMapSefirah map key value = {!!}

-- Step function for the Initial Emanation phase
stepAkudimEmanation : AkudimState → AkudimState
stepAkudimEmanation currentState =
  let emergedList = currentState .AkudimState.ascendedLights in
  case findFirstNotIn emanationOrder emergedList of
    nothing → currentState
    just sNext →
      let
        -- Placeholder
        initialNefeshAmount : LightLevel
        initialNefeshAmount = 100
        initialLight_sNext : LightStateAkudim
        initialLight_sNext = record emptyAkudimLightState { nefesh = mkLLS initialNefeshAmount initialNefeshAmount }
        status_sNext : AkudimLightStatus
        status_sNext = LightPresent_Ak initialLight_sNext
        newLightsStatusMap : Sefirah → AkudimLightStatus
        newLightsStatusMap s =
          if s ==? sNext then status_sNext
          else
            let currentStatus = currentState .AkudimState.lightsStatus s in
            maybe currentStatus
              (λ _ → case currentStatus of
                LightPresent_Ak ls → LightPresent_Ak (updateLowerSefirah sNext s ls)
                _ → currentStatus)
              (s ∈? emergedList)
        newEmergedList = sNext ∷ emergedList
        currentKeli = currentState .AkudimState.theOneKeli
      in record currentState { lightsStatus = newLightsStatusMap
                            ; ascendedLights = newEmergedList
                            ; theOneKeli = currentKeli }

---------------------------------------------------------
-- Phase 2: Hitalkut (Top-down Ascent, Keli Formation)
---------------------------------------------------------

-- Placeholder Helper Functions (Using refined logic agreed upon)
calculateReshimu : LightStateAkudim → ReshimuLevel
calculateReshimu ls = ls .LightStateAkudim.nefesh .LightLevelStatus.revealed / 2

achorDinLevel : Sefirah → Nat
achorDinLevel Keter    = 10
achorDinLevel Chochmah = 9
achorDinLevel Binah    = 8
achorDinLevel Daat     = 7
achorDinLevel Chesed   = 6
achorDinLevel Gevurah  = 5
achorDinLevel Tiferet  = 4
achorDinLevel Netzach  = 3
achorDinLevel Hod      = 2
achorDinLevel Yesod    = 1
achorDinLevel Malchut  = 0

calculateOhrHozer : (ascended : List Sefirah) → (target : Sefirah) → OhrHozerLevel
calculateOhrHozer asc target = {!!} -- Sums achorDinLevel of ascended above target

hakaah : OhrHozerLevel → ReshimuLevel → KeliSubstance
hakaah ohrH reshimu = ohrH / 3 -- Substance proportional to Ohr Hozer

accumulateKeliSubstance : KeliSubstance → KeliStateAkudim → KeliStateAkudim
accumulateKeliSubstance newS (Forming_Ak cap p) = Forming_Ak cap (record p { substance = p .KeliFormationProgress.substance + newS })
accumulateKeliSubstance _ k = k

-- Placeholder List/Map Utilities
ascentOrder : List Sefirah
ascentOrder = Keter ∷ Chochmah ∷ Binah ∷ Daat ∷ Chesed ∷ Gevurah ∷ Tiferet ∷ Netzach ∷ Hod ∷ Yesod ∷ Malchut ∷ []

_∈?_ : Sefirah → List Sefirah → Dec (Any (_s==?_))
_∈?_ = {!!}

findFirstNotIn : List Sefirah → List Sefirah → Maybe Sefirah
findFirstNotIn = {!!}

updateMap : {B : Set} → Dec (_≡_ {A = Sefirah}) → (Sefirah → B) → Sefirah → B → (Sefirah → B)
updateMap _ f k v = λ x → if x ==? k then v else f x

lookupMapMaybe : {B : Set} → Sefirah → (Sefirah → Maybe B) → Maybe B
lookupMapMaybe s m = m s

findLevelsBelow : Sefirah → List Sefirah
findLevelsBelow = {!!}

getOriginalLightState : AkudimLightStatus → Maybe LightStateAkudim
getOriginalLightState (LightPresent_Ak ls) = just ls
getOriginalLightState (LightAscended_Ak ls) = just ls
getOriginalLightState _ = nothing

foldl : {A B : Set} → (B → A → B) → B → List A → B
foldl f z [] = z
foldl f z (x ∷ xs) = foldl f (f z x) xs

-- Function to initialize the Hitalkut State
transitionToHitalkut : AkudimState → AkudimState
transitionToHitalkut stateAfterEmanation =
  let
    -- Placeholder capacity
    initialCapacity : Capacity
    initialCapacity = 150
    initialKeli = Forming_Ak initialCapacity initialKeliProgress -- Start forming Keli
  in record stateAfterEmanation { theOneKeli = initialKeli ; reshimuMap = λ _ → nothing ; ascendedLights = [] ; activeMvMSef = nothing }

-- Hitalkut Step Function
stepHitalkutDetailed : AkudimState → AkudimState
stepHitalkutDetailed currentState =
  let ascended = currentState .AkudimState.ascendedLights in
  case findFirstNotIn ascentOrder ascended of
    nothing → currentState
    just sAscending →
      case lookupMap sAscending (currentState .AkudimState.lightsStatus) of
        LightPresent_Ak originalLS →
          let reshimuLeft     = calculateReshimu originalLS
              newReshimuMap   = updateMap _s==?_ (currentState .AkudimState.reshimuMap) sAscending (just reshimuLeft)
              newLightsStatus = updateMap _s==?_ (currentState .AkudimState.lightsStatus) sAscending (LightAscended_Ak originalLS)
              newAscendedList = sAscending ∷ ascended
              currentKeliState = currentState .AkudimState.theOneKeli
              levelsBelow      = findLevelsBelow sAscending
              processLevelBelow = λ ik sb → maybe ik (λ rl → accumulateKeliSubstance (hakaah (calculateOhrHozer newAscendedList sb) rl) ik) (lookupMapMaybe sb newReshimuMap)
              keliAfterHakaot  = foldl processLevelBelow currentKeliState levelsBelow
              -- Update ztDone flag when Malchut ascends
              newKeliFinal = case keliAfterHakaot of
                                Forming_Ak cap progress → Forming_Ak cap (record progress { ztDone = if sAscending ==? Malchut then true else progress .KeliFormationProgress.ztDone })
                                _                     → keliAfterHakaot
          in record currentState { lightsStatus = newLightsStatus ; theOneKeli = newKeliFinal ; reshimuMap = newReshimuMap ; ascendedLights = newAscendedList }
        _ → currentState

---------------------------------------------------------
-- Phase 3: MvM Stabilization (Final State)
---------------------------------------------------------

open import Data.Maybe.Categorical using (maybe)
open import Data.Bool using (true; false; _&&_)
open import Relation.Nullary using (yes; no)

-- Helper to extract original LightStateAkudim from Ascended status
getOriginalLightState : AkudimLightStatus → Maybe LightStateAkudim
getOriginalLightState (LightAscended_Ak ls) = just ls
getOriginalLightState _ = nothing

-- Placeholder: Light state for 'Dalet'
daletLightState : LightStateAkudim
daletLightState = emptyAkudimLightState

-- Function representing the outcome of the MvM phase
stabilizeAkudimViaMvM : AkudimState → AkudimState
stabilizeAkudimViaMvM currentState with currentState .AkudimState.theOneKeli
... | Forming_Ak cap progress with progress .KeliFormationProgress.ztDone
...   | true =
  let
    getOrig = getOriginalLightState ∘ (currentState .AkudimState.lightsStatus)
    handleMissing = {!!} -- Represents an error state / impossible case
    applyStable = λ ls → LightStable_Ak ls

    -- 1. Define the final, stable, shifted light configuration
    newLightsMap : Sefirah → AkudimLightStatus
    newLightsMap Keter    = maybe handleMissing (λ ls → LightAscended_Ak ls) (getOrig Keter) -- Keter Light stays Ascended
    newLightsMap Chochmah = maybe handleMissing applyStable (getOrig Binah)    -- Binah Light @ Chochmah level
    newLightsMap Binah    = maybe handleMissing applyStable (getOrig Daat)
    newLightsMap Daat     = maybe handleMissing applyStable (getOrig Chesed)
    newLightsMap Chesed   = maybe handleMissing applyStable (getOrig Gevurah)
    newLightsMap Gevurah  = maybe handleMissing applyStable (getOrig Tiferet)
    newLightsMap Tiferet  = maybe handleMissing applyStable (getOrig Netzach)
    newLightsMap Netzach  = maybe handleMissing applyStable (getOrig Hod)
    newLightsMap Hod      = maybe handleMissing applyStable (getOrig Yesod)
    newLightsMap Yesod    = maybe handleMissing applyStable (getOrig Malchut)  -- Malchut Light @ Yesod level
    newLightsMap Malchut  = LightStable_Ak daletLightState                     -- Dalet Light @ Malchut level

    -- 2. Define the final Keli State: Fully finalized, includes internal ZON presence
    --    Assumes MvM process set the khbDone and zonFormed flags in 'progress'.
    --    We use the zonFormed flag from the input 'progress'.
    newKeliState = Finalized_All_Ak cap (progress .KeliFormationProgress.zonFormed) -- Final state

  -- 3. Construct the final Akudim state record
  in record currentState { lightsStatus   = newLightsMap
                        ; theOneKeli     = newKeliState
                        ; ascendedLights = [] -- Reset Hitalkut tracking
                        ; reshimuMap     = λ _ → nothing -- Reshimu resolved
                        ; activeMvMSef   = nothing -- MvM phase ended
                        }
...   | false = currentState
... | _ = currentState

-- Conceptual overall simulation for Akudim dynamics ends by applying this function:
-- stateAfterMvM = stabilizeAkudimViaMvM (runHitalkut (transitionToHitalkut stateAfterEmanation))
-- assuming runHitalkut produces the state Forming_Ak with ztDone = true.

-- עולם נקודים
module Hishtalshelut.State.Olam.Nekudim where

open import Hishtalshelut.Domain.All public
open import Hishtalshelut.Lib.EqDec public
open import Data.Maybe
open import Data.Nat
open import Data.List.Base
open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Agda.Builtin.Nat using (_==_)

open import Hishtalshelut.Domain.Kelim.OlamNekudim public
open import Hishtalshelut.State.LightState public using (emptyAkudimLightState)

-- Defines initial Kelim and Capacities
initialNekudimKelimMap : OlamNekudimState
initialNekudimKelimMap Keter = mkNekudahState Keter (Shalem_nk 1000) emptyAkudimLightState
initialNekudimKelimMap Chochmah = mkNekudahState Chochmah (Shalem_nk 90) emptyAkudimLightState
initialNekudimKelimMap Binah = mkNekudahState Binah (Shalem_nk 80) emptyAkudimLightState
initialNekudimKelimMap Daat = mkNekudahState Daat (Shalem_nk 1) emptyAkudimLightState
initialNekudimKelimMap Chesed = mkNekudahState Chesed (Shalem_nk 15) emptyAkudimLightState
initialNekudimKelimMap Gevurah = mkNekudahState Gevurah (Shalem_nk 15) emptyAkudimLightState
initialNekudimKelimMap Tiferet = mkNekudahState Tiferet (Shalem_nk 15) emptyAkudimLightState
initialNekudimKelimMap Netzach = mkNekudahState Netzach (Shalem_nk 10) emptyAkudimLightState
initialNekudimKelimMap Hod = mkNekudahState Hod (Shalem_nk 10) emptyAkudimLightState
initialNekudimKelimMap Yesod = mkNekudahState Yesod (Shalem_nk 10) emptyAkudimLightState
initialNekudimKelimMap Malchut = mkNekudahState Malchut (Shalem_nk 5) emptyAkudimLightState

initialNekudimState : OlamNekudimState
initialNekudimState = initialNekudimKelimMap -- State before impulse

-- Reception Mode Logic
open import Hishtalshelut.Domain.Rashash.Names.Sefirah as RashashSefirah hiding (getParent; getChildren; getReceptionMode; Keter; Chochmah; Binah; Daat; Chesed; Gevurah; Tiferet; Netzach; Hod; Yesod; Malchut)
open import Hishtalshelut.Domain.Rashash.Names.Sefirah as RashashReceptionMode using (ReceptionMode; Simple)
open import Hishtalshelut.Domain.Sefirah.Sefirah using (Sefirah; Keter; Chochmah; Binah; Daat; Chesed; Gevurah; Tiferet; Netzach; Hod; Yesod; Malchut)

getParent : Sefirah -> Maybe Sefirah
getParent Keter    = nothing
getParent Chochmah = just Keter
getParent Binah    = just Chochmah
getParent Daat     = just Binah
getParent Chesed   = just Daat
getParent Gevurah  = just Chesed
getParent Tiferet  = just Gevurah
getParent Netzach  = just Tiferet
getParent Hod      = just Netzach
getParent Yesod    = just Hod
getParent Malchut  = just Yesod

getChildren : Sefirah -> List Sefirah
getChildren Keter    = Chochmah ∷ []
getChildren Chochmah = Binah ∷ []
getChildren Binah    = Daat ∷ []
getChildren Daat     = Chesed ∷ []
getChildren Chesed   = Gevurah ∷ []
getChildren Gevurah  = Tiferet ∷ []
getChildren Tiferet  = Netzach ∷ []
getChildren Netzach  = Hod ∷ []
getChildren Hod      = Yesod ∷ []
getChildren Yesod    = Malchut ∷ []
getChildren Malchut  = []

getReceptionMode : Sefirah -> Sefirah -> RashashReceptionMode.ReceptionMode
getReceptionMode _ _ = RashashReceptionMode.Simple

-- השוואת LightLevel
open import Hishtalshelut.Domain.Light.SoulLevel public

eqSoulLevel : SoulLevel -> SoulLevel -> Bool
eqSoulLevel Nefesh Nefesh = true
eqSoulLevel Ruach Ruach = true
eqSoulLevel Neshama Neshama = true
eqSoulLevel Chaya Chaya = true
eqSoulLevel Yechida Yechida = true
eqSoulLevel _ _ = false

-- getLevel is now top-level
open import Hishtalshelut.State.LightState public using (LightStateAkudim)

getLevel : LightStateAkudim -> SoulLevel -> LightLevelStatus
getLevel ohr Nefesh   = LightStateAkudim.nefesh ohr
getLevel ohr Ruach    = LightStateAkudim.ruach ohr
getLevel ohr Neshama  = LightStateAkudim.neshama ohr
getLevel ohr Chaya    = LightStateAkudim.chaya ohr
getLevel ohr Yechida  = LightStateAkudim.yechida ohr

-- Add light to all levels (top-level)
addLightToAllLevels : NekudahState -> LightStateAkudim -> SoulLevel -> NekudahState

addLightToAllLevels state ohr slvl =
  mkNekudahState (NekudahState.sefirah state)
                 (NekudahState.keli state)
                 (Hishtalshelut.State.LightState.mkLSA
                    (addIf Nefesh)
                    (addIf Ruach)
                    (addIf Neshama)
                    (addIf Chaya)
                    (addIf Yechida))
  where
    addIf : SoulLevel -> LightLevelStatus
    addIf lvl =
      let orig = getLevel ohr lvl in
      if eqSoulLevel lvl slvl then someLight else orig

-- transmitLight function (Placeholder logic reflecting rules)
transmitLight : NekudahState -> SoulLevel -> RashashReceptionMode.ReceptionMode -> NekudahState
transmitLight state incomingSoulLevel RashashReceptionMode.Simple =
  let ohr0 = NekudahState.ohr state in
      addLightToAllLevels state ohr0 incomingSoulLevel
-- Extend here for more complex modes if needed

-- Wave Calculation Functions
calculateLightWave : SoulLevel -> (Sefirah -> SoulLevel)
calculateLightWave slvl = λ _ → slvl -- Identity placeholder: all Sefirot get the same SoulLevel
determineSefirahOutcome : Sefirah -> NekudahState -> SoulLevel -> NekudahState

determineSefirahOutcome s state soulLevel with getParent s
... | nothing = transmitLight state soulLevel RashashReceptionMode.Simple
... | just p  = transmitLight state soulLevel (getReceptionMode p s)

calculateNekudimWaveResult : OlamNekudimState -> SoulLevel -> OlamNekudimState
calculateNekudimWaveResult initialMap impulse =
  λ s → determineSefirahOutcome s (initialMap s) (calculateLightWave impulse s)

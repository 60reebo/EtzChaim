--------------------------------------------------
-- KavRules (Rules Layer)
--------------------------------------------------
module Hishtalshelut.Rules.Worlds.KavRules where

open import Agda.Builtin.Unit
open import Hishtalshelut.State.Worlds.ReshimuState using (ReshimuState)
open import Hishtalshelut.State.Worlds.ChallalState using (ChallalState ; initialChallalState)
open import Hishtalshelut.State.Worlds.KavState using (KavState ; initialKavState)
open import Hishtalshelut.State.Worlds.IgulimYosherState using (IgulimYosherState ; initialIgulimYosherState)
open import Hishtalshelut.Domain.Worlds.Kav using (Kav)

-- | יצירת חלל ריק מהמצב של רשימו
prepareEmptyChallal : ReshimuState → ChallalState
prepareEmptyChallal rs = initialChallalState rs

-- | התחלת כניסת הקו
startKavEntry : ChallalState → KavState
startKavEntry ch = record { (initialKavState ch) \n entered = true }

-- | הקו עובר דרך מרכז החלל
-- (מעדכן את השדה throughCenter)
drawKavThroughCenter : KavState → KavState
drawKavThroughCenter ks = record { ks \n throughCenter = true }

-- | הקו מחלק את האור לאיגולים ויושר
splitOhrToIgulimAndYosher : KavState → IgulimYosherState
splitOhrToIgulimAndYosher ks = record { (initialIgulimYosherState ks) \n igulimReady = true ; yosherReady = true }

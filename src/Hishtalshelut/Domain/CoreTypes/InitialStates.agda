--------------------------------------------------
-- InitialStates (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.InitialStates where

open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; omega)
open import Hishtalshelut.Domain.CoreTypes.Light using (Light; mkLight)
open import Hishtalshelut.Domain.CoreTypes.Reshimu using (Reshimu; mkReshimu)
open import Hishtalshelut.Domain.Math.Enums using (LightQuality; Primordial_LightQuality)
open import Hishtalshelut.Domain.Worlds.IgulimYosher using (LightCategory; Undifferentiated_LightCategory)
open import Agda.Builtin.String using (String)
open import Data.Nat using (ℕ)

-- | The primordial, infinite light before Tzimtzum.
EinSofLight : Light
EinSofLight = mkLight
  (aleph omega)                  -- power: cardinality aleph_ω
  omega                          -- structure: ordinal ω
  Undifferentiated_LightCategory -- category: unique for primordial light
  Primordial_LightQuality        -- kind: unique for primordial light
  "Ein Sof"                     -- source
  0                              -- timestamp

-- | The Reshimu after Tzimtzum: only potential remains.
PrimordialReshimu : Reshimu
PrimordialReshimu = mkReshimu
  (fin 0)                        -- potentialPower: no actual light
  omega                          -- potentialStructure: memory of original structure
  "Reshimu"

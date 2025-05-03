--------------------------------------------------
-- TzimtzumScenario (Runtime/Scenario Layer)
--------------------------------------------------
module Hishtalshelut.Runtime.Worlds.TzimtzumScenario where

open import Data.List public using (List)
open import Hishtalshelut.Engine.Worlds.TzimtzumEngine public using (simulateTzimtzum; simulateTzimtzumTrace)
open import Hishtalshelut.State.Worlds.TzimtzumState public using (ContractionState)
open import Agda.Builtin.Unit public using (⊤; tt)

-- | תרחיש הרצה: סימולציה מלאה של שלב הצמצום
runScenarioTzimtzum : ContractionState
runScenarioTzimtzum = simulateTzimtzum tt

-- | תרחיש הרצה: רשימת מצבי ביניים בכל שלב הצמצום
runScenarioTzimtzumTrace : List ContractionState
runScenarioTzimtzumTrace = simulateTzimtzumTrace tt

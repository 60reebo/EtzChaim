--------------------------------------------------
-- TzimtzumScenario (Runtime/Scenario Layer)
--------------------------------------------------
module Hishtalshelut.Runtime.Worlds.TzimtzumScenario where

open import Agda.Primitive using (lzero)
open import Data.List using (List)
open import Hishtalshelut.Engine.Worlds.TzimtzumEngine using (simulateDynamicTzimtzum; simulateTzimtzumTrace; contractionTraceText; Language; English; Hebrew)
open import Hishtalshelut.State.Worlds.TzimtzumState lzero using (ContractionState)
open import Agda.Builtin.Unit using (⊤; tt)
open import Agda.Builtin.String using (String)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; fromNatO)

-- | ערך אורדינלי ברירת מחדל לצמצום עבור 10 שכבות
defaultMaxTzimtzumOrdinal : Ordinal lzero
defaultMaxTzimtzumOrdinal = fromNatO 10

-- | תרחיש הרצה: סימולציה מלאה של שלב הצמצום (10 שכבות)
runScenarioTzimtzum : ContractionState
runScenarioTzimtzum = simulateDynamicTzimtzum defaultMaxTzimtzumOrdinal

-- | תרחיש הרצה: רשימת מצבי ביניים בכל שלב הצמצום
runScenarioTzimtzumTrace : List ContractionState
runScenarioTzimtzumTrace = simulateTzimtzumTrace tt

-- | תרחיש טקסטואלי להצגת סימולציית הצמצום בשפה ובערך אורדינלי נתון
runScenarioTzimtzumText : Language → Ordinal lzero → List String
runScenarioTzimtzumText = contractionTraceText

-- | תרחיש טקסטואלי בעברית עם ערך ברירת מחדל
runScenarioTzimtzumTextHebrew : List String
runScenarioTzimtzumTextHebrew = runScenarioTzimtzumText Hebrew defaultMaxTzimtzumOrdinal

-- | תרחיש טקסטואלי באנגלית עם ערך ברירת מחדל
runScenarioTzimtzumTextEnglish : List String
runScenarioTzimtzumTextEnglish = runScenarioTzimtzumText English defaultMaxTzimtzumOrdinal

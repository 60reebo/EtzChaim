{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Types.Scenario where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

import Engine.Types.BasicTypes
import Engine.Types.SimulationState

-- | מעבר/שלב בתרחיש
data ScenarioTransition = ScenarioTransition
  { transitionName :: Text            -- ^ שם המעבר
  , transitionDescription :: Text     -- ^ תיאור המעבר
  , transitionSourceStage :: SimulationStage  -- ^ שלב המקור
  , transitionTargetStage :: SimulationStage  -- ^ שלב היעד
  , transitionFunction :: EngineState -> Either Text EngineState  -- ^ פונקציית המעבר
  }

-- | תרחיש סימולציה מלא
data Scenario = Scenario
  { scenarioInfo :: ScenarioInfo      -- ^ מידע על התרחיש
  , scenarioInitialState :: EngineState  -- ^ מצב התחלתי
  , scenarioTransitions :: [ScenarioTransition]  -- ^ רשימת מעברים אפשריים
  , scenarioFinalState :: Maybe EngineState  -- ^ מצב סופי מצופה (אם יש)
  , scenarioParameters :: SimulationParameters  -- ^ פרמטרים נוספים
  }

-- | תרחיש אין-סוף בסיסי (רק להדגמה)
einSofDemoScenario :: Scenario
einSofDemoScenario = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId = ScenarioId "ein-sof-demo"
      , scenarioName = "אין-סוף דמו"
      , scenarioDescription = "תרחיש בסיסי של אין-סוף לצורך בדיקה"
      , scenarioStages = [EinSofStage]
      }
  , scenarioInitialState = initialEinSofState
  , scenarioTransitions = []  -- אין מעברים בתרחיש זה
  , scenarioFinalState = Nothing  -- אין מצב סופי מוגדר
  , scenarioParameters = SimulationParameters
      { paramMap = Map.fromList [("mode", "basic")]
      }
  }

-- | יצירת פונקציה להמרת שם מעבר למעבר בפועל
-- (יורחב כשנוסיף מעברים אמיתיים)
getTransitionByName :: Text -> Maybe (EngineState -> Either Text EngineState)
getTransitionByName name = case name of
  "צמצום" -> Just tzimtzumTransition
  _ -> Nothing

-- | פונקציית מעבר פשוטה לדוגמה
tzimtzumTransition :: EngineState -> Either Text EngineState
tzimtzumTransition state =
  if currentStage state /= EinSofStage
    then Left "מעבר צמצום אפשרי רק משלב האין-סוף"
    else Right $ state
      { currentStage = TzimtzumStage
      , simulationState = TzimtzumState
          { tzimtzumRadius = 1
          , tzimtzumHasReshimu = True
          , tzimtzumHasKav = False
          , tzimtzumProperties = Map.fromList
              [ ("יש_חלל_פנוי", True)
              , ("יש_רשימו", True)
              ]
          }
      , simulationTime = simulationTime state + 1
      , simulationEvents = "התרחש צמצום ראשוני" : simulationEvents state
      } 
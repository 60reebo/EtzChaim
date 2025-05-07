{-# LANGUAGE OverloadedStrings #-}

module Engine.Templates.NewScenario where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map

import Engine.Types.BasicTypes
import Engine.Types.SimulationState (EngineState, SimulationState(..), SimulationParameters(..), initialEinSofState)
import Engine.Types.Scenario

{- 
  תבנית ליצירת תרחיש חדש
  
  כדי להשתמש בתבנית:
  1. העתק את הקובץ לתיקיית Engine/Scenarios
  2. שנה את שם הקובץ והמודול לשם התרחיש שלך
  3. התאם את הקוד להגדרת התרחיש שלך
  4. הוסף את התרחיש ל-Engine/Scenarios/Library.hs
-}

-- | הגדרת תרחיש חדש
newScenario :: Scenario
newScenario = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId = ScenarioId "new-scenario-id"  -- החלף במזהה ייחודי
      , scenarioName = "שם התרחיש החדש"            -- החלף בשם מתאים
      , scenarioDescription = "תיאור התרחיש החדש"  -- הוסף תיאור מפורט
      , scenarioStages = [EinSofStage, TzimtzumStage]  -- הגדר את השלבים הרלוונטיים
      }
  , scenarioInitialState = initialState
  , scenarioTransitions = 
      [ ScenarioTransition
          { transitionName = "מעבר לדוגמה"
          , transitionDescription = "תיאור המעבר"
          , transitionSourceStage = EinSofStage
          , transitionTargetStage = TzimtzumStage
          , transitionType = TzimtzumTransition
          }
      ]
  , scenarioFinalState = Nothing  -- אופציונלי: הגדר מצב סופי מצופה
  , scenarioParameters = SimulationParameters
      { paramMap = Map.fromList
          [ ("param1", "value1")
          , ("param2", "value2")
          ]
      }
  }

-- | מצב התחלתי לתרחיש
initialState :: EngineState
initialState = initialEinSofState  -- שימוש במקור אחד של אמת לאור אין-סוף

-- | פונקציית מעבר לדוגמה
sampleTransition :: EngineState -> Either Text EngineState
sampleTransition = tzimtzumTransitionFunc
-- Using the core Tzimtzum transition function for the sample transition 
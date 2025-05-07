{-# LANGUAGE OverloadedStrings #-}

module Engine.Scenarios.Library where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List (find)

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario

-- | ספריית כל התרחישים במערכת
allScenarios :: [Scenario]
allScenarios = 
  [ einSofDemoScenario
  -- בעתיד יתווספו תרחישים נוספים
  ]

-- | חיפוש תרחיש לפי מזהה
findScenario :: ScenarioId -> Maybe Scenario
findScenario id = find ((== id) . scenarioId . scenarioInfo) allScenarios

-- | רשימת כל התרחישים הזמינים (למידע בלבד)
listScenarios :: [ScenarioInfo]
listScenarios = map scenarioInfo allScenarios

-- | הסבה של קוד אין-סוף קיים לתרחיש מובנה
-- בהמשך, זה יקרא לקוד האמיתי ב-EinSofEngine
convertEinSofToScenario :: ScenarioId -> Text -> Scenario
convertEinSofToScenario sid name = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId = sid
      , scenarioName = name
      , scenarioDescription = "תרחיש אין-סוף מומר מהקוד הקיים"
      , scenarioStages = [EinSofStage]
      }
  , scenarioInitialState = initialEinSofState  -- לעתיד: לקרוא מהקוד המקורי
  , scenarioTransitions = []
  , scenarioFinalState = Nothing
  , scenarioParameters = SimulationParameters
      { paramMap = Map.empty
      }
  } 
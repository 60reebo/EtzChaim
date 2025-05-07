{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Types.Scenario where

import Data.Text (Text)
import qualified Data.Map as Map
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Simulation.Kav (kavTransitionFunc)

-- | סוג המעבר
data TransitionType = 
    TzimtzumTransition  -- ^ מעבר צמצום
  | KavTransition       -- ^ מעבר קו
  | SefirotTransition   -- ^ מעבר ספירות
  | CustomTransition Text  -- ^ מעבר מותאם אישית
  deriving (Show, Eq, Generic)

instance ToJSON TransitionType
instance FromJSON TransitionType

-- | מעבר/שלב בתרחיש (ללא פונקציה כדי לאפשר Show/Eq)
data ScenarioTransition = ScenarioTransition
  { transitionName :: Text            -- ^ שם המעבר
  , transitionDescription :: Text     -- ^ תיאור המעבר
  , transitionSourceStage :: SimulationStage  -- ^ שלב המקור
  , transitionTargetStage :: SimulationStage  -- ^ שלב היעד
  , transitionType :: TransitionType  -- ^ סוג המעבר (במקום פונקציה)
  } deriving (Show, Eq, Generic)

instance ToJSON ScenarioTransition
instance FromJSON ScenarioTransition

-- | תרחיש סימולציה מלא
data Scenario = Scenario
  { scenarioInfo :: ScenarioInfo      -- ^ מידע על התרחיש
  , scenarioInitialState :: EngineState  -- ^ מצב התחלתי
  , scenarioTransitions :: [ScenarioTransition]  -- ^ רשימת מעברים אפשריים (אולי ננהל אחרת?)
  , scenarioFinalState :: Maybe EngineState  -- ^ מצב סופי מצופה (אם יש)
  , scenarioParameters :: SimulationParameters  -- ^ פרמטרים נוספים
  , executeScenario :: EngineState -> IO (Either Text EngineState) -- ^ הפונקציה שמבצעת את פעולת התרחיש
  }
-- Cannot derive Show, Eq, Generic automatically with a function type.
-- We'll need manual instances or avoid comparisons/serialization of the whole Scenario.

-- | תרחיש אין-סוף בסיסי (רק להדגמה) - הגדרה ישנה, תוסר מכאן ותוגדר מחדש בספרייה
-- {- einSofDemoScenario :: Scenario
-- einSofDemoScenario = Scenario
--  { ... }
-- -}

-- | יצירת פונקציה להמרת סוג מעבר לפונקציית מעבר
-- (יורחב כשנוסיף מעברים אמיתיים)
getTransitionFunction :: TransitionType -> (EngineState -> Either Text EngineState)
getTransitionFunction transType = case transType of
  TzimtzumTransition -> tzimtzumTransitionFunc
  KavTransition      -> kavTransitionFunc
  _ -> \state -> Right state  -- פונקציית זהות כברירת מחדל

-- | פונקציית מעבר צמצום (הועבר מ-BasicRunner)
tzimtzumTransitionFunc :: EngineState -> Either Text EngineState
tzimtzumTransitionFunc state =
  if currentStage state /= EinSofStage
    then Left "מעבר צמצום אפשרי רק משלב האין-סוף"
    else case simulationState state of
      EinSofState { einSofLight = einL } ->
        let newSimState = TzimtzumState
              { tzimtzumRadius      = 1
              , tzimtzumHasReshimu  = True
              , tzimtzumHasKav      = False
              , tzimtzumEinSofLight = einL
              , tzimtzumKavLight    = Nothing
              , tzimtzumProperties  = Map.fromList [("יש_חלל_פנוי", True), ("יש_רשימו", True)]
              }
            newState = state
              { currentStage     = TzimtzumStage
              , simulationState  = newSimState
              , simulationTime   = simulationTime state + 1
              , simulationEvents = "התרחש צמצום ראשוני" : simulationEvents state
              }
        in Right newState
      _ -> Left "מצב לא תקין למעבר צמצום" 
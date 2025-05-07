{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Types.SimulationState where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

import Engine.Types.BasicTypes

-- | מצבי סימולציה ספציפיים לכל שלב
data SimulationState =
    -- שלב האין-סוף
    EinSofState
      { einSofLight :: Text          -- ^ אור האין-סוף (יוחלף בטיפוס מדויק בהמשך)
      , einSofProperties :: Map Text Bool  -- ^ מאפייני אין-סוף
      , einSofDescription :: Text    -- ^ תיאור מצב האין-סוף
      }
    -- שלב הצמצום
  | TzimtzumState
      { tzimtzumRadius :: Int        -- ^ רדיוס החלל הפנוי
      , tzimtzumHasReshimu :: Bool   -- ^ האם קיים רשימו
      , tzimtzumHasKav :: Bool       -- ^ האם קיים קו
      , tzimtzumProperties :: Map Text Bool -- ^ מאפייני הצמצום
      }
    -- שלב הספירות
  | SefirotState
      { sefirotEntities :: Map EntityId Text  -- ^ ספירות (יוחלף בטיפוס מדויק)
      , sefirotConnections :: [(EntityId, EntityId)]  -- ^ קשרים בין ספירות
      }
    -- שלב העולמות
  | WorldsState
      { worldEntities :: Map Text Text  -- ^ עולמות (יוחלף בטיפוס מדויק)
      }
    -- שלב גנרי לסימולציות אחרות
  | GenericState
      { stateData :: Map Text Text  -- ^ נתונים גנריים
      }
  deriving (Show, Eq, Generic)

instance ToJSON SimulationState
instance FromJSON SimulationState

-- | מצב המנוע - מבנה המכיל את כל נתוני הסימולציה
data EngineState = EngineState
  { currentStage :: SimulationStage   -- ^ השלב הנוכחי
  , simulationState :: SimulationState  -- ^ מצב הסימולציה הספציפי לשלב
  , simulationTime :: Integer         -- ^ צעד זמן הסימולציה
  , simulationEvents :: [Text]        -- ^ אירועים שקרו בסימולציה
  } deriving (Show, Eq, Generic)

instance ToJSON EngineState
instance FromJSON EngineState

-- | חבילת פרמטרים לסימולציה
data SimulationParameters = SimulationParameters
  { paramMap :: Map Text Text  -- ^ מפת פרמטרים בסיסית
  } deriving (Show, Eq, Generic)

instance ToJSON SimulationParameters
instance FromJSON SimulationParameters

-- | יצירת מצב אין-סוף התחלתי פשוט
initialEinSofState :: EngineState
initialEinSofState = EngineState
  { currentStage = EinSofStage
  , simulationState = EinSofState
      { einSofLight = "אור אין-סוף ראשוני"
      , einSofProperties = Map.fromList
          [ ("אחיד", True)
          , ("אינסופי", True)
          , ("חסר גבול", True)
          , ("בלתי ניתן להבחנה", True)
          ]
      , einSofDescription = "מצב התחלתי של אור אין-סוף ממלא את הכל"
      }
  , simulationTime = 0
  , simulationEvents = ["אתחול אין-סוף"]
  } 
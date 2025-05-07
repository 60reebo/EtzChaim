{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Types.SimulationState where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

import Engine.Types.BasicTypes
import Engine.Types.LightTypes (Light(..), Cardinal(..), Ordinal(..), LightCategory(..), LightKind(..))
import Data.List (iterate)
import Engine.Types.CoreTypes (HierarchicalStructure)

-- | מצבי סימולציה ספציפיים לכל שלב
data SimulationState =
    -- שלב האין-סוף
    EinSofState
      { einSofLight :: Light         -- ^ אור האין-סוף בפועל (מטיפוס Light)
      , einSofProperties :: Map Text Bool  -- ^ מאפייני אין-סוף
      , einSofDescription :: Text    -- ^ תיאור מצב האין-סוף
      }
    -- שלב הצמצום
  | TzimtzumState
      { tzimtzumRadius :: Int        -- ^ רדיוס החלל הפנוי
      , tzimtzumHasReshimu :: Bool   -- ^ האם קיים רשימו
      , tzimtzumHasKav :: Bool       -- ^ האם הקו הומשך כבר
      , tzimtzumEinSofLight :: Light -- ^ האור שהגיע מהאין-סוף
      , tzimtzumKavLight :: Maybe Light -- ^ אור ראשוני מונחת בקו
      , tzimtzumProperties :: Map Text Bool -- ^ מאפייני הצמצום
      }
    -- שלב הספירות
  | SefirotState
      { sefirotEntities :: Map EntityId Text  -- ^ ספירות (יוחלף בטיפוס מדויק)
      , sefirotConnections :: [(EntityId, EntityId)]  -- ^ קשרים בין ספירות
      }
    -- שלב העולמות
  | WorldsState
      { hierarchicalStructure :: HierarchicalStructure -- ^ מפה של כל יחידות הספירה שנבנו
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
  , worldEntities :: HierarchicalStructure -- ^ מפה של כל יחידות הספירה שנבנו
  , activeMakifim :: [Light]         -- ^ מקיפים פעילים ליחידות
  } deriving (Show, Eq, Generic)

instance ToJSON EngineState
instance FromJSON EngineState

-- | חבילת פרמטרים לסימולציה
data SimulationParameters = SimulationParameters
  { paramMap :: Map Text Text  -- ^ מפת פרמטרים בסיסית
  } deriving (Show, Eq, Generic)

instance ToJSON SimulationParameters
instance FromJSON SimulationParameters

-- | אור ראשון מתוך אין-סוף (ברירת מחדל) לשלב הראשון
defaultInfiniteLight :: Light
defaultInfiniteLight = 
  let omega = Limit $ iterate Succ Zero
  in Light
      { power     = Aleph 100
      , structure = omega
      , category  = Yechida
      , kind      = Pnimi
      , source    = "EinSof"
      , timestamp = 0
      }

-- | יצירת מצב אין-סוף התחלתי
initialEinSofState :: EngineState
initialEinSofState = EngineState
  { currentStage = EinSofStage
  , simulationState = EinSofState
      { einSofLight = defaultInfiniteLight
      , einSofProperties = Map.fromList
          [ ("אחיד", True)
          , ("אינסופי", True)
          , ("חסר גבול", True)
          , ("בלתי ניתן להבחנה", True)
          ]
      , einSofDescription = "מצב התחלתי של אור אין-סוף (מוטבע)"
      }
  , simulationTime = 0
  , simulationEvents = ["אתחול אין-סוף"]
  , worldEntities = Map.empty
  , activeMakifim = []
  } 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Types.BasicTypes where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Time (UTCTime)
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

-- | מזהה ייחודי של סימולציה
newtype SimulationId = SimulationId Text
  deriving (Show, Eq, Ord, Generic)

instance ToJSON SimulationId
instance FromJSON SimulationId

-- | מזהה ייחודי של תרחיש
newtype ScenarioId = ScenarioId Text
  deriving (Show, Eq, Ord, Generic)

instance ToJSON ScenarioId
instance FromJSON ScenarioId

-- | מזהה ייחודי של ישות
newtype EntityId = EntityId Text
  deriving (Show, Eq, Ord, Generic)

instance ToJSON EntityId
instance FromJSON EntityId

-- | שלבים אפשריים בסימולציה
data SimulationStage = 
    EinSofStage         -- ^ שלב האין-סוף
  | TzimtzumStage       -- ^ שלב הצמצום
  | SefirotStage        -- ^ שלב הספירות
  | WorldsStage         -- ^ שלב העולמות
  | AdamKadmonStage     -- ^ שלב אדם קדמון
  | PartzufimStage      -- ^ שלב הפרצופים
  | ShviratHakelimStage -- ^ שלב שבירת הכלים
  | TikkunStage         -- ^ שלב התיקון
  deriving (Show, Eq, Ord, Enum, Bounded, Generic)

instance ToJSON SimulationStage
instance FromJSON SimulationStage

-- | סטטוס הריצה של סימולציה
data SimulationStatus = 
    Initializing   -- ^ מאתחל
  | Running        -- ^ רץ כעת
  | Paused         -- ^ מושהה
  | Completed      -- ^ הושלם
  | Failed Text    -- ^ נכשל, עם הודעת שגיאה
  deriving (Show, Eq, Generic)

instance ToJSON SimulationStatus
instance FromJSON SimulationStatus

-- | מידע על תרחיש
data ScenarioInfo = ScenarioInfo
  { scenarioId :: ScenarioId          -- ^ מזהה התרחיש
  , scenarioName :: Text              -- ^ שם התרחיש
  , scenarioDescription :: Text       -- ^ תיאור התרחיש
  , scenarioStages :: [SimulationStage] -- ^ שלבים בתרחיש
  } deriving (Show, Eq, Generic)

instance ToJSON ScenarioInfo
instance FromJSON ScenarioInfo

-- | מידע על תרחיש פעיל
data ActiveScenario = ActiveScenario
  { activeScenarioInfo :: ScenarioInfo    -- ^ מידע על התרחיש
  , activeScenarioStatus :: SimulationStatus  -- ^ סטטוס נוכחי
  , activeScenarioCurrentStage :: SimulationStage  -- ^ שלב נוכחי
  , activeScenarioStartTime :: UTCTime     -- ^ זמן התחלה
  , activeScenarioLastUpdate :: UTCTime   -- ^ זמן עדכון אחרון
  } deriving (Show, Eq, Generic)

instance ToJSON ActiveScenario
instance FromJSON ActiveScenario 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Runner.RunnerState where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Time (UTCTime, getCurrentTime)
import GHC.Generics (Generic)
import Control.Concurrent.STM (TVar, atomically, newTVarIO, readTVar, modifyTVar)
import qualified Data.UUID.V4 as UUID
import Data.String (fromString)

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario

-- | מצב סימולציה אחת בריצה
data RuntimeSimulation = RuntimeSimulation
  { runtimeId :: SimulationId      -- ^ מזהה הריצה
  , runtimeScenario :: Scenario    -- ^ התרחיש שרץ
  , runtimeEngine :: EngineState   -- ^ מצב המנוע הנוכחי
  , runtimeStatus :: SimulationStatus  -- ^ סטטוס ריצה
  , runtimeStartTime :: UTCTime    -- ^ זמן התחלה
  , runtimeLastUpdate :: UTCTime   -- ^ זמן עדכון אחרון
  , runtimeEvents :: [Text]        -- ^ אירועים שקרו בריצה
  } deriving (Generic)

instance Show RuntimeSimulation where
  show rt = "RuntimeSimulation { id = " ++ show (runtimeId rt) ++ ", status = " ++ show (runtimeStatus rt) ++ " }"

instance Eq RuntimeSimulation where
  rt1 == rt2 = runtimeId rt1 == runtimeId rt2

-- | מנהל הריצה - שומר את כל הסימולציות הפעילות
newtype SimulationManager = SimulationManager
  { activeSimulations :: TVar (Map SimulationId RuntimeSimulation)
  }

-- | יצירת מנהל סימולציות ריק
createSimulationManager :: IO SimulationManager
createSimulationManager = do
  tvar <- newTVarIO Map.empty
  return $ SimulationManager tvar

-- | יצירת מזהה סימולציה חדש
generateSimulationId :: IO SimulationId
generateSimulationId = do
  uuid <- UUID.nextRandom
  return $ SimulationId (fromString $ show uuid)

-- | התחלת סימולציה חדשה
startSimulation :: SimulationManager -> Scenario -> IO (Either Text SimulationId)
startSimulation manager scenario = do
  now <- getCurrentTime
  simId <- generateSimulationId
  
  let initialEngineState = scenarioInitialState scenario
  let runtimeSim = RuntimeSimulation
        { runtimeId = simId
        , runtimeScenario = scenario
        , runtimeEngine = initialEngineState
        , runtimeStatus = Running
        , runtimeStartTime = now
        , runtimeLastUpdate = now
        , runtimeEvents = ["סימולציה החלה"]
        }
  
  atomically $ modifyTVar (activeSimulations manager) $ 
    Map.insert simId runtimeSim
  
  return $ Right simId

-- | השהיית סימולציה פעילה
pauseSimulation :: SimulationManager -> SimulationId -> IO (Either Text ())
pauseSimulation manager simId = do
  sims <- atomically $ readTVar (activeSimulations manager)
  case Map.lookup simId sims of
    Nothing -> return $ Left "סימולציה עם המזהה הזה לא נמצאה"
    Just sim -> do
      now <- getCurrentTime
      let updatedSim = sim
            { runtimeStatus = Paused
            , runtimeLastUpdate = now
            , runtimeEvents = "סימולציה הושהתה" : runtimeEvents sim
            }
      atomically $ modifyTVar (activeSimulations manager) $
        Map.insert simId updatedSim
      return $ Right ()

-- | חידוש סימולציה מושהית
resumeSimulation :: SimulationManager -> SimulationId -> IO (Either Text ())
resumeSimulation manager simId = do
  sims <- atomically $ readTVar (activeSimulations manager)
  case Map.lookup simId sims of
    Nothing -> return $ Left "סימולציה עם המזהה הזה לא נמצאה"
    Just sim -> do
      now <- getCurrentTime
      let updatedSim = sim
            { runtimeStatus = Running
            , runtimeLastUpdate = now
            , runtimeEvents = "סימולציה חודשה" : runtimeEvents sim
            }
      atomically $ modifyTVar (activeSimulations manager) $
        Map.insert simId updatedSim
      return $ Right ()

-- | קבלת מידע על סימולציה מסוימת
getSimulation :: SimulationManager -> SimulationId -> IO (Maybe RuntimeSimulation)
getSimulation manager simId = do
  sims <- atomically $ readTVar (activeSimulations manager)
  return $ Map.lookup simId sims

-- | רשימת כל הסימולציות הפעילות
listSimulations :: SimulationManager -> IO [SimulationId]
listSimulations manager = do
  sims <- atomically $ readTVar (activeSimulations manager)
  return $ Map.keys sims

-- | מצב הרצה הכללי, מחזיק את כל התרחישים הזמינים ואת הסימולציות הפעילות
data RunnerState = RunnerState
    { availableScenarios :: Map String Scenario          -- ^ מפה של כל התרחישים הזמינים, מפתח הוא המזהה
    , runningSimulations :: Map String RuntimeSimulation -- ^ מפה של סימולציות רצות, מפתח הוא מזהה ייחודי לריצה
    } deriving (Generic)

-- Add basic manual instances for RunnerState
instance Show RunnerState where
  show rs = "RunnerState { availableScenarios = " ++ show (Map.keys $ availableScenarios rs) ++ ", runningSimulations = " ++ show (Map.keys $ runningSimulations rs) ++ " }"

instance Eq RunnerState where
  -- Basic equality check based on number of scenarios and running simulations
  rs1 == rs2 = Map.size (availableScenarios rs1) == Map.size (availableScenarios rs2) && Map.size (runningSimulations rs1) == Map.size (runningSimulations rs2)

-- | יוצר מצב רצה התחלתי עם רשימת תרחישים
initialRunnerState :: [Scenario] -> RunnerState
initialRunnerState scenariosList =
    RunnerState
        { availableScenarios = Map.fromList [(show (scenarioId (scenarioInfo s)), s) | s <- scenariosList]
        , runningSimulations = Map.empty
        } 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Engine.Runner.RunnerState where

import Data.Text (Text)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Time (UTCTime, getCurrentTime)
import GHC.Generics (Generic)
import Control.Concurrent.STM (TVar, atomically, newTVarIO, readTVar, writeTVar, modifyTVar)
import Control.Monad.IO.Class (liftIO)
import Data.Unique (newUnique, hashUnique)
import qualified Data.UUID as UUID
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
  } deriving (Show, Eq, Generic)

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
  
  let runtimeSim = RuntimeSimulation
        { runtimeId = simId
        , runtimeScenario = scenario
        , runtimeEngine = scenarioInitialState scenario
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
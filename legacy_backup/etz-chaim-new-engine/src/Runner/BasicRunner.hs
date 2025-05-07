{-# LANGUAGE OverloadedStrings #-}

module Engine.Runner.BasicRunner where

import Data.Text (Text, pack)
import qualified Data.Text.IO as TIO
import Data.Map (Map)
import qualified Data.Map as Map
import Control.Concurrent (threadDelay)
import Control.Monad (forM_, when)

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario
import Engine.Scenarios.Library (findScenario)
import Engine.Runner.RunnerState

-- | הרצת צעד בודד של סימולציה
stepSimulation :: EngineState -> Either Text EngineState
stepSimulation state = 
  -- לעתיד: כאן תהיה לוגיקה יותר מורכבת בהתאם לשלב הנוכחי
  case currentStage state of
    EinSofStage -> Right state  -- אין-סוף לא משתנה
    TzimtzumStage -> advanceTzimtzum state
    _ -> Right state  -- לעתיד: טיפול בשאר השלבים

-- | התקדמות בשלב הצמצום
advanceTzimtzum :: EngineState -> Either Text EngineState
advanceTzimtzum state = 
  case simulationState state of
    TzimtzumState r hasR hasK props -> 
      if r < 10  -- התקדמות עד רדיוס 10
        then Right $ state
          { simulationState = TzimtzumState (r + 1) hasR hasK props
          , simulationTime = simulationTime state + 1
          , simulationEvents = ("רדיוס החלל התרחב ל-" <> pack (show (r + 1))) : simulationEvents state
          }
        else Right $ state  -- הגענו למקסימום
    _ -> Left "מצב לא תקין לצמצום"

-- | הפעלת הסימולציה עד הסוף
runSimulation :: Scenario -> [EngineState]
runSimulation scenario = 
  let initialState = scenarioInitialState scenario
      
      runUntilEnd states =
        let currentState = head states
            nextStateE = stepSimulation currentState
        in case nextStateE of
             Left _ -> states  -- סיום בשגיאה
             Right nextState 
               | isSimulationComplete nextState -> nextState : states
               | otherwise -> runUntilEnd (nextState : states)
      
  in reverse $ runUntilEnd [initialState]
  
-- | האם הסימולציה הסתיימה
isSimulationComplete :: EngineState -> Bool
isSimulationComplete state = 
  -- כרגע נחשיב שסימולציה מסתיימת אחרי 10 שלבים
  -- (לעתיד: לוגיקה יותר מתוחכמת בהתאם לשלב)
  simulationTime state >= 10

-- | הפעלת תרחיש והצגת פלט במסוף
runWithConsoleOutput :: ScenarioId -> IO ()
runWithConsoleOutput scenarioId = do
  case findScenario scenarioId of
    Nothing -> TIO.putStrLn $ "תרחיש לא נמצא: " <> pack (show scenarioId)
    Just scenario -> do
      let states = runSimulation scenario
      forM_ states $ \state ->
        TIO.putStrLn $ formatState state

-- | הפיכת מצב לטקסט מפורמט
formatState :: EngineState -> Text
formatState state =
  "==== מצב סימולציה: שלב " <> pack (show $ currentStage state) <>
  ", זמן " <> pack (show $ simulationTime state) <> " ====\n" <>
  formatStateDetails (simulationState state)

-- | פירוט מצב סימולציה לפי הטיפוס
formatStateDetails :: SimulationState -> Text
formatStateDetails (EinSofState light props desc) =
  "אין-סוף: " <> desc <> "\n" <>
  "אור: " <> light <> "\n" <>
  "תכונות: " <> pack (show props)
formatStateDetails (TzimtzumState radius hasReshimu hasKav props) =
  "צמצום: רדיוס=" <> pack (show radius) <> "\n" <>
  "רשימו: " <> pack (show hasReshimu) <> "\n" <>
  "קו: " <> pack (show hasKav) <> "\n" <>
  "תכונות: " <> pack (show props)
formatStateDetails _ = "מצב לא מוכר"

-- | הרצת סימולציה עם הדפסה דינמית (בזמן אמת)
runWithRealtimeOutput :: ScenarioId -> IO ()
runWithRealtimeOutput scenarioId = do
  case findScenario scenarioId of
    Nothing -> TIO.putStrLn $ "תרחיש לא נמצא: " <> pack (show scenarioId)
    Just scenario -> do
      let initialState = scenarioInitialState scenario
      TIO.putStrLn "=== התחלת סימולציה ==="
      TIO.putStrLn $ formatState initialState
      
      let runStep currState = do
            threadDelay 1000000  -- השהיה של שנייה
            case stepSimulation currState of
              Left err -> TIO.putStrLn $ "שגיאה: " <> err
              Right nextState -> do
                TIO.putStrLn $ formatState nextState
                when (not $ isSimulationComplete nextState) $
                  runStep nextState
                
      runStep initialState
      TIO.putStrLn "=== סימולציה הסתיימה ===" 
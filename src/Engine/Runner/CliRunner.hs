{-# LANGUAGE OverloadedStrings #-}

module Engine.Runner.CliRunner where

import Data.Text (pack)
import qualified Data.Text.IO as TIO
import System.Environment (getArgs)
import Control.Monad (forM_)
import Data.List (intercalate)
import Data.Aeson (encode)
import qualified Data.ByteString.Lazy.Char8 as BL8

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario
import Engine.Scenarios.Library (findScenario, listScenarios)
import Engine.Runner.BasicRunner (runWithRealtimeOutput, formatStateIO)

-- | CLI - פונקציית הכניסה הראשית
runCli :: IO ()
runCli = do
  args <- getArgs
  case args of
    ["list"] -> do
      TIO.putStrLn "תרחישים זמינים:"
      forM_ listScenarios $ \info ->
        TIO.putStrLn $ "- " <> scenarioName info <> " (" <> pack (show $ scenarioId info) <> ")"
        
    ["run", scenId] -> do
      -- Default to real-time streaming output
      let targetScenarioId = ScenarioId $ pack scenId
      runWithRealtimeOutput targetScenarioId
      
    ["run-rt", scenId] -> do
      TIO.putStrLn $ "מריץ תרחיש בזמן אמת: " <> pack scenId
      let targetScenarioId = ScenarioId $ pack scenId
      runWithRealtimeOutput targetScenarioId
      
    ["info", scenId] -> do
      case findScenario (ScenarioId $ pack scenId) of
        Nothing -> TIO.putStrLn "תרחיש לא נמצא"
        Just scen -> do
          let info = scenarioInfo scen
          TIO.putStrLn $ "שם: " <> scenarioName info
          TIO.putStrLn $ "תיאור: " <> scenarioDescription info
          TIO.putStrLn $ "שלבים: " <> pack (intercalate ", " (map show $ scenarioStages info))
    
    -- New command: sequence
    ("sequence" : scenarioIds) | not (null scenarioIds) -> 
        executeSequence (map (ScenarioId . pack) scenarioIds)
        
    ["help"] -> showHelp
    
    ["run-json", scenId] -> do
      let targetScenarioId = ScenarioId $ pack scenId
      case findScenario targetScenarioId of
        Nothing -> TIO.putStrLn "תרחיש לא נמצא"
        Just scenario -> do
          result <- executeScenario scenario (scenarioInitialState scenario)
          case result of
            Left err -> TIO.putStrLn $ "*** שגיאה: " <> err
            Right finalState ->
              -- Output the final EngineState as JSON
              BL8.putStrLn (encode finalState)
    
    _ -> do
      TIO.putStrLn "פקודה לא מוכרת. הרץ 'help' לקבלת עזרה."
      showHelp

-- | New function to execute a sequence of scenarios
executeSequence :: [ScenarioId] -> IO ()
executeSequence ids = do
    TIO.putStrLn $ "מתחיל רצף תרחישים: " <> pack (show ids)
    -- Find all scenarios first
    let maybeScenarios = map findScenario ids
    -- Check if all scenarios were found
    case sequence maybeScenarios of -- sequence converts [Maybe a] to Maybe [a]
        Nothing -> TIO.putStrLn "שגיאה: אחד או יותר מהתרחישים ברצף לא נמצאו."
        Just scenarios -> do
            TIO.putStrLn "כל התרחישים נמצאו. מתחיל ביצוע..."
            -- Get initial state from the *first* scenario in the sequence
            let initialState = scenarioInitialState (head scenarios)
            
            -- Define the loop function
            let runLoop :: EngineState -> [Scenario] -> IO ()
                runLoop currentState [] = do
                    TIO.putStrLn "=== רצף התרחישים הושלם ==="
                    TIO.putStrLn "מצב סופי:"
                    finalFormattedState <- formatStateIO currentState
                    TIO.putStrLn finalFormattedState

                runLoop currentState (currentScenario : remainingScenarios) = do
                    TIO.putStrLn $ "--- מבצע תרחיש: " <> scenarioName (scenarioInfo currentScenario) <> " ---"
                    -- Execute the current scenario's specific action
                    result <- executeScenario currentScenario currentState
                    case result of
                        Left err -> do
                            TIO.putStrLn $ "*** שגיאה בתרחיש '" <> scenarioName (scenarioInfo currentScenario) <> "': " <> err
                            TIO.putStrLn "עוצר את הרצף."
                        Right nextState -> do
                            TIO.putStrLn "המצב לאחר התרחיש:"
                            formattedState <- formatStateIO nextState
                            TIO.putStrLn formattedState
                            -- Continue the loop with the next state and remaining scenarios
                            runLoop nextState remainingScenarios
            
            -- Start the loop
            TIO.putStrLn "מצב התחלתי (מהתרחיש הראשון):"
            initialFormattedState <- formatStateIO initialState
            TIO.putStrLn initialFormattedState
            runLoop initialState scenarios

-- | הצגת עזרה
showHelp :: IO ()
showHelp = do
  TIO.putStrLn "=== מנהל סימולציות עץ חיים ==="
  TIO.putStrLn "שימוש:"
  TIO.putStrLn "  list              - הצג רשימת תרחישים זמינים"
  TIO.putStrLn "  run SCENARIO_ID   - הרץ תרחיש (פלט מלא בסיום, לולאה גנרית)"
  TIO.putStrLn "  run-rt SCENARIO_ID - הרץ תרחיש בזמן אמת (לולאה גנרית)"
  TIO.putStrLn "  sequence ID1 ID2 ... - הרץ רצף תרחישים (כל אחד פעם אחת)"
  TIO.putStrLn "  info SCENARIO_ID  - הצג מידע על תרחיש"
  TIO.putStrLn "  help              - הצג עזרה זו" 
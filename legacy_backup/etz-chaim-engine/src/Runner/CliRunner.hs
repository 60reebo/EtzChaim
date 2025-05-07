{-# LANGUAGE OverloadedStrings #-}

module Engine.Runner.CliRunner where

import Data.Text (Text, pack, unpack)
import qualified Data.Text.IO as TIO
import System.Environment (getArgs)
import Control.Monad (forM_)
import Data.List (intercalate)

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario
import Engine.Scenarios.Library (findScenario, listScenarios)
import Engine.Runner.BasicRunner (runWithConsoleOutput, runWithRealtimeOutput)
import Engine.Runner.RunnerState

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
      TIO.putStrLn $ "מריץ תרחיש: " <> pack scenId
      runWithConsoleOutput (ScenarioId $ pack scenId)
      
    ["run-rt", scenId] -> do
      TIO.putStrLn $ "מריץ תרחיש בזמן אמת: " <> pack scenId
      runWithRealtimeOutput (ScenarioId $ pack scenId)
      
    ["info", scenId] -> do
      case findScenario (ScenarioId $ pack scenId) of
        Nothing -> TIO.putStrLn "תרחיש לא נמצא"
        Just scen -> do
          let info = scenarioInfo scen
          TIO.putStrLn $ "שם: " <> scenarioName info
          TIO.putStrLn $ "תיאור: " <> scenarioDescription info
          TIO.putStrLn $ "שלבים: " <> pack (intercalate ", " (map show $ scenarioStages info))
    
    ["help"] -> showHelp
    
    _ -> do
      TIO.putStrLn "פקודה לא מוכרת. הרץ 'help' לקבלת עזרה."
      showHelp

-- | הצגת עזרה
showHelp :: IO ()
showHelp = do
  TIO.putStrLn "=== מנהל סימולציות עץ חיים ==="
  TIO.putStrLn "שימוש:"
  TIO.putStrLn "  list              - הצג רשימת תרחישים זמינים"
  TIO.putStrLn "  run SCENARIO_ID   - הרץ תרחיש (פלט מלא בסיום)"
  TIO.putStrLn "  run-rt SCENARIO_ID - הרץ תרחיש בזמן אמת"
  TIO.putStrLn "  info SCENARIO_ID  - הצג מידע על תרחיש"
  TIO.putStrLn "  help              - הצג עזרה זו" 
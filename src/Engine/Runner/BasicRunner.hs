{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Engine.Runner.BasicRunner where

import Data.Text (Text, pack)
import qualified Data.Text.IO as TIO
import Control.Concurrent (threadDelay)
import Control.Monad (forM_)
import Data.Maybe (listToMaybe)
import Debug.Trace (trace)
import Foreign.C.String (peekCString)
import qualified Data.Map as Map

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario
import Engine.Scenarios.Library (findScenario)
import Engine.FFI.AgdaEinSof (getInitialTraceTextHaskell)
import Engine.Simulation.Core (stepSimulation)
import Engine.Simulation.Kav (describeLight)
import Engine.Types.CoreTypes (HierarchicalStructure)

-- | Helper: get Ein Sof trace from Haskell stub
getEinSofTraceFromAgda :: IO Text
getEinSofTraceFromAgda = do
  cStringResult <- getInitialTraceTextHaskell
  haskellString <- peekCString cStringResult
  return $ pack haskellString

-- | הפיכת מצב לטקסט מפורמט
formatState :: EngineState -> Text
formatState state =
  "==== מצב סימולציה: שלב " <> pack (show $ currentStage state) <>
  ", זמן " <> pack (show $ simulationTime state) <> " ====\n" <>
  formatStateDetails (simulationState state)

-- | פירוט מצב סימולציה לפי הטיפוס
formatStateDetails :: SimulationState -> Text
formatStateDetails (EinSofState _ _ _) =
  "*** Ein Sof state (see realtime logs for details) ***"
formatStateDetails (TzimtzumState radius hasReshimu hasKav _ _ props) =
  let base =
        "צמצום: רדיוס=" <> pack (show radius) <> "\n" <>
        "רשימו: " <> pack (show hasReshimu) <> "\n" <>
        "קו קיים: " <> pack (show hasKav) <> "\n" <>
        "תכונות: " <> pack (show props)
      kavInfo = case props of
        _ -> ""
  in base <> kavInfo
formatStateDetails (SefirotState entities connections) =
  let base = "ספירות קיימות: " <> pack (show $ Map.keys entities) <> "\n" <>
             "קשרים: " <> pack (show connections)
  in base
formatStateDetails (WorldsState hierarchy) =
  let numOlamim       = Map.size hierarchy
      numPartzufim    = sum (map Map.size (Map.elems hierarchy))
      numSefirahUnits = sum
        [ sum (map Map.size (Map.elems partzufMap))
        | partzufMap <- Map.elems hierarchy
        ]
      summary =  "מספר עולמות: "       <> pack (show numOlamim)    <> "\n" <>
                "מספר פרצופים (סה\"כ): " <> pack (show numPartzufim) <> "\n" <>
                "מספר יחידות ספירה (סה\"כ): " <> pack (show numSefirahUnits)
  in summary
formatStateDetails _ = "מצב לא מוכר"

-- | פונקציית עזר חדשה להמרת מצב לטקסט, מטפלת ב-IO עבור קריאות FFI
formatStateIO :: EngineState -> IO Text
formatStateIO state =
  let header = "==== מצב סימולציה: שלב " <> pack (show $ currentStage state) <>
               ", זמן " <> pack (show $ simulationTime state) <> " ====\n"
  in case simulationState state of
      EinSofState _ _ _ -> do
        einSofText <- getEinSofTraceFromAgda
        return $ header <> einSofText
      TzimtzumState radius hasReshimu hasKav _ _ props -> 
        return $ header <>
                 "צמצום: רדיוס=" <> pack (show radius) <> "\n" <>
                 "רשימו: " <> pack (show hasReshimu) <> "\n" <>
                 "קו: " <> pack (show hasKav) <> "\n" <>
                 "תכונות: " <> pack (show props)
      SefirotState entities connections ->
        return $ header <>
                 "ספירות קיימות: " <> pack (show $ Map.keys entities) <> "\n" <>
                 "קשרים: " <> pack (show connections)
      WorldsState hierarchy ->
        let numOlamim       = Map.size hierarchy
            numPartzufim    = sum (map Map.size (Map.elems hierarchy))
            numSefirahUnits = sum
              [ sum (map Map.size (Map.elems partzufMap))
              | partzufMap <- Map.elems hierarchy
              ]
            summary =  "מספר עולמות: "       <> pack (show numOlamim)    <> "\n" <>
                      "מספר פרצופים (סה\"כ): " <> pack (show numPartzufim) <> "\n" <>
                      "מספר יחידות ספירה (סה\"כ): " <> pack (show numSefirahUnits)
        in return $ header <> summary
      _ -> return $ header <> "מצב לא מוכר"

-- | האם הסימולציה הסתיימה
isSimulationComplete :: EngineState -> Bool
isSimulationComplete state =
  case currentStage state of
    EinSofStage -> simulationTime state >= 1
    TzimtzumStage ->
      case simulationState state of
        TzimtzumState r _ _ _ _ _ -> r >= 10 || simulationTime state >= 20
        _ -> simulationTime state >= 10
    _ -> simulationTime state >= 10

-- | הרצת סימולציה עם הדפסה דינמית (בזמן אמת)
runWithRealtimeOutput :: ScenarioId -> IO ()
runWithRealtimeOutput scenarioId = do
  case findScenario scenarioId of
    Nothing -> TIO.putStrLn $ "תרחיש לא נמצא: " <> pack (show scenarioId)
    Just scenario -> do
      let initialState = scenarioInitialState scenario
      TIO.putStrLn "=== התחלת סימולציה ==="
      initialFormattedState <- formatStateIO initialState
      TIO.putStrLn initialFormattedState
      TIO.putStrLn "--- מתחיל ביצוע executeScenario ---"
      execResult <- executeScenario scenario initialState
      case execResult of
        Left err -> TIO.putStrLn $ "*** שגיאה בביצוע התרחיש: " <> err
        Right execState -> do
          TIO.putStrLn "--- סיים ביצוע executeScenario ---"
          TIO.putStrLn "=== אירועי סימולציה ==="
          forM_ (simulationEvents execState) TIO.putStrLn
          execFormattedState <- formatStateIO execState
          TIO.putStrLn "המצב הסופי לאחר ביצוע התרחיש:"
          TIO.putStrLn execFormattedState
          let runStep currState iteration
                | iteration >= 20 = TIO.putStrLn "=== הגעה למספר הצעדים המקסימלי ==="
                | otherwise = do
                    threadDelay 500000
                    case stepSimulation currState of
                      Left err2 -> TIO.putStrLn $ "שגיאה: " <> err2
                      Right nextState -> do
                        nextFormattedState <- formatStateIO nextState
                        TIO.putStrLn nextFormattedState
                        if isSimulationComplete nextState || nextState == currState
                          then TIO.putStrLn "=== סימולציה הסתיימה ==="
                          else runStep nextState (iteration + 1)
          runStep execState 0
      TIO.putStrLn "סיום ריצה." 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Engine.Runner.BasicRunner where

import Data.Text (Text, pack)
import qualified Data.Text.IO as TIO
import Control.Concurrent (threadDelay)
import Control.Monad (forM_)
import Data.Maybe (listToMaybe)
import Debug.Trace (trace)
import Foreign.C.String (peekCString) -- Need for peekCString
import qualified MAlonzo.Code.Hishtalshelut.Domain.Math.Ordinal as AgdaOrdinal
import qualified Data.Map as Map

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario
import Engine.Scenarios.Library (findScenario)
import Engine.FFI.AgdaEinSof (getInitialTraceTextHaskell)
import Engine.Simulation.Core (stepSimulation)
import Engine.Simulation.Kav (describeLight)
import Engine.Types.CoreTypes (HierarchicalStructure)

-- | Remove the FFI Import for the Agda function
-- foreign import ccall "hs_getInitialTraceTextEn_FFI" hs_initialTraceTextEn 
--  :: IO CString 

-- | Helper function to get the Ein Sof trace from Agda using the Haskell wrapper
getEinSofTraceFromAgda :: IO Text
getEinSofTraceFromAgda = do
  -- Call the Haskell wrapper function instead of the direct FFI call
  cStringResult <- getInitialTraceTextHaskell 
  haskellString <- peekCString cStringResult -- Convert to Haskell String
  return $ pack haskellString -- Pack into Text

-- | הפיכת מצב לטקסט מפורמט
formatState :: EngineState -> Text
formatState state =
  "==== מצב סימולציה: שלב " <> pack (show $ currentStage state) <>
  ", זמן " <> pack (show $ simulationTime state) <> " ====\n" <>
  formatStateDetails (simulationState state)

-- | פירוט מצב סימולציה לפי הטיפוס
formatStateDetails :: SimulationState -> Text
formatStateDetails (EinSofState _ _ _) =
  -- במקום הפלט הפשוט, נקרא ללוגיקה מ-Agda
  -- התוצאה תהיה Text המכיל את הפלט המלא והמפורט
  -- הערה: זה יחזיר פלט IO, נצטרך לטפל בזה במקום שקורא לפונקציה הזו.
  -- *** שינוי זמני: נחזיר טקסט שמציין שצריך לקרוא ל-Agda ***
  -- *** מכיוון ש-formatStateDetails היא פונקציה טהורה וקריאת FFI היא IO ***
  "*** צריך לקרוא ל-Agda's initialTraceTextEn כדי לקבל פלט מלא ***"
formatStateDetails (TzimtzumState radius hasReshimu hasKav einL kavL props) =
  let base =
        "צמצום: רדיוס אורדינלי=" <> AgdaOrdinal.du_showOrdinal_154 (AgdaOrdinal.du_fromNatO_124 (fromIntegral radius)) <> "\n" <>
        "רשימו: " <> pack (show hasReshimu) <> "\n" <>
        "קו קיים: " <> pack (show hasKav) <> "\n" <>
        "תכונות: " <> pack (show props)
      kavInfo = case kavL of
        Just kavLight -> "\nקווי אור ראשוני: " <> describeLight kavLight
        Nothing       -> ""
  in base <> kavInfo
formatStateDetails (SefirotState entities connections) =
  let base = "ספירות קיימות: " <> pack (show $ Map.keys entities) <> "\n" <>
             "קשרים: " <> pack (show connections)
  in base
formatStateDetails (WorldsState hierarchy) =
  -- הדפסת סיכום למבנה ההיררכי כדי למנוע פלט כבד מדי
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
        -- קריאה לפונקציה שמביאה את הטקסט מ-Agda
        einSofText <- getEinSofTraceFromAgda
        return $ header <> einSofText
      TzimtzumState radius hasReshimu hasKav _ _ props -> 
        return $ header <> 
                 "צמצום: רדיוס אורדינלי=" <> AgdaOrdinal.du_showOrdinal_154 (AgdaOrdinal.du_fromNatO_124 (fromIntegral radius)) <> "\n" <>
                 "רשימו: " <> pack (show hasReshimu) <> "\n" <>
                 "קו: " <> pack (show hasKav) <> "\n" <>
                 "תכונות: " <> pack (show props)
      SefirotState entities connections ->
        return $ header <>
                 "ספירות קיימות: " <> pack (show $ Map.keys entities) <> "\n" <>
                 "קשרים: " <> pack (show connections)
      WorldsState hierarchy ->
        -- הדפסת סיכום למבנה ההיררכי כדי למנוע פלט כבד מדי
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
      
      -- הרצת התרחיש המותאם כדי לעדכן את ־EngineState בהתאם ל־Agda/Haskell logic
      TIO.putStrLn "--- מתחיל ביצוע executeScenario ---"
      execResult <- executeScenario scenario initialState
      case execResult of
        Left err -> TIO.putStrLn $ "*** שגיאה בביצוע התרחיש: " <> err
        Right execState -> do
          TIO.putStrLn "--- סיים ביצוע executeScenario ---"
          -- הדפסת כל האירועים שהצטברו במהלך executeScenario
          TIO.putStrLn "=== אירועי סימולציה ==="
          forM_ (simulationEvents execState) TIO.putStrLn
          -- המרת המצב הסופי לטקסט והדפסתו כדי לוודא העדכון
          execFormattedState <- formatStateIO execState
          TIO.putStrLn "המצב הסופי לאחר ביצוע התרחיש:"
          TIO.putStrLn execFormattedState
          -- הגנה מפני לולאה אינסופית לאחר הרצת התרחיש
          let runStep currState iteration
                | iteration >= 20 = TIO.putStrLn "=== הגעה למספר הצעדים המקסימלי ==="
                | otherwise = do
                    threadDelay 500000  -- השהיה של חצי שנייה
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
{-# LANGUAGE OverloadedStrings #-}

module Engine.Simulation.Core where

import Data.Text (Text, pack)
import qualified Data.Map as Map

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario (TransitionType(..))
import Engine.Simulation.Kav (kavTransitionFunc)

-- | הרצת צעד בודד של סימולציה (הועבר מ-BasicRunner)
stepSimulation :: EngineState -> Either Text EngineState
stepSimulation state = 
  case currentStage state of
    EinSofStage -> 
      Right $ state { simulationTime = simulationTime state + 1 }
    TzimtzumStage -> 
      case simulationState state of
        TzimtzumState r hasR hasK einL kavL props -> 
          if r < 10
            then Right $ state
              { simulationState = TzimtzumState (r + 1) hasR hasK einL kavL props
              , simulationTime = simulationTime state + 1
              }
            else Right $ state { simulationTime = simulationTime state + 1 }
        _ -> Left "מצב לא תקין לצמצום בשלב הצמצום"
    _ -> Right $ state { simulationTime = simulationTime state + 1 }

-- | ביצוע מעבר לפי סוג המעבר (הועבר מ-BasicRunner)
applyTransition :: TransitionType -> EngineState -> Either Text EngineState
applyTransition transType state = case transType of
  TzimtzumTransition -> tzimtzumTransitionFunc state
  KavTransition      -> kavTransitionFunc state
  _ -> Right state  -- פונקציית זהות כברירת מחדל

-- | פונקציית מעבר צמצום (הועבר מ-Scenario.hs / BasicRunner)
tzimtzumTransitionFunc :: EngineState -> Either Text EngineState
tzimtzumTransitionFunc state =
  if currentStage state /= EinSofStage
    then Left "מעבר צמצום אפשרי רק משלב האין-סוף"
    else case simulationState state of
      EinSofState { einSofLight = einL, einSofProperties = einProps, einSofDescription = einDesc } ->
        let newSimState = TzimtzumState
              { tzimtzumRadius      = 1
              , tzimtzumHasReshimu  = True
              , tzimtzumHasKav      = False
              , tzimtzumEinSofLight = einL
              , tzimtzumKavLight    = Nothing
              , tzimtzumProperties  = Map.fromList [("יש_חלל_פנוי", True), ("יש_רשימו", True)]
              }
            newState = state
              { currentStage     = TzimtzumStage
              , simulationState  = newSimState
              , simulationTime   = simulationTime state + 1
              , simulationEvents = "התרחש צמצום ראשוני" : simulationEvents state
              }
        in Right newState
      _ -> Left "מצב לא תקין למעבר צמצום" 
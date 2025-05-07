{-# LANGUAGE OverloadedStrings #-}

module Engine.Scenarios.Library where

import qualified Data.Map as Map
import Data.List (find)
import Data.Text (Text, unpack, pack)
import Control.Monad (foldM, when)
import Data.Maybe (fromMaybe)
import qualified Data.Text.IO as TIO  -- הדפסות בזמן אמת

import Engine.Types.BasicTypes
import Engine.Types.SimulationState
import Engine.Types.Scenario
import Engine.FFI.AgdaTzimtzum (getTzimtzumTraceHebrew, getTzimtzumTraceEnglish)
import Engine.FFI.AgdaIgulimYosher (getIgulimYosherTrace)
import Engine.Simulation.Core (applyTransition, stepSimulation)
import Engine.Types.LightTypes (Light)
import Engine.Simulation.Kav (describeLight, intToOrdinal)
import Engine.Simulation.AkPreparation
  ( Context(..)
  , SefirahLevelInfo(..)
  , calculateReshimuStructure
  , determinePnimiNaranTzelem
  , determineMakifChayaTzelem
  , createThreeLayeredKeli
  , attireNaranInKeliTzelem
  , surroundChayaAroundKeliTzelem
  , initializeAdamKadmon
  , calcDistanceRetreat
  , performDirectMakifRetreat
  , SpaceSpec(..)
  , generateSpaceSpec
  )
import Engine.Types.CoreTypes
  ( OlamId(AK, Atzilut, Beriah, Yetzirah, Asiyah)
  , PartzufId(AkOverall, Atik, ArichAnpin, Abba, Imma, ZONMale, ZONFemale, BeriahOverall, YetzirahOverall, AsiyahOverall)
  , SefirahId(Keter, Hokhmah, Binah, Hesed, Gevurah, Tiferet, Netzah, Hod, Yesod, Malkhut)
  , FullIdentity(..)
  , SefirahUnit(..)
  , HierarchicalStructure
  , atzilutPartzufSequence
  , PnimiLights(..)
  , MakifLights(..)
  , AttireResult(..)
  , GlobalEffect(..)
  )
import Engine.Scenarios.Stage4Logs
  ( stage4Header
  , logDefineStructure
  , logGetOlamOrder
  , logFormationSpace
  , logSourceLight
  , logStartOuter
  , logEndOuter
  , logStartPartzuf
  , logEndPartzuf
  , logStartSefirah
  , logEndSefirah
  , logCreateIgul
  , logCreateYosher
  , logIgulCompleted
  , logYosherCompleted
  , logAttireBroken
  , logAttireSuccess
  , logCheckMakif
  , logMakifYasharAttached
  , logMakifYasharDistancing
  , logNewFormationSpace
  , logUpdatedSourceLight
  , logAppliedHeightLimits
  , logBreakOlam
  )

-- | ספריית כל התרחישים במערכת
allScenarios :: [Scenario]
allScenarios =
  [ einsofScenario
  , tzimtzumFullScenario
  , kavScenario      -- Scenario for Stage 2: Kav extension
  , akPreparationScenario -- Scenario for Stage 3: AK preparation
  , akIgulimYosherScenario  -- Scenario for Stage 4: AK + ABiYA hierarchical emanation
    -- בעתיד יתווספו תרחישים נוספים
  ]

-- | חיפוש תרחיש לפי מזהה
findScenario :: ScenarioId -> Maybe Scenario
findScenario id = find ((== id) . scenarioId . scenarioInfo) allScenarios

-- | רשימת כל התרחישים הזמינים (למידע בלבד)
listScenarios :: [ScenarioInfo]
listScenarios = map scenarioInfo allScenarios

-- | תרחיש חדש המתמקד בשלב האין-סוף בלבד
einsofScenario :: Scenario
einsofScenario = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId = ScenarioId "einsof-scenario"
      , scenarioName = "תרחיש אין סוף"
      , scenarioDescription = "תרחיש בסיסי להצגת שלב האין סוף"
      , scenarioStages = [EinSofStage]
      }
  , scenarioInitialState = initialEinSofState
  , scenarioTransitions = []
  , scenarioFinalState = Nothing
  , scenarioParameters = SimulationParameters
      { paramMap = Map.empty
      }
  , executeScenario = \currentState -> return (Right currentState)
  }

-- | תרחיש הצמצום הבסיסי להדגמה - נגדיר אותו מחדש כ"בלוק" מלא
tzimtzumFullScenario :: Scenario
tzimtzumFullScenario = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId = ScenarioId "tzimtzum-full" -- New ID for the full process block
      , scenarioName = "תרחיש צמצום מלא"
      , scenarioDescription = "תרחיש המבצע את כל שלב הצמצום, מהמעבר עד הסוף"
      , scenarioStages = [EinSofStage, TzimtzumStage] -- Represents the stages involved
      }
  , scenarioInitialState = initialEinSofState -- Starting point for this scenario block
  , scenarioTransitions = [] -- Transitions are internal to Agda now
  , scenarioFinalState = Nothing -- Determined by Agda's execution
  , scenarioParameters = SimulationParameters { paramMap = Map.empty }
  , executeScenario = \currentState -> do
      -- קבלת מסלול הטקסט ישירות מ־Agda
      traceLines <- getTzimtzumTraceHebrew
      -- בניית מצב Tzimtzum והעברת ה־trace לאירועים
      if currentStage currentState == EinSofStage then do
        -- Simulate successful execution and return a dummy final Tzimtzum state
        let EinSofState { einSofLight = einL } = simulationState currentState
            tzState = TzimtzumState
              { tzimtzumRadius      = 10
              , tzimtzumHasReshimu  = True
              , tzimtzumHasKav      = False
              , tzimtzumEinSofLight = einL
              , tzimtzumKavLight    = Nothing
              , tzimtzumProperties  = Map.fromList [("יש_חלל_פנוי", True), ("יש_רשימו", True)]
              }
            events' = simulationEvents currentState ++ traceLines ++ ["צמצום מלא בוצע"]
            newSt = currentState { currentStage     = TzimtzumStage
                                  , simulationState  = tzState
                                  , simulationTime   = simulationTime currentState + 10
                                  , simulationEvents = events'
                                  }
        return (Right newSt)
      else
        return (Left "Cannot start full Tzimtzum from a non-EinSof state.")
  }

-- | Simulate full contraction: apply one TzimtzumTransition then step until radius>=10
simulateFullTzimtzum :: EngineState -> EngineState
simulateFullTzimtzum st0 =
  let step state = either (error . unpack) id (stepSimulation state)
      st1 = either (error . unpack) id $ applyTransition TzimtzumTransition st0
      go st = case simulationState st of
        TzimtzumState r _ _ _ _ _ | r >= 10 -> st
        _ -> go (step st)
  in go st1

-- | תרחיש המשכת הקו (Stage 2) - רק לאחר תרחיש הצמצום מלא
initialTzimtzumState :: EngineState
initialTzimtzumState = simulateFullTzimtzum initialEinSofState

-- | תרחיש המשכת הקו (Stage 2) - רק הרחבת הקו לאחר הצמצום
kavScenario :: Scenario
kavScenario = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId = ScenarioId "kav-scenario"
      , scenarioName = "תרחיש המשכת הקו"
      , scenarioDescription = "תרחיש מבצע מתיחת הקו לאחר סינון ראשוני של אור הצמצום"
      , scenarioStages = [TzimtzumStage]
      }
  , scenarioInitialState = initialTzimtzumState
  , scenarioTransitions =
      [ ScenarioTransition
          { transitionName = "מתיחת הקו"
          , transitionDescription = "מעבר קו וצמצום ראשוני של אור הצמצום"
          , transitionSourceStage = TzimtzumStage
          , transitionTargetStage = TzimtzumStage
          , transitionType = KavTransition
          }
      ]
  , scenarioFinalState = Nothing
  , scenarioParameters = SimulationParameters { paramMap = Map.empty }
  , executeScenario = \currentState -> return $ applyTransition KavTransition currentState
  }

-- | הסבה של קוד אין-סוף קיים לתרחיש מובנה - כנראה לא נחוץ יותר
{- convertEinSofToScenario :: ScenarioId -> Text -> Scenario
convertEinSofToScenario sid name = Scenario
  { ... }
-}

-- getTransitionFunction :: TransitionType -> (EngineState -> Either Text EngineState)
-- getTransitionFunction = ...

-- tzimtzumTransitionFunc :: EngineState -> Either Text EngineState
-- tzimtzumTransitionFunc = ... 

-- | Initial state for AK Preparation (Stage 3): after Kav transition
initialAkPreparationState :: EngineState
initialAkPreparationState = either (error . unpack) id $
  applyTransition KavTransition initialTzimtzumState

-- | Scenario for Stage 3: הגדרת ופיקוח על עזרי א"ק
akPreparationScenario :: Scenario
akPreparationScenario =
  let params = Map.fromList
        [ ("max_recursion_depth", "1")
        , ("sefirah_level", "3")
        , ("entityId", "adam-1")
        ]
  in Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId          = ScenarioId "ak-preparation-scenario"
      , scenarioName        = "תרחיש הכנה לאדם-קדמון"
      , scenarioDescription = "תרחיש שלב 3: הגדרת פונקציות וטיפוסים למבנה אדם-קדמון"
      , scenarioStages      = [SefirotStage]
      }
  , scenarioInitialState  = initialAkPreparationState
  , scenarioTransitions   = []
  , scenarioFinalState    = Nothing
  , scenarioParameters    = SimulationParameters { paramMap = params }
  , executeScenario       = executeAkPreparation params
  }

-- helper to extract TzimtzumState
extractTzim :: EngineState -> Maybe SimulationState
extractTzim st = case simulationState st of
  TzimtzumState{} -> Just (simulationState st)
  _               -> Nothing 

-- | Execute Scenario for Stage 3: AK preparation
executeAkPreparation
  :: Map.Map Text Text
  -> EngineState
  -> IO (Either Text EngineState)
executeAkPreparation params currentState = do
  let (radius, hasResh) = case simulationState currentState of
        TzimtzumState r hasR _ _ _ _ -> (r, hasR)
        _                           -> (0, False)
      maybeTzim  = extractTzim currentState
      kavLight   = fromMaybe defaultInfiniteLight (maybeTzim >>= tzimtzumKavLight)
      ctx        = Context kavLight Atzilut AkOverall Keter
      lvl        = read (unpack (fromMaybe "1" (Map.lookup "sefirah_level" params))) :: Int
      eidId      = EntityId (fromMaybe "adam-1" (Map.lookup "entityId" params))
      pnimiL     = determinePnimiNaranTzelem ctx (SefirahLevelInfo lvl)
      makifL     = determineMakifChayaTzelem ctx (SefirahLevelInfo lvl) pnimiL
      reshimuStr = calculateReshimuStructure kavLight (intToOrdinal lvl) (intToOrdinal lvl)
      initialK   = createThreeLayeredKeli eidId reshimuStr
      attireRes  = attireNaranInKeliTzelem pnimiL initialK
      (surK, gev) = surroundChayaAroundKeliTzelem makifL initialK
      akKeli     = initializeAdamKadmon ctx (SefirahLevelInfo lvl) eidId
      events3 =
        [ "# --- Stage 3: Defining/Verifying existence of helper functions and types for AK+ABiYA scaffold construction."
        , "LOG \"Stage 3: Defining/Verifying existence of helper functions and types for AK+ABiYA scaffold construction.\""
        , "vacated_space_with_reshimu: (radius=" <> pack (show radius) <> ", hasResh=" <> pack (show hasResh) <> ")"
        , "kav: " <> describeLight kavLight
        , "calculateReshimuStructure: " <> pack (show reshimuStr)
        , "pnimiLights: " <> pack (show pnimiL)
        , "makifLights: " <> pack (show makifL)
        , "initial Keli: " <> pack (show initialK)
        , "attire result: " <> pack (show attireRes)
        , "surrounded Keli: " <> pack (show surK)
        , "global effect: " <> pack (show gev)
        , "initializeAdamKadmon Keli: " <> pack (show akKeli)
        , "LOG \"--- End Stage 3 ---\""
        , "Main simulation state initialized for AK + ABiYA potential layers construction stage."
        ]
  return $ Right currentState { simulationEvents = events3 }

-- | Scenario for Stage 4: AK and ABiYA potential layers hierarchical emanation
akIgulimYosherScenario :: Scenario
akIgulimYosherScenario = Scenario
  { scenarioInfo = ScenarioInfo
      { scenarioId          = ScenarioId "ak-igulim-yosher-scenario"
      , scenarioName        = "תרחיש האצלת א\"ק ושכבות אבי\"ע"
      , scenarioDescription = "תרחיש שלב 4: האצלת המבנה ההיררכי (א\"ק, פרצופי אצילות ושכבות בי\"ע)"
      , scenarioStages      = [PartzufimStage]
      }
  , scenarioInitialState  = initialAkPreparationState
  , scenarioTransitions   = []
  , scenarioFinalState    = Nothing
  , scenarioParameters    = SimulationParameters { paramMap = Map.empty }
  , executeScenario       = executeAkIgulimYosher
  }

-- | Execute Scenario for Stage 4: AK + IgulimYosher hierarchical emanation
executeAkIgulimYosher :: EngineState -> IO (Either Text EngineState)
executeAkIgulimYosher currentState = do
  -- Starting Stage 4 logs, no Agda trace block

  mapM_ TIO.putStrLn stage4Header
  TIO.putStrLn logDefineStructure
  TIO.putStrLn $ "OLAM_PARTZUF_STRUCTURE = " <> pack (show olamPartzufMap)
  TIO.putStrLn (logGetOlamOrder olamOrder)
  -- initialize dynamic formation space and source light
  let initialSpaceSpec = SpaceSpec radius hasResh
  TIO.putStrLn (logFormationSpace (pack $ show initialSpaceSpec))
  TIO.putStrLn (logSourceLight (pack $ show sourceLightVal))
  -- execute world/partzuf/sefirah loops with dynamic space and light
  (finalHierarchy, finalMakifim, _, _) <- foldM stepOlam (initialHierarchy, initialMakifim, initialSpaceSpec, sourceLightVal) olamOrder

  let newState = currentState
        { simulationState  = WorldsState finalHierarchy
        , worldEntities    = finalHierarchy
        , activeMakifim    = finalMakifim
        , simulationEvents = []  -- פלט כבר הודפס בזמן אמת
        , currentStage     = PartzufimStage
        , simulationTime   = simulationTime currentState + 1
        }
  return $ Right newState
  where
    olamOrder = [AK, Atzilut, Beriah, Yetzirah, Asiyah]
    (radius, hasResh, mKav) = case simulationState currentState of
      TzimtzumState r hr _ _ mk _ -> (r, hr, mk)
      _                          -> (0, False, Nothing)
    sourceLightVal = fromMaybe defaultInfiniteLight mKav
    olamPartzufMap = Map.fromList
      [ (AK,       [AkOverall])
      , (Atzilut,  atzilutPartzufSequence)
      , (Beriah,   [BeriahOverall])
      , (Yetzirah, [YetzirahOverall])
      , (Asiyah,   [AsiyahOverall])
      ]
    initialHierarchy = Map.empty :: HierarchicalStructure
    initialMakifim = maybe [] (:[]) mKav
    srcLight = sourceLightVal

    -- | Step through one sefirah, update hierarchy ומדפיס לוגים בזמן אמת
    stepSefirah :: (HierarchicalStructure, [Light], SpaceSpec, Light) -> (OlamId, PartzufId, SefirahId) -> IO (HierarchicalStructure, [Light], SpaceSpec, Light)
    stepSefirah (h, m, spaceSpec, srcLight) (ol, p, s) = do
      let fid     = FullIdentity ol p s
          sefTxt  = pack $ show s
      -- התחלת ספירה ולוגים
      TIO.putStrLn (logStartSefirah sefTxt)
      TIO.putStrLn logCreateIgul
      TIO.putStrLn logIgulCompleted
      TIO.putStrLn logCreateYosher
      TIO.putStrLn logYosherCompleted
      -- compute keli and attire
      let ctx      = Context srcLight ol p s
          lvlInfo  = SefirahLevelInfo (fromEnum s + 1)
          igulKeli = createThreeLayeredKeli (EntityId $ pack $ show fid)
            (calculateReshimuStructure srcLight (intToOrdinal (fromEnum s + 1)) (intToOrdinal 10))
          (yosherKeli', genEff, attLogs) =
            case attireNaranInKeliTzelem (determinePnimiNaranTzelem ctx lvlInfo) igulKeli of
              AttireBroken k reason ->
                (k, Nothing, [ logAttireBroken (pack $ show fid) reason ])
              AttireSuccess k ->
                let (k', e) = surroundChayaAroundKeliTzelem
                                (determineMakifChayaTzelem ctx lvlInfo (determinePnimiNaranTzelem ctx lvlInfo))
                                k
                in (k', Just e, [ logAttireSuccess (pack $ show fid) ])
      -- לוגים של תוצאות החולצה וסיום הספירה
      mapM_ TIO.putStrLn attLogs
      TIO.putStrLn (logEndSefirah sefTxt)
      let su      = SefirahUnit { suIdentity        = fid
                                   , suIgulKeli        = Just igulKeli
                                   , suIgulInnerLight  = Just (determinePnimiNaranTzelem ctx lvlInfo)
                                   , suIgulOuterLight  = Just (determineMakifChayaTzelem ctx lvlInfo (determinePnimiNaranTzelem ctx lvlInfo))
                                   , suYosherKeli      = yosherKeli'
                                   , suGeneratedEffect = genEff
                                   , suProcessingLogs  = []
                                   , suConnections     = [] }
          h'      = Map.insertWith (Map.unionWith Map.union) ol (Map.singleton p (Map.singleton s su)) h
      return (h', m, spaceSpec, srcLight)

    -- | Step through one partzuf בתוך לולאת עולם, מדפיס לוגים בזמן אמת
    stepPartzuf :: (HierarchicalStructure, [Light], SpaceSpec, Light) -> OlamId -> PartzufId -> IO (HierarchicalStructure, [Light], SpaceSpec, Light)
    stepPartzuf (h, m, spaceSpec, srcLight) ol p = do
      let pTxt = pack (show p)
          olTxt = pack (show ol)
          spaceTxt = pack (show spaceSpec)
      -- תחילת הפרצוף ולוגים
      TIO.putStrLn (logStartPartzuf pTxt olTxt spaceTxt)
      -- loop over sefiros
      (h', m', _, _) <- foldM stepSefirah (h, m, spaceSpec, srcLight) (map (\s -> (ol, p, s)) (enumFromTo Keter Malkhut))
      -- בדיקת מרחק Makif Yashar
      TIO.putStrLn (logCheckMakif pTxt olTxt)
      (newSpaceSpec, newMakif) <- if ol == Asiyah && p == AsiyahOverall
        then do
          TIO.putStrLn (logMakifYasharAttached olTxt)
          return (spaceSpec, srcLight)
        else do
          let d = calcDistanceRetreat ol p
              oldMakif = srcLight
              newMakif = performDirectMakifRetreat oldMakif d
              newSpaceSpec = generateSpaceSpec newMakif d
          TIO.putStrLn (logMakifYasharDistancing d)
          TIO.putStrLn (logNewFormationSpace (pack $ show newSpaceSpec))
          TIO.putStrLn (logUpdatedSourceLight (pack $ show newMakif))
          return (newSpaceSpec, newMakif)
      -- סיום הפרצוף
      TIO.putStrLn (logEndPartzuf pTxt olTxt)
      return (h', m', newSpaceSpec, newMakif)

    -- | Step through one world, לולאת עולם עם לוגים בזמן אמת
    stepOlam :: (HierarchicalStructure, [Light], SpaceSpec, Light) -> OlamId -> IO (HierarchicalStructure, [Light], SpaceSpec, Light)
    stepOlam (h, m, spaceSpec, srcLight) ol = do
      let olTxt = pack (show ol)
      TIO.putStrLn (logStartOuter olTxt)
      (h', m', newSpaceSpec, newSourceLight) <- foldM (\(hAcc, mAcc, sAcc, srcAcc) p -> stepPartzuf (hAcc, mAcc, sAcc, srcAcc) ol p) (h, m, spaceSpec, srcLight) (Map.findWithDefault [] ol olamPartzufMap)
      when (ol == Atzilut) $ TIO.putStrLn (logAppliedHeightLimits (pack (show ol)))
      TIO.putStrLn (logEndOuter olTxt)
      when (ol == Asiyah) $ TIO.putStrLn (logBreakOlam olTxt)
      return (h', m', newSpaceSpec, newSourceLight) 
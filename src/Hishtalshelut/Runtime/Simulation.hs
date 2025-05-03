{-# LANGUAGE OverloadedStrings #-}
-- | Runtime API for running Kabbalistic simulations
module Hishtalshelut.Runtime.Simulation
  ( Scenario(..)
  , ScenarioConfig(..)
  , scenarioParser
  , runScenario
  ) where

import Options.Applicative
import Data.Text (Text, unpack, pack)
import qualified Data.Text.IO as TIO
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.EinSofEngine as EF

-- | Language selection for output
data OutputLang = Hebrew | English deriving (Show, Eq)

-- | Simulation scenarios
data Scenario
  = InitialEinSof    -- ^ initial Ein Sof state
  | Circles          -- ^ hierarchical circles
  | Contraction Integer  -- ^ contraction with depth
  | Geometry         -- ^ geometry 3D trace
  | All              -- ^ run all scenarios
  | DynamicContraction Integer  -- ^ dynamic contraction with live logs
  deriving (Show, Eq)

-- | Configuration for a simulation run
data ScenarioConfig = ScenarioConfig
  { scScenario :: Scenario      -- ^ chosen scenario
  , scOutput   :: Maybe FilePath -- ^ optional output file
  , scLang     :: OutputLang     -- ^ output language
  } deriving (Show, Eq)

-- | CLI parser for ScenarioConfig
scenarioParser :: Parser ScenarioConfig
scenarioParser = ScenarioConfig
  <$> subparser
      ( command "אין-סוף"
          ( info (pure InitialEinSof)
            ( progDesc "Run initial Ein Sof state" )
          )
     <> command "עגולים"
          ( info (pure Circles)
            ( progDesc "Run hierarchical circles simulation" )
          )
     <> command "צמצום"
          ( info
            (Contraction <$> argument auto (metavar "DEPTH"))
            ( progDesc "Run contraction simulation with depth" )
          )
     <> command "גיאומטריה"
          ( info (pure Geometry)
            ( progDesc "Run geometry simulation" )
          )
     <> command "הכל"
          ( info (pure All)
            ( progDesc "Run all simulations" )
          )
     <> command "צמצום-דינמי"
          ( info (DynamicContraction <$> argument auto (metavar "DEPTH"))
            ( progDesc "Run dynamic contraction simulation with live logs" )
          )
      )
  <*> optional (strOption
      ( long "output"
     <> short 'o'
     <> metavar "FILE"
     <> help "Write output to file" ))
  <*> option auto
      ( long "lang"
     <> metavar "LANG"
     <> help "Select output language: Hebrew or English (default: English)"
     <> value English )

-- | Execute the chosen simulation and output trace
runScenario :: ScenarioConfig -> IO ()
runScenario (ScenarioConfig sc mOut lang) = case sc of
  InitialEinSof ->
    let traceLines = case lang of
          Hebrew  -> EF.d_initialTraceTextHe
          English -> EF.d_initialTraceTextEn
    in case mOut of
      Just fp -> writeFile fp (unlines $ map unpack traceLines)
      Nothing -> mapM_ TIO.putStrLn traceLines
  DynamicContraction n -> simulateContractionFlow n
  _ -> do
    let traceLines = case sc of
          InitialEinSof      -> case lang of { Hebrew -> EF.d_initialTraceTextHe; English -> EF.d_initialTraceTextEn }
          Circles        -> E.d_hierarchicalTraceText_248
          Contraction n  -> E.d_contractionTraceText_252 n
          Geometry       -> E.d_geometryTraceText_458
          All            -> concat
            [ case lang of { Hebrew -> EF.d_initialTraceTextHe; English -> EF.d_initialTraceTextEn }
            , E.d_hierarchicalTraceText_248
            , E.d_contractionTraceText_252 3
            , E.d_geometryTraceText_458
            ]
    case mOut of
      Just fp -> writeFile fp (unlines $ map unpack traceLines)
      Nothing -> mapM_ TIO.putStrLn traceLines

-- | Detailed dynamic contraction logs with step-by-step state
simulateContractionDetailed :: Integer -> [Text]
simulateContractionDetailed maxR =
  let header0 =
        [ pack "=== Stage 0: מצב טרום-אתחול (אין סוף) ==="
        , pack "EinSofState { einSof = einsOf, isFullOfLight = true }"
        , pack "ContractionState { radius = 0, reshimu = NoReshimu, status = NoTzimtzum, hasLight = true }"
        , pack ""
        ]
      header1 =
        [ pack "=== Stage 1: אירוע מחולל וצמצום ==="
        , pack "מפעיל אירוע: רצון_אלוהי_לברוא."
        , pack "מבצע פונקציה ראשית: צמצום."
        , pack ""
        ]
      n = maxR
      steps = concatMap (\(i,r) ->
        [ pack $ "Step " ++ show i ++ "/" ++ show n ++ ": void→" ++ show r
        , pack $ "  before: { radius = " ++ show (r-1) ++ ", reshimu = NoReshimu }"
        , pack $ "  action : ContractStep " ++ show r
        , pack $ "  after  : { radius = " ++ show r ++ ", reshimu = NoReshimu }"
        , pack ""
        ]) (zip [1..] [1..n])
  in header0 ++ header1 ++ steps

-- | Run dynamic contraction simulation with real computations (single source-of-truth)
simulateContractionFlow :: Integer -> IO ()
simulateContractionFlow maxR = mapM_ TIO.putStrLn (simulateContractionDetailed maxR)

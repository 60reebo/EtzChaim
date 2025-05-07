{-# LANGUAGE OverloadedStrings #-}
module Engine.Simulation.Kav where

import Data.Text (Text, pack)
import Engine.Types.SimulationState
import Engine.Types.LightTypes
import Engine.Types.BasicTypes (SimulationStage(..))
import qualified Data.Map as Map
import Data.Either (Either(..))
import Data.List (any, take)

-- | Rank for Ordinal to compare sizes
ordinalRank :: Ordinal -> Int
ordinalRank Zero       = 0
ordinalRank (Succ o)   = 1 + ordinalRank o
ordinalRank (Limit _)  = maxBound

-- | Is one Ordinal stronger (greater) than another?
ordinalStronger :: Ordinal -> Ordinal -> Bool
ordinalStronger a b = ordinalRank a > ordinalRank b

-- | Attenuate power (Cardinal) handling finite and infinite
attenuatePower :: Cardinal -> Cardinal -> Cardinal
attenuatePower (Fin n) (Fin m)
  | n <= m    = Fin 0
  | otherwise = Fin (n - m)
attenuatePower (Fin _) (Aleph _) = Fin 0
attenuatePower (Aleph a) (Fin _) = Aleph a
attenuatePower (Aleph a) (Aleph b)
  | a > b     = Aleph (a - b)
  | otherwise = Fin 0

-- | Build finite ordinal from an Int
intToOrdinal :: Int -> Ordinal
intToOrdinal n
  | n <= 0    = Zero
  | otherwise = Succ (intToOrdinal (n - 1))

-- | Attenuate structure (Ordinal) by ordinal subtraction a - b
attenuateStructure :: Ordinal -> Ordinal -> Ordinal
attenuateStructure Zero _ = Zero
attenuateStructure a Zero = a
-- infinite ordinal minus any ordinal stays infinite
attenuateStructure a@(Limit _) _ = a
-- finite ordinal minus infinite ordinal yields zero
attenuateStructure (Succ _) (Limit _) = Zero
-- finite ordinal minus finite ordinal: subtract by numeric difference
attenuateStructure a@(Succ _) b@(Succ _) =
  let na = ordinalRank a
      nb = ordinalRank b
      diff = max 0 (na - nb)
  in intToOrdinal diff

-- | Core attenuation using AttenuationFactor
attenuate :: Light -> AttenuationFactor -> Light
attenuate light factor = 
  let newPower     = attenuatePower (power light) (powerFactor factor)
      newStruct    = structureFactor factor
      newCategory  = category light  -- qualityChange not implemented
      newKind      = if preserveKind factor then kind light else kind light
      newSource    = source light <> "-attenuated"
      newTimestamp = timestamp light + 1
  in Light newPower newStruct newCategory newKind newSource newTimestamp

-- | Convert Cardinal to Text
powerToText :: Cardinal -> Text
powerToText (Fin n)   = "fin(" <> pack (show n) <> ")"
powerToText (Aleph a) = "aleph(" <> pack (show a) <> ")"

-- | Convert Ordinal to Text
ordinalToText :: Ordinal -> Text
ordinalToText Zero       = "0"
ordinalToText (Succ o)   = "S(" <> ordinalToText o <> ")"
ordinalToText o@(Limit xs)
  | any isNestedLimit (take 2 xs) = "ε₀"
  | otherwise                     = "lim(...)"
  where
    isNestedLimit (Limit _) = True
    isNestedLimit _         = False

-- | Convert LightCategory to Text
categoryToText :: LightCategory -> Text
categoryToText UndifferentiatedLightCategory = "Undifferentiated"
categoryToText Nefesh                       = "Nefesh"
categoryToText Ruach                        = "Ruach"
categoryToText Neshama                      = "Neshama"
categoryToText Chaya                        = "Chaya"
categoryToText Yechida                      = "Yechida"

-- | Convert LightKind to Text
kindToText :: LightKind -> Text
kindToText Pnimi = "Pnimi"
kindToText Makif = "Makif"

-- | Describe a Light for logging
describeLight :: Light -> Text
describeLight l = 
  "power=" <> powerToText (power l)
  <> ", structure=" <> ordinalToText (structure l)
  <> ", category=" <> categoryToText (category l)
  <> ", kind=" <> kindToText (kind l)
  <> ", source=" <> source l
  <> ", timestamp=" <> pack (show (timestamp l))

-- | Record representing a Kav (Line) instance
data KavInstance = KavInstance
  { kavName                 :: Text   -- ^ Name of the Kav
  , initialTransmittedLight :: Light  -- ^ Initial light transmitted through the Kav
  } deriving (Show, Eq)

-- | Create a new KavInstance given a name and the initial transmitted light
createKavInstance :: Text -> Light -> KavInstance
createKavInstance name l = KavInstance { kavName = name, initialTransmittedLight = l }

-- | A strong limit ordinal ε₀ for Kav structure (infinite tower of ω)
epsilon0 :: Ordinal
epsilon0 = Limit (iterate (\o -> Limit [o]) Zero)

-- | Attenuation factor for Kav transition
kavAttenuationFactor :: AttenuationFactor
kavAttenuationFactor = AttenuationFactor
  { powerFactor     = Aleph 10
  , structureFactor = epsilon0
  , qualityChange   = \qc -> qc  -- no change to quality
  , preserveKind    = True
  }

-- | Perform Kav transition (Stage 2)
kavTransitionFunc :: EngineState -> Either Text EngineState
kavTransitionFunc state
  | currentStage state /= TzimtzumStage = Left "מעבר קו אפשרי רק בשלב הצמצום"
  | otherwise = case simulationState state of
      TzimtzumState r hasR hasK einL kavL props ->
        if hasK then
          Left "קו כבר הומשך"
        else
          let lightAtKavStart = attenuate einL kavAttenuationFactor
              newSimState = TzimtzumState
                { tzimtzumRadius      = r
                , tzimtzumHasReshimu  = hasR
                , tzimtzumHasKav      = True
                , tzimtzumEinSofLight = einL
                , tzimtzumKavLight    = Just lightAtKavStart
                , tzimtzumProperties  = props
                }
              newState = state
                { -- advance to next simulation stage after Kav
                  currentStage     = SefirotStage
                , simulationState  = newSimState
                , simulationTime   = simulationTime state + 1
                , simulationEvents =
                    [ "# --- Stage 2: Extending the Kav (Line) ---"
                    , "LOG \"Stage 2: Extending the Kav (Line) into the Space.\""
                    , ">>> Output: Kav extended. Initial light in Kav (after attenuation): "
                      <> describeLight lightAtKavStart <> "."
                    , "LOG \"--- End Stage 2 ---\""
                    ] ++ simulationEvents state
                }
          in Right newState
      _ -> Left "מצב לא תקין למעבר קו" 
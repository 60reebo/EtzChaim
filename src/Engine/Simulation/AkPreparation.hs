module Engine.Simulation.AkPreparation where

import Engine.Types.BasicTypes (EntityId)
import Engine.Types.LightTypes (Light(..), Ordinal(..), Cardinal(..), AttenuationFactor(..), power)
import Data.Text (Text)
import Data.List (find, findIndex, elemIndex)
import Engine.Types.LightTypes (LightCategory(..), LightKind(..))
import Engine.Types.SimulationState (defaultInfiniteLight)
import Engine.Simulation.Kav (ordinalRank, intToOrdinal, ordinalStronger, describeLight, attenuatePower, ordinalToText)
import Engine.Types.CoreTypes
  ( OlamId(..), PartzufId(..), SefirahId
  , PnimiLights(..), MakifLights(..)
  , KeliLayer(..), Keli(..)
  , AttireResult(..), GlobalEffect(..)
  , atzilutPartzufSequence
  )
import Data.Maybe (fromMaybe)

-- | ω ordinal
omega :: Ordinal
omega = Limit (iterate Succ Zero)

-- | Helper: ordinal addition
ordinalAdd :: Ordinal -> Ordinal -> Ordinal
ordinalAdd Zero b       = b
ordinalAdd (Succ a) b   = Succ (ordinalAdd a b)
ordinalAdd (Limit xs) b = Limit (map (`ordinalAdd` b) xs)

-- | Calculate Reshimu structure: ω + currentLayer
calculateReshimuStructure
  :: Light    -- ^ source light
  -> Ordinal  -- ^ current layer index
  -> Ordinal  -- ^ max layers (unused)
  -> Ordinal  -- ^ inherited structure
calculateReshimuStructure _ currentLayer _ = ordinalAdd omega currentLayer

-- | Context for AkPreparation (source infinite light and hierarchy position)
data Context = Context
  { sourceLight    :: Light      -- ^ infinite light at this stage
  , contextOlam    :: OlamId     -- ^ current world
  , contextPartzuf :: PartzufId  -- ^ current Partzuf
  , contextSefirah :: SefirahId  -- ^ current sefirah position
  } deriving (Show, Eq)

-- | Information about the Sefirah level (1-10)
data SefirahLevelInfo = SefirahLevelInfo
  { sefirahLevel :: Int  -- ^ numeric sefirah level (1-10)
  } deriving (Show, Eq)

-- | Calculate the next Aleph cardinal, fallback for finite values
nextAleph :: Cardinal -> Cardinal
nextAleph (Aleph a) = Aleph (a + 1)
nextAleph _         = Aleph 0

-- | Derive overall capacity from reshimu structure
deriveCapacityFromReshimu :: Ordinal -> Cardinal
-- כלי אדם-קדמון: קיבולת אינסופית לפי defaultInfiniteLight, לכלים אחריהם: סופית
deriveCapacityFromReshimu (Limit _) = power defaultInfiniteLight
deriveCapacityFromReshimu o         = Fin (ordinalRank o)

-- | Divide a Cardinal by an integer (for capacity splitting)
divideCardinal :: Cardinal -> Int -> Cardinal
divideCardinal (Fin n) d = Fin (max 0 (n `div` d))
divideCardinal (Aleph a) _ = Aleph a

-- | Compare Cardinals (≤)
cardinalLE :: Cardinal -> Cardinal -> Bool
cardinalLE (Fin n)   (Fin m)   = n <= m
cardinalLE (Fin _)   (Aleph _) = True
cardinalLE (Aleph _) (Fin _)   = False
cardinalLE (Aleph a) (Aleph b) = a <= b

-- | Greater-than for Cardinals
cardinalGT :: Cardinal -> Cardinal -> Bool
cardinalGT a b = not (cardinalLE a b)

-- | Determine three inner lights for Naran tzelem per Context
determinePnimiNaranTzelem :: Context -> SefirahLevelInfo -> PnimiLights
determinePnimiNaranTzelem (Context src _ _ _) (SefirahLevelInfo lvl) =
  let cSrc      = power src
      oPnimi    = ordinalAdd omega (intToOrdinal lvl)
      -- hierarchic power: נָשָׁמָה > רוּחַ > נֶפֶשׁ
      cNeshama  = attenuatePower cSrc (Aleph 3)
      cRuach    = attenuatePower cNeshama (Aleph 2)
      cNefesh   = attenuatePower cRuach (Aleph 1)
      t         = timestamp src
      srcTag    = source src
      -- first build נשמה then update for רוח ונפש
      l_neshama = Light { power     = cNeshama
                        , structure = oPnimi
                        , category  = Neshama
                        , kind      = Pnimi
                        , source    = srcTag
                        , timestamp = t + 1
                        }
      l_ruach   = l_neshama { power     = cRuach
                            , category  = Ruach
                            , timestamp = t + 2 }
      l_nefesh  = l_neshama { power     = cNefesh
                            , category  = Nefesh
                            , timestamp = t + 3 }
  in PnimiLights l_nefesh l_ruach l_neshama

-- | Determine two surrounding lights (חיה, יחידה) per Context and inner lights
determineMakifChayaTzelem :: Context -> SefirahLevelInfo -> PnimiLights -> MakifLights
determineMakifChayaTzelem (Context src _ _ _) lvlInfo (PnimiLights _ _ nesh) =
  let cNeshama  = power nesh
      cChaya    = nextAleph cNeshama
      cYechida  = nextAleph cChaya
      baseStruct = structure nesh
      oChaya     = Limit [baseStruct]    -- מבנה גבוה מ-נשמה
      oYechida   = Limit [oChaya]        -- מבנה גבוה מ-חיה
      t          = timestamp src
      srcTag     = source src
      l_chaya    = Light { power     = cChaya
                           , structure = oChaya
                           , category  = Chaya
                           , kind      = Makif
                           , source    = srcTag
                           , timestamp = t + 1
                           }
      l_yechida  = l_chaya { power     = cYechida
                           , structure = oYechida
                           , category  = Yechida
                           , timestamp = t + 2 }
  in MakifLights l_chaya l_yechida

-- | Create a three-layered Keli עם קיבולות נגזרות מרשימו
createThreeLayeredKeli
  :: EntityId  -- ^ partzuf identity
  -> Ordinal   -- ^ reshimu structure
  -> Keli      -- ^ initialized Keli
createThreeLayeredKeli eid reshimu =
  let overallCap = deriveCapacityFromReshimu reshimu
      share      = divideCardinal overallCap 3
      layers     = [ KeliLayer Zero share Nothing
                   , KeliLayer (Succ Zero) share Nothing
                   , KeliLayer (Succ (Succ Zero)) share Nothing
                   ]
  in Keli eid overallCap layers Nothing Nothing

-- | Attempt to attire נר"ן into the Keli layers with capacity validation
attireNaranInKeliTzelem
  :: PnimiLights  -- ^ inner lights (nefesh, ruach, neshama)
  -> Keli         -- ^ target Keli
  -> AttireResult -- ^ result (success or broken)
attireNaranInKeliTzelem (PnimiLights nef ruach nesh) k =
  let lights        = [nef, ruach, nesh]
      layers        = keliLayers k
      pairs         = zip lights layers
      violationIdxM = findIndex (\(lt, ly) -> cardinalGT (power lt) (layerCapacity ly)) pairs
  in case violationIdxM of
       Just idx ->
         let brokenLayers = zipWith mkBroken [0..] layers
             brokenKeli   = k { keliLayers = brokenLayers }
             lyr          = layers !! idx
             reason       = "חריגה מקיבולת בשכבה " <> ordinalToText (layerIndex lyr)
         in AttireBroken brokenKeli reason
         where
           mkBroken i ly = if i <= idx then ly { layerAttiredLight = Just (lights !! i) } else ly
       Nothing  -> AttireSuccess $ k { keliLayers = zipWith (\ly lt -> ly { layerAttiredLight = Just lt }) layers lights }

-- | Surround Keli with Makif lights and register Yechida globally
surroundChayaAroundKeliTzelem
  :: MakifLights            -- ^ surrounding lights (chaya, yechida)
  -> Keli                  -- ^ target Keli
  -> (Keli, GlobalEffect)  -- ^ updated Keli and global effect
surroundChayaAroundKeliTzelem (MakifLights c y) k =
  let updated = k { keliMakifChozer = Just c, keliMakifYashar = Just y }
  in (updated, RegisterYechida y (keliIdentity updated))

-- | Initialize Adam Kadmon partzuf vessel from context and sefirah
initializeAdamKadmon
  :: Context          -- ^ context with source infinite light
  -> SefirahLevelInfo -- ^ sefirah level info (1-10)
  -> EntityId         -- ^ identity for the Keli partzuf
  -> Keli
initializeAdamKadmon ctx lvl eid =
  let reshimuStruct = calculateReshimuStructure (sourceLight ctx)
                                     (intToOrdinal (sefirahLevel lvl))
                                     (intToOrdinal (sefirahLevel lvl))
  in createThreeLayeredKeli eid reshimuStruct 

-- | חישוב מרחק התרחקות בין עולם לפרצוף
calcDistanceRetreat :: OlamId -> PartzufId -> Int
calcDistanceRetreat ol p =
  let base = case ol of
        AK       -> 5
        Atzilut  -> 4
        Beriah   -> 3
        Yetzirah -> 2
        Asiyah   -> 1
      partzfs = case ol of
        AK       -> [AkOverall]
        Atzilut  -> atzilutPartzufSequence
        Beriah   -> [BeriahOverall]
        Yetzirah -> [YetzirahOverall]
        Asiyah   -> [AsiyahOverall]
      idx     = fromMaybe 0 (elemIndex p partzfs)
      d       = base - idx
  in max 0 d

-- | Attenuate the source light for next iteration based on retreat distance
performDirectMakifRetreat :: Light -> Int -> Light
performDirectMakifRetreat makif d = attenuateSourceLight makif d

-- | Define the new formation space spec after a Makif Yashar retreat
data SpaceSpec = SpaceSpec
  { spaceRadius     :: Int   -- ^ new radius
  , spaceHasReshimu :: Bool  -- ^ reshimu potential derived
  } deriving (Eq)

instance Show SpaceSpec where
  show (SpaceSpec r h) = "vacated_space_with_reshimu: (radius=" ++ show r ++ ", hasResh=" ++ show h ++ ")"

-- | Generate a new SpaceSpec from the Makif Yashar light and retreat distance
generateSpaceSpec :: Light -> Int -> SpaceSpec
generateSpaceSpec makif d =
  let newStruct = decOrd (structure makif) d
      hasResh = case newStruct of
        Zero -> False
        _    -> True
  in SpaceSpec d hasResh

-- | Attenuate Light by reducing its power and structure
attenuateSourceLight :: Light -> Int -> Light
attenuateSourceLight l d =
  let newPower = case power l of
        Fin n   -> Fin (max 0 (n - d))
        Aleph n -> Aleph (max 0 (n - d))
      newStruct = decOrd (structure l) d
      newTimestamp = timestamp l + 1
  in l { power = newPower, structure = newStruct, timestamp = newTimestamp }

-- | Helper to decrement an Ordinal up to d steps
decOrd :: Ordinal -> Int -> Ordinal
decOrd o 0 = o
decOrd Zero _ = Zero
decOrd (Succ o') n = decOrd o' (n - 1)
decOrd (Limit (x:_)) _ = Limit [x]
decOrd l@(Limit []) _ = l 
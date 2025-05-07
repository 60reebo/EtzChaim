module Engine.Simulation.Hishtalshelut where

import Data.Text (Text)
import Engine.Types.SimulationState (EngineState(..), SimulationState(..), defaultInfiniteLight)
import Engine.Types.LightTypes (Light)
import Engine.Simulation.AkPreparation (Context, SefirahLevelInfo)
import Engine.Types.CoreTypes (Keli)

-- | מצב ראשוני למבנה התפתחות (הִשְׁתַּלְּשֶׁלוּת)
data HishtalshelutState = HishtalshelutState
  { space         :: Int        -- ^ רדיוס החלל הפנוי
  , kavLight      :: Light      -- ^ אור הקו או infinite במקרה אחר
  , structureTree :: [Keli]     -- ^ עץ הכלים (ריק בשלב זה)
  , events        :: [Text]     -- ^ אירועים ראשוניים
  } deriving (Show, Eq)

-- | אתחול HishtalshelutState מתוך EngineState קיים
initializeHishtalshelutStructure
  :: Context -> SefirahLevelInfo -> EngineState -> HishtalshelutState
initializeHishtalshelutStructure _ctx _lvl st =
  let radius = case simulationState st of
        TzimtzumState r _ _ _ (Just _) _ -> r
        _                                -> 0
      kavLight = case simulationState st of
        TzimtzumState _ _ _ _ (Just kl) _ -> kl
        _                                -> defaultInfiniteLight
  in HishtalshelutState radius kavLight [] (simulationEvents st) 
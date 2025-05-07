{-# LANGUAGE DeriveGeneric #-}
module Engine.Types.LightTypes where

import Data.Text (Text)
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

-- | Cardinal type: finite and aleph-indexed infinities
data Cardinal = Fin Int | Aleph Int
  deriving (Show, Eq, Generic)

instance ToJSON Cardinal
instance FromJSON Cardinal

-- | Ordinal type: zero, successor, and limit
data Ordinal = Zero | Succ Ordinal | Limit [Ordinal]
  deriving (Eq, Generic)

instance Show Ordinal where
  show Zero        = "0"
  show (Succ o)    = "S(" ++ show o ++ ")"
  show (Limit xs)  = case xs of
                       (x:_) -> "ω+" ++ show x
                       []    -> "ω"

instance ToJSON Ordinal
instance FromJSON Ordinal

-- | Categories of Light
data LightCategory
  = UndifferentiatedLightCategory
  | Nefesh
  | Ruach
  | Neshama
  | Chaya
  | Yechida
  deriving (Show, Eq, Generic)

instance ToJSON LightCategory
instance FromJSON LightCategory

-- | Kind of Light: Pnimi or Makif
data LightKind = Pnimi | Makif
  deriving (Show, Eq, Generic)

instance ToJSON LightKind
instance FromJSON LightKind

-- | Core Light type
data Light = Light
  { power     :: Cardinal
  , structure :: Ordinal
  , category  :: LightCategory
  , kind      :: LightKind
  , source    :: Text
  , timestamp :: Int
  } deriving (Show, Eq, Generic)

instance ToJSON Light
instance FromJSON Light

-- | Factor for attenuating light
data AttenuationFactor = AttenuationFactor
  { powerFactor     :: Cardinal                    -- ^ how much to reduce power
  , structureFactor :: Ordinal                     -- ^ how much to reduce structure
  , qualityChange   :: LightCategory -> LightCategory -- ^ how to change the quality/category
  , preserveKind    :: Bool                          -- ^ should keep the kind or allow change
  } deriving (Generic)

-- Note: We omit JSON instances for AttenuationFactor because it includes a function 
{-# LANGUAGE DeriveGeneric #-}
module Engine.Types.CoreTypes where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON, ToJSONKey, FromJSONKey)
import Engine.Types.LightTypes (Ordinal, Light, Cardinal)
import Engine.Types.BasicTypes (EntityId)
import Data.Text (Text)
import qualified Data.Map.Strict as Map

-- | רמות האור (נרנח"י)
data LightLevel
  = Nefesh
  | Ruach
  | Neshama
  | Chaya
  | Yechida
  deriving (Show, Eq, Generic)

instance ToJSON LightLevel
instance FromJSON LightLevel

-- | מצבי אור: פנימי או מקיף
data LightMode = Pnimi | Makif
  deriving (Show, Eq, Generic)

instance ToJSON LightMode
instance FromJSON LightMode

-- | אות צלם (א', ב', ג')
data TzelemLetter = AlephLetter | BetLetter | GimelLetter
  deriving (Show, Eq, Generic)

instance ToJSON TzelemLetter
instance FromJSON TzelemLetter

-- | מצב כלי: חדש, לבוש או שבור
data KeliState = Fresh | Attired | Broken
  deriving (Show, Eq, Generic)

instance ToJSON KeliState
instance FromJSON KeliState

-- | רשימו ספציפיקציה: מבנה ואור המקור
data ReshimuSpec = ReshimuSpec
  { inheritedStructure :: Ordinal
  , originLight        :: Light
  } deriving (Show, Eq, Generic)

instance ToJSON ReshimuSpec
instance FromJSON ReshimuSpec

-- | עולמות קבליים
data OlamId
  = AK       -- ^ Adam Kadmon world
  | Atzilut  -- ^ world of Atzilut
  | Beriah   -- ^ world of Beriah
  | Yetzirah -- ^ world of Yetzirah
  | Asiyah   -- ^ world of Assiah
  deriving (Show, Eq, Ord, Generic)

instance ToJSON OlamId
instance FromJSON OlamId
instance ToJSONKey OlamId
instance FromJSONKey OlamId

-- | מזהי פרצופים (אצילות/אבי"ע)
data PartzufId
  = AkOverall    -- ^ Adam Kadmon overall
  | Atik         -- ^ Partzuf Atik
  | ArichAnpin   -- ^ Partzuf Arich Anpin
  | Abba         -- ^ Partzuf Abba
  | Imma         -- ^ Partzuf Imma
  | ZONMale      -- ^ Zeir Anpin Male
  | ZONFemale    -- ^ Zeir Anpin Female
  | BeriahOverall    -- ^ simulation placeholder for all of Beriah
  | YetzirahOverall  -- ^ simulation placeholder for all of Yetzirah
  | AsiyahOverall    -- ^ simulation placeholder for all of Assiah
  deriving (Show, Eq, Ord, Generic)

instance ToJSON PartzufId
instance FromJSON PartzufId
instance ToJSONKey PartzufId
instance FromJSONKey PartzufId

-- | רצף פרצופים סטנדרטי באצילות
atzilutPartzufSequence :: [PartzufId]
atzilutPartzufSequence = [Atik, ArichAnpin, Abba, Imma, ZONMale, ZONFemale]

-- | מזהי ספירה (כתר=1 .. מלכות=10)
data SefirahId
  = Keter | Hokhmah | Binah | Hesed | Gevurah | Tiferet | Netzah | Hod | Yesod | Malkhut
  deriving (Show, Eq, Ord, Enum, Generic)

instance ToJSON SefirahId
instance FromJSON SefirahId
instance ToJSONKey SefirahId
instance FromJSONKey SefirahId

-- | זהות מלאה של יחידת ספירה: עולם ← פרצוף ← ספירה
data FullIdentity = FullIdentity
  { fiOlam    :: OlamId
  , fiPartzuf :: PartzufId
  , fiSefirah :: SefirahId
  } deriving (Show, Eq, Ord, Generic)

instance ToJSON FullIdentity
instance FromJSON FullIdentity

-- | חיבור (קשר) בין שתי יחידות ספירה
data Connection = Connection
  { connFrom :: FullIdentity
  , connTo   :: FullIdentity
  } deriving (Show, Eq, Ord, Generic)

instance ToJSON Connection
instance FromJSON Connection

-- | יחידת ספירה: תוצאת יצירת העיגול והיושר
data SefirahUnit = SefirahUnit
  { suIdentity        :: FullIdentity
  , suIgulKeli        :: Maybe Keli
  , suIgulInnerLight  :: Maybe PnimiLights
  , suIgulOuterLight  :: Maybe MakifLights
  , suYosherKeli      :: Keli
  , suGeneratedEffect :: Maybe GlobalEffect
  , suProcessingLogs  :: [Text]
  , suConnections     :: [Connection]
  } deriving (Show, Eq, Generic)

instance ToJSON SefirahUnit
instance FromJSON SefirahUnit

-- | המבנה ההיררכי המלא: עולם → פרצוף → ספירה → יחידה
type HierarchicalStructure = Map.Map OlamId (Map.Map PartzufId (Map.Map SefirahId SefirahUnit))

-- | שלבי Igul ו-Yosher: טיפוסים וכלים
-- | אורות פנימיים בשלושת שכבות הנר"ן
data PnimiLights = PnimiLights
  { nefeshLight  :: Light
  , ruachLight   :: Light
  , neshamaLight :: Light
  } deriving (Show, Eq, Generic)

instance ToJSON PnimiLights
instance FromJSON PnimiLights

-- | אורות חיה ויחידה מסביב
data MakifLights = MakifLights
  { chayaLight   :: Light
  , yechidaLight :: Light
  } deriving (Show, Eq, Generic)

instance ToJSON MakifLights
instance FromJSON MakifLights

-- | כלי בשכבת נע"ן
data KeliLayer = KeliLayer
  { layerIndex        :: Ordinal
  , layerCapacity     :: Cardinal
  , layerAttiredLight :: Maybe Light
  } deriving (Show, Eq, Generic)

instance ToJSON KeliLayer
instance FromJSON KeliLayer

-- | כלי תלת-שכבתי
data Keli = Keli
  { keliIdentity        :: EntityId
  , keliOverallCapacity :: Cardinal
  , keliLayers          :: [KeliLayer]
  , keliMakifChozer     :: Maybe Light
  , keliMakifYashar     :: Maybe Light
  } deriving (Show, Eq, Generic)

instance ToJSON Keli
instance FromJSON Keli

-- | תוצאת חבישת הנר"ן: הצלחה או שבירה עם סיבה
data AttireResult
  = AttireSuccess Keli
  | AttireBroken  Keli Text
  deriving (Show, Eq, Generic)

instance ToJSON AttireResult
instance FromJSON AttireResult

-- | אפקט גלובלי שנוצר בסביבת הסימולציה
data GlobalEffect
  = RegisterYechida Light EntityId
  | NoEffect
  deriving (Show, Eq, Generic)

instance ToJSON GlobalEffect
instance FromJSON GlobalEffect 
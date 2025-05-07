module Engine.Kabbalah.LightAlgebra
  ( plusLight
  , timesLight
  , attenuateLight
  ) where

import Data.Text (append)
import Engine.Types.LightTypes (Light(..), AttenuationFactor)
import Engine.Math.Ordinal (maxO)
import Engine.Math.Cardinal (plusCardinal, timesCardinal)
import Engine.Simulation.Kav (attenuate)

-- | חיבור/מיזוג אור: מחבר כוח ומבנה מירבי, משאיר קטגוריה ומצב.
plusLight :: Light -> Light -> Light
plusLight l1 l2 = l1 { power     = plusCardinal (power l1) (power l2)
                     , structure = maxO     (structure l1) (structure l2)
                     , source    = source l1 `append` "+" `append` source l2
                     , timestamp = max (timestamp l1) (timestamp l2)
                     }

-- | כפל/אינטראקציה של אור: כפל כוח, מבנה מירבי.
timesLight :: Light -> Light -> Light
timesLight l1 l2 = l1 { power     = timesCardinal (power l1) (power l2)
                       , structure = maxO        (structure l1) (structure l2)
                       , source    = source l1 `append` "*" `append` source l2
                       , timestamp = max (timestamp l1) (timestamp l2)
                       }

-- | החלשת אור לפי AttenuationFactor
attenuateLight :: Light -> AttenuationFactor -> Light
attenuateLight = attenuate 
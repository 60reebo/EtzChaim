module Engine.Math.Ordinal
  ( addOrdinal
  , multOrdinal
  , decOrdLE
  , maxO
  ) where

import Engine.Types.LightTypes (Ordinal(..))
import Engine.Simulation.Kav (ordinalRank, ordinalStronger)

-- | חיבור אורדינלי אינדוקטיבי
addOrdinal :: Ordinal -> Ordinal -> Ordinal
addOrdinal Zero b       = b
addOrdinal (Succ a) b   = Succ (addOrdinal a b)
addOrdinal (Limit xs) b = Limit (map (`addOrdinal` b) xs)

-- | כפל אורדינלי אינדוקטיבי
multOrdinal :: Ordinal -> Ordinal -> Ordinal
multOrdinal Zero _       = Zero
multOrdinal (Succ a) b   = addOrdinal b (multOrdinal a b)
multOrdinal (Limit xs) b = Limit (map (`multOrdinal` b) xs)

-- | השוואת אורדינלים לפי ordinalRank, גיבוי ב־Bool
decOrdLE :: Ordinal -> Ordinal -> Bool
decOrdLE a b = ordinalRank a <= ordinalRank b

-- | מקסימום אורדינלי לפי ordinalStronger
maxO :: Ordinal -> Ordinal -> Ordinal
maxO a b = if ordinalStronger a b then a else b 
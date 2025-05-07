module Engine.Math.Cardinal
  ( plusCardinal
  , timesCardinal
  ) where

import Engine.Types.LightTypes (Cardinal(..))

-- | חיבור קרדינל: finite sum, עבור Aleph הגדר כמקסימום
plusCardinal :: Cardinal -> Cardinal -> Cardinal
plusCardinal (Aleph a) (Aleph b) = Aleph (max a b)
plusCardinal (Aleph a) _         = Aleph a
plusCardinal _         (Aleph b) = Aleph b
plusCardinal (Fin x)   (Fin y)   = Fin (x + y)

-- | כפל קרדינל: finite multiplication, Aleph נשמר כ-Aleph
timesCardinal :: Cardinal -> Cardinal -> Cardinal
timesCardinal (Aleph a) _       = Aleph a
timesCardinal _       (Aleph b) = Aleph b
timesCardinal (Fin x) (Fin y)   = Fin (x * y) 
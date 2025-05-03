--------------------------------------------------
-- SoulLevel (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Light.SoulLevel where

-- | SoulLevel (רמת נשמה):
-- ייצוג דרגות הנשמה/חיות במערכת הקבלית.


data SoulLevel : Set where
  Nefesh  : SoulLevel
  Ruach   : SoulLevel
  Neshama : SoulLevel
  Chaya   : SoulLevel
  Yechida : SoulLevel

--------------------------------------------------
-- SefiraOrder (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Worlds.SefiraOrder where

-- סדר הספירות (כמעגלים או כיושר)
data SefiraOrder : Set where
  Igulim : SefiraOrder  -- עיגולים
  Yosher : SefiraOrder  -- יושר

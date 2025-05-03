--------------------------------------------------
-- InternalZONPresence (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Partzuf.InternalZONPresence where

data InternalZONPresence : Set where
  NoInternalZON  : InternalZONPresence
  HasInternalZON : InternalZONPresence

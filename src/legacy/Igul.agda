module Hishtalshelut.Domain.Worlds.Igul where

-- | Igul (עיגול, גלגל):
-- ייצוג עיגולים/גלגלים במערכת ההשתלשלות, כמבנה קבלי גיאומטרי.

open import Data.Nat using (ℕ)


-- עיגול (גלגל)

record Igul : Set where
  field
    center : ℕ
    radius : ℕ
    level  : ℕ

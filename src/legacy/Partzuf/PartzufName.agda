--------------------------------------------------
-- PartzufName (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Partzuf.PartzufName where

-- | PartzufName (שמות פרצופים):
-- ייצוג שמות הפרצופים המרכזיים בקבלה: אריך אנפין, אבא, אמא, ז"א, נוקבא.


data PartzufName : Set where
  AA    : PartzufName
  Abba  : PartzufName
  Ima   : PartzufName
  ZA    : PartzufName
  Nukva : PartzufName

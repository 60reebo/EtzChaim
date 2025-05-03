--------------------------------------------------
-- All (Domain Layer): Re-exports all domain types for convenience
--
-- דוקומנטציה:
-- קובץ זה מרכז את כל טיפוסי הדומיין המרכזיים של מערכת ההשתלשלות.
-- כל מודול מייצג שכבה/מושג קבלי עצמאי (אור, כלים, עולמות, פרצופים, כללי וכו').
-- אין ערבוב בין שכבות, וכל טיפוס מוגדר רק במקום אחד ומיובא מכאן לשימוש חיצוני.
-- יש לעדכן קובץ זה בכל הוספת טיפוס מרכזי חדש.
--
-- עקרונות:
--   * מודולריות והפרדה בין שכבות
--   * ייבוא מרכזי לכל המערכת
--   * מניעת כפילויות והסתרת טיפוסים ישנים
--
-- דוגמאות שימוש:
--   import Hishtalshelut.Domain.All
--   open Hishtalshelut.Domain.All
--------------------------------------------------
--------------------------------------------------
-- All (Domain Layer): Re-exports all domain types by topic
--------------------------------------------------
module Hishtalshelut.Domain.All where

-- Light
open import Hishtalshelut.Domain.Light.LightLevel public
open import Hishtalshelut.Domain.Light.LightLevelStatus public
open import Hishtalshelut.Domain.Light.SoulLevel public
open import Hishtalshelut.Domain.Light.OhrPnimiMakif public
open import Hishtalshelut.Domain.Light.Spark public

-- Sefirah
open import Hishtalshelut.Domain.Sefirah.Sefirah public
open import Hishtalshelut.Domain.Sefirah.TNTA public
open import Hishtalshelut.Domain.Sefirah.DivineName public

-- Kelim
open import Hishtalshelut.Domain.Kelim.Capacity public
open import Hishtalshelut.Domain.Kelim.KeliSubstance public

-- Worlds - Akudim & Nekudim
open import Hishtalshelut.Domain.Worlds.Akudim.AkudimTypes public
open import Hishtalshelut.Domain.Worlds.Nekudim.NekudimTypes public

-- Partzuf
open import Hishtalshelut.Domain.Partzuf.PartzufName public
open import Hishtalshelut.Domain.Partzuf.InternalZONPresence public
open import Hishtalshelut.Domain.Partzuf.PanimAchorAspect public
open import Hishtalshelut.Domain.Partzuf.StructureLevel public
open import Hishtalshelut.Domain.Partzuf.MvMPhase public
-- Removed: open import Hishtalshelut.Domain.Partzuf.Side public

-- Worlds
open import Hishtalshelut.Domain.Worlds.EinSof public
open import Hishtalshelut.Domain.Worlds.Challal public
open import Hishtalshelut.Domain.Worlds.Igul public
open import Hishtalshelut.Domain.Worlds.Kav public
open import Hishtalshelut.Domain.Worlds.KavIgulimAdamKadmon public
open import Hishtalshelut.Domain.Worlds.TikkunEffort public

-- Zivug (זיווג דהכאה)
open import Hishtalshelut.Domain.Zivug.MayinNukvin public
open import Hishtalshelut.Domain.Zivug.Shefa public

-- General
-- Removed: open import Hishtalshelut.Domain.General.Side public hiding (Side)
open import Hishtalshelut.Domain.General.Orientation public hiding (Side)
open import Hishtalshelut.Domain.General.HeadMiddleEnd public
open import Hishtalshelut.Domain.General.Utils public

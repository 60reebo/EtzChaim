module Hishtalshelut.Engine.Geometry3D where

open import Data.Bool        using (Bool; if_then_else_)
open import Agda.Builtin.String using (String)
open import Data.Nat.Show    using (show)
open import Data.Nat         using (ℕ)
open import Data.String.Base using (_++_)

-- | Map purity to grayscale color: (r,g,b) = (p,p,p)
colorForPurity : ℕ → String
colorForPurity p = "rgb(" ++ show p ++ "," ++ show p ++ "," ++ show p ++ ")"

-- | 3D vector
record Vec3 : Set where
  constructor _·_
  field x y z : ℕ
open Vec3 public

-- | Geometry commands for rendering
data GeometryStep : Set where
  DrawLine   : Vec3 → Vec3 → GeometryStep
  DrawSphere : Vec3 → ℕ → Bool → GeometryStep

-- | Convert GeometryStep to a readable string
geometryStepToText : GeometryStep → String
geometryStepToText (DrawLine s e) =
  let sx = show (Vec3.x s)
      sy = show (Vec3.y s)
      sz = show (Vec3.z s)
      ex = show (Vec3.x e)
      ey = show (Vec3.y e)
      ez = show (Vec3.z e)
      cs = "(" ++ sx ++ "," ++ sy ++ "," ++ sz ++ ")"
      ce = "(" ++ ex ++ "," ++ ey ++ "," ++ ez ++ ")"
  in "DrawLine from " ++ cs ++ " to " ++ ce
geometryStepToText (DrawSphere c r m) =
  let xS = show (Vec3.x c)
      yS = show (Vec3.y c)
      zS = show (Vec3.z c)
      cr = "(" ++ xS ++ "," ++ yS ++ "," ++ zS ++ ")"
      t  = if_then_else_ m "Makif" "Inner"
      color = colorForPurity r
  in "DrawSphere center=" ++ cr ++ " radius=" ++ show r ++ " type=" ++ t ++ " color=" ++ color

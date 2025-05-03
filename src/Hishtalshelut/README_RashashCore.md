# Rashash Core Library

This directory contains the core Agda modules for the Rashash system, organized by domain, names, and coordinates.

## Modules

- **Domain/Core.agda**: foundational types (LightLevel, Spark, Sefirah, SoulLevel, TNTA, DivineName, etc.)
- **Domain/Rashash/Names/**:
  - **Partzuf.agda**: definitions of `PartzufName` and boolean equality
  - **Sefirah.agda**: definitions of `SefirahName` and boolean equality
  - **BodyPart.agda**: definitions of `BodyPart` and boolean equality
  - **World.agda**: definitions of `OlamName` and boolean equality
  - **ShemOhr.agda**: definitions of `ShemOhr` and boolean equality
- **Domain/Rashash/Coordinate/Coordinate.agda**: the `RashashCoordinate` record and propositional equality

Place this README at the root of the `src/Hishtalshelut` directory to describe the core Domain modules.

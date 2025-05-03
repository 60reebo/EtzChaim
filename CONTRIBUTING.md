# Contributing to EtzChaim

## Development setup
- Prerequisites:
  - Agda 2.7.0.1
  - standard-library (see .agda-lib)
- Install:
  ```bash
  sudo apt-get update
  sudo apt-get install -y agda agda-stdlib
  ```
- Compile:
  ```bash
  agda --library-file .agda-lib -i src -i .agda/defaults -c $(find src -name "*.agda")
  ```
- Run tests:
  ```bash
  agda --library-file .agda-lib -i src -i .agda/defaults TestPattern.agda EqDecTest.agda
  ```

## Code style
- Add module-level docstring at top of each `.agda` file:
  ```agda
  -- | Short description of the module's purpose
  module Path.To.Module where
  ```
- File naming: CamelCase.agda matching module path.
- Directory structure: follow `src/Hishtalshelut/...`

## Pull requests
- Branch naming: `feature/...`, `fix/...`, `doc/...`
- Commit messages: use imperative tense, reference issues.

## CI
- GitHub Actions configured at `.github/workflows/ci.yml`

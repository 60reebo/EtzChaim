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

## Review Process
- כל שינוי בקוד קיים צריך להיות מוגש דרך Pull Request ובתוכו:
  - PR נפתח מ־branch נפרד, אין לדחוף ישירות ל־`main`.
  - השינויים ייבדקו ע"י לפחות בעל הרשאות (code owner) ורצוי על ידי מפתח נוסף.
  - הבדיקה תכלול בדיקת נכונות מחקרית, קונסיסטנטיות מתמטית, תאימות לסגנון הקוד ותיעוד.
- כדי לממש אכיפה אוטומטית, מוגדר `.github/CODEOWNERS` עם רשימת ה־code owners.
- לאחר אישור הבקשה, יש למזג באמצעות 'Squash and merge' או 'Merge commit' בהתאם למדיניות המאגר.

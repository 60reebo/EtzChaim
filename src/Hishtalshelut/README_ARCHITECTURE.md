# Hishtalshelut Project: Layered Architecture Overview

## System Structure & Layered Architecture

The project is organized into **five precise architectural layers**, each with a clear responsibility and import direction. This structure ensures modularity, testability, and clarity.

---

## The Five Core Layers

### 1. Domain
- **Purpose:** Defines the core data types, records, enums, and structures representing the conceptual world (e.g., Sefirah, World, LightLevel).
- **Contains:** Only pure type/data definitions, no logic or computation.
- **Imports:** None (the root layer).

---

### 2. State
- **Purpose:** Represents the system's state, including world states, light states, and all dynamic data structures.
- **Contains:** Data structures that describe the current configuration or situation of the system, but no business logic.
- **Imports:** May import Domain.

---

### 3. Rules
- **Purpose:** Encapsulates the core rules and laws of the model. This includes both dynamic rules (e.g., transitions, laws of simulation) and pure analysis/investigation rules.
- **Contains:**
  - Core model rules (e.g., tzimtzum, shevira, tikkun).
  - **Analysis/Investigation sub-layer:** Pure, stateless functions for checking, analyzing, and investigating the domain/state (e.g., attribute manifestation, world order, timing analysis).
- **Imports:** May import Domain and State (and Lib, see below).
- **Sub-directory:** `Rules/Analysis/` for all pure investigation/analysis rules.

---

### 4. Engine
- **Purpose:** Implements simulation logic and state transitions. Orchestrates the flow of the system according to the rules.
- **Contains:** Simulation engines, state machines, process logic.
- **Imports:** May import Domain, State, Rules (and Lib).

---

### 5. Runtime
- **Purpose:** Top-level orchestration, running full simulations, user interfaces, and scenario management.
- **Contains:** Main entry points, scenario scripts, and simulation runners.
- **Imports:** May import all previous layers.

---

## Utility Layer: Lib
- **Purpose:** Provides generic, reusable utility functions (e.g., equality, list operations, map updates) that are not tied to a specific domain or business logic.
- **Placement:** Lib is not a core layer, but a cross-cutting utility library available to all layers.
- **Imports:** May only import Agda base libraries or Domain.
- **Usage:** Any layer (Domain, State, Rules, Engine, Runtime) may import Lib as needed.

### Import Diagram

```
Lib
 ↑   ↑   ↑    ↑    ↑
 |   |   |    |    |
Domain → State → Rules → Engine → Runtime
```
- **Lib** sits to the side, available to all layers, but not part of the main architectural chain.
- **Strict one-way imports:** Higher layers may import lower layers, but not vice versa.
- **Never import upward:** Domain never imports State/Rules/Engine/Runtime, etc.
- **Analysis/Investigation rules** (under `Rules/Analysis/`) are part of the Rules layer but separated for clarity.

---

## Example Directory Structure

```
src/Hishtalshelut/
  Domain/
    Core.agda
    ...
  State/
    WorldState.agda
    ...
  Lib/
    EqDec.agda
    ...
  Rules/
    Core.agda
    Analysis/
      AttributeManifestation.agda
      WorldOrder.agda
      WorldTimeAnalysis.agda
      Helpers.agda
  Engine/
    Simulation.agda
    ...
  Runtime/
    Main.agda
    ...
```

---

## How to Use the Layers
- **Add new types** to `Domain/`.
- **Add state representations** to `State/`.
- **Add generic helpers** to `Lib/`.
- **Add model rules or pure investigation/analysis** to `Rules/` or `Rules/Analysis/`.
- **Add simulation logic** to `Engine/`.
- **Add scenario runners or main scripts** to `Runtime/`.

---

## Rationale
- **Clarity:** Each layer has a single responsibility.
- **Maintainability:** Changes in one layer do not ripple unnecessarily to others.
- **Testability:** Pure functions in Rules/Analysis are easy to test and reason about.
- **Extensibility:** New rules, analyses, or simulations can be added without breaking the architecture.
- **Lib**: Keeps utility code separate and reusable.

---

## Hebrew Summary (תקציר בעברית)
- המערכת בנויה מחמש שכבות מדויקות:
  1. **Domain** – טיפוסים ומבני נתונים בלבד.
  2. **State** – ייצוג מצב המערכת (עולמות, אורות, וכו').
  3. **Rules** – חוקי המודל (כולל חקירות טהורות בתיקיית Analysis).
  4. **Engine** – מנועי סימולציה ולוגיקת תהליכים.
  5. **Runtime** – תסריטים והרצה כוללת.
- **Lib** – שכבת עזר חוצת שכבות, זמינה לכל השכבות אך לא שכבת מודל עיקרית.
- כל שכבה מייבאת רק שכבות נמוכות ממנה. אין תלות הפוכה.
- כל חקירה/בדיקה טהורה נמצאת ב־Rules/Analysis.

---

לשאלות, הרחבות או דוגמאות – ראה את הקבצים בתיקיות המתאימות או פנה למפתחי המערכת.

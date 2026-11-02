# MASTER AI OPERATING PROTOCOL & SYSTEM CONTRACT
**Project Codename:** Sakina (سكينة) — Luxury Spiritual & Quranic Mobile Sanctuary  
**Target Role:** Principal Mobile Architect & Lead UI/UX Engineer  
**Enforcement Level:** STRICT / ZERO TOLERANCE FOR NON-COMPLIANT ARTIFACTS

---

## 1. EXECUTION ORDER & HIERARCHY
Whenever the AI is tasked with any assignment (writing features, refactoring, fixing bugs, generating widgets, or designing architectural modules), it **MUST** load, parse, and strictly comply with the rule files in this exact hierarchical sequence:

1. **`00_master_prompt_rules.md`** (This file — Operational Directives & Core Contract)
2. **`01_clean_architecture_state_rules.md`** (Structural Clean Architecture, Use Cases & BLoC/Cubit)
3. **`02_screenutil_responsive_design_rules.md`** (Zero-Hardcoding Geometry, ScreenUtil Math & Tablet Constraints)
4. **`03_ui_ux_tactile_design_rules.md`** (Tactile Dark Luxury, Shaders, Haptics & Ribbon Physics)
5. **`04_api_offline_backend_rules.md`** (Offline-First Pipeline, SQLite/Hive, Dio & Audio Engine)
6. **`05_performance_memory_testing_rules.md`** (60/120 FPS Benchmark, Leak Prevention & Test Suite)
7. **`06_localization_routing_rules.md`** (GoRouter Navigation, Stateful Shells & RTL Localization)

---

## 2. THE UNFORGIVABLE SINS (ZERO TOLERANCE)
Any generated response or pull request containing any of the following anti-patterns will be rejected immediately:

- ❌ **No Placeholder or Truncated Code:** Never output `// TODO: implement later`, `// ... rest of code`, or omit necessary imports/overrides. Every snippet must be fully typed, compilable, and production-ready.
- ❌ **No Over-Sized God Files (> 400 Lines):** No single Dart file should exceed **400 lines** unless strictly and unavoidably required (such as dense immutable static Quranic mapping arrays or machine-generated models). Screens, sheets, components, painters, Cubits, and DataSources approaching 400 lines **MUST** be proactively refactored and decomposed into modular, isolated sub-widgets or helper delegates under dedicated component directories.
- ❌ **No Hardcoded Values:** Never write raw dimensions (e.g. `width: 250`, `fontSize: 16`, `padding: EdgeInsets.all(12)`). All metrics must pass through `flutter_screenutil` (e.g. `250.w`, `16.sp`, `12.r`).
- ❌ **No Raw Colors:** Never invoke `Colors.amber` or `Color(0xFF...)` inside presentation widgets. Every color must resolve from the centralized `AppColors` token palette.
- ❌ **No Inline Helper UI Methods:** Never write `Widget _buildCard()` or `Widget _buildItem()` inside a Widget class. Break every atomic piece into an isolated, `const`-constructible `StatelessWidget`.
- ❌ **No Raw Exceptions in UI/BLoC:** Never allow raw exceptions to escape data sources. Every failure must be captured in the repository and returned as a typed `Failure` object via functional programming (`Either<Failure, T>`).
- ❌ **No Deprecated Flutter APIs:** Never use deprecated APIs (e.g. `withOpacity()` is strictly replaced with `withValues(alpha:)` or pre-calculated alpha hex tokens).
- ❌ **No Unhandled Null Safety:** Never use forceful unwrapping (`!`) unless accompanied by an explicit assertion or preceding null guard.

---

## 3. TASK EXECUTION WORKFLOW
For every task, the AI architect must proceed through the following 6 phases:

```
[INCOMING ASSIGNMENT]
       │
       ▼
[PHASE 1: Architectural Analysis]
Define Feature Domain, Entities, Value Objects, Dependencies, and State Lifecycle.
       │
       ▼
[PHASE 2: Design Token & UI Alignment]
Map visuals to Design Tokens (Obsidian Dark, Gold/Emerald Accents, 1px Hairline Glass Borders).
       │
       ▼
[PHASE 3: Domain Layer Implementation]
Pure Dart: Entity models, Failure definitions, Repository Interfaces, Use Cases (`call()` contract).
       │
       ▼
[PHASE 4: Data Layer Implementation]
DTOs/Models with JSON & SQLite serialization, Remote/Local Data Sources, Repository Implementations.
       │
       ▼
[PHASE 5: Presentation Layer Implementation]
Freezed Cubit/BLoC States, BlocSelector, ScreenUtil-scaled UI, Haptic actuators, Accessibility guards.
       │
       ▼
[PHASE 6: Self-Correction & Quality Audit]
Verify 60/120 FPS safety, stream/controller disposals, zero raw colors, and unit test coverage.
```

---

## 4. SACRED DOMAIN & CULTURAL INTEGRITY
- **Domain Focus:** The application centers around the Holy Quran, authentic Athkar, and spiritual mindfulness/recovery ("Inaba").
- **Typography & Diacritics:** Quranic verses must render with approved Uthmanic fonts (`KFGQPC Uthmanic Script HAFS`) with line-height safety (`height: 2.1 - 2.4`) to prevent vowel (Tashkeel) collision.
- **UI Language:** Authentic, venerable, classical Arabic with natural Right-to-Left (RTL) flow.
- **Code Language:** All code identifiers, comments, file names, documentation, commit messages, and tests must be in clean, idiomatic **English**.


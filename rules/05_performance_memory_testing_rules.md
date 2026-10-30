# PERFORMANCE, MEMORY & CODE AUDIT SPECIFICATION
**Frame Budget:** 16.6ms per frame (60fps) / 8.3ms per frame (120fps ProMotion)  
**Memory Cap:** Maximum heap footprint < 120MB during active audio streaming  
**Test Standard:** 100% Coverage on Domain Use Cases & Presentation Cubits

---

## 1. WIDGET REBUILD MITIGATION RULES
- **The Const Mandate:** Every constructor where parameters are compile-time constants **MUST** be declared with `const`.
- **Selector Scoping:** Never consume an entire BLoC state if the widget only cares about one field. Use `BlocSelector`:
  ```dart
  // CORRECT: Only rebuilds when currentPage changes
  BlocSelector<QuranCubit, QuranState, int>(
    selector: (state) => state.currentPage,
    builder: (context, currentPage) => PageIndicator(page: currentPage),
  );

  // FORBIDDEN: Rebuilds on audio progress, volume, or translation changes
  BlocBuilder<QuranCubit, QuranState>(
    builder: (context, state) => PageIndicator(page: state.currentPage),
  );
  ```
- **List & Scroll Determinism:** All Quran verse lists, Surah directories, and Reciter catalogs must use `ListView.builder` or `CustomScrollView` with `SliverList` and explicit `itemExtent` or `prototypeItem` for deterministic scroll physics without layout recalculations.
- **Repaint Boundaries:** Wrap computationally intensive widgets (e.g. animated audio waveforms, custom page canvas overlays) in `RepaintBoundary` to prevent raster repainting of the entire screen.

---

## 2. RESOURCE DISPOSAL AUDIT
Every controller, stream subscription, and animation ticker must be explicitly released inside the state's `dispose()`:

```dart
@override
void dispose() {
  _scrollController.dispose();
  _tabController.dispose();
  _pageAnimationController.dispose();
  _streamSubscription.cancel();
  super.dispose();
}
```

---

## 3. SHADER & GPU RENDERING OPTIMIZATION
- **SaveLayer Prohibition:** Avoid using `Opacity` widget directly over large subtrees as it triggers expensive offscreen GPU render buffers (`saveLayer`). Render colors directly with alpha channels (e.g., `Color(0x33D4AF37)` or `withValues(alpha: ...)`).
- **BackdropFilter Restraint:** Limit blurred glass cards to no more than 3 visible instances simultaneously on screen. On budget devices, fallback to solid translucent container (`AppColors.carbonSlate`).

---

## 4. UNIT & WIDGET TEST REQUIREMENTS
Every single Use Case and Cubit must be accompanied by automated tests:
- **Use Case Test:** Test success pathway (`Right`) and failure pathway (`Left`) using `mocktail`:
  ```dart
  test('should return list of surahs when repository succeeds', () async {
    when(() => mockRepository.getSurahs())
        .thenAnswer((_) async => const Right(tSurahsList));

    final result = await useCase(const NoParams());

    expect(result, const Right(tSurahsList));
    verify(() => mockRepository.getSurahs()).called(1);
  });
  ```
- **Cubit Test:** Use `bloc_test` to verify deterministic state emission sequences:
  ```dart
  blocTest<QuranCubit, QuranState>(
    'emits [Loading, Loaded] when Surahs are fetched successfully',
    build: () {
      when(() => mockGetSurahsUseCase(any()))
          .thenAnswer((_) async => const Right(tSurahsList));
      return quranCubit;
    },
    act: (cubit) => cubit.loadSurahs(),
    expect: () => [
      const QuranState.loading(),
      const QuranState.loaded(surahs: tSurahsList),
    ],
  );
  ```


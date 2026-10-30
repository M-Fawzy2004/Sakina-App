# LOCALIZATION, RTL & ROUTING ARCHITECTURE SPECIFICATION
**Routing Engine:** `go_router` (Declarative, Type-Safe, Deep-Link Ready)  
**Localization Framework:** `flutter_localizations` + `intl` (.arb generation)  
**Primary Language:** Arabic (`ar`) with native Right-To-Left (RTL) semantics  
**Secondary Language:** English (`en`)

---

## 1. DECLARATIVE ROUTING ARCHITECTURE (`go_router`)

### Bottom Navigation with `StatefulShellRoute`
The core application navigation (Quran, Audio/Reciters, Inaba Refuge, Bookmarks, Settings) must use `StatefulShellRoute.indexedStack` to preserve the user's scroll position, audio playback state, and page cache when switching tabs:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.quran,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffoldShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.quran,
              builder: (context, state) => const QuranIndexScreen(),
              routes: [
                GoRoute(
                  path: '${AppRoutes.surah}/:id',
                  parentNavigatorKey: _rootNavigatorKey, // Covers bottom nav
                  builder: (context, state) {
                    final surahId = int.parse(state.pathParameters['id'] ?? '1');
                    return SurahReaderScreen(surahId: surahId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.audio,
              builder: (context, state) => const AudioRecitersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.inaba,
              builder: (context, state) => const InabaRefugeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bookmarks,
              builder: (context, state) => const BookmarksScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

abstract final class AppRoutes {
  static const String quran     = '/quran';
  static const String surah     = 'surah';
  static const String audio     = '/audio';
  static const String inaba     = '/inaba';
  static const String bookmarks = '/bookmarks';
  static const String settings  = '/settings';
}
```

---

## 2. LOCALIZATION & RTL STANDARDS

### ARB File Definitions
All user-facing strings must reside in ARB resource bundles:
- `lib/l10n/app_ar.arb` (Primary authoritative source)
- `lib/l10n/app_en.arb` (English translation)

### Directional Geometry (RTL Safety)
Never use hardcoded left/right alignments or margins for asymmetric UI components. Use `Directional` metrics so layout automatically mirrors between Arabic (RTL) and English (LTR):

| Standard Metric (Forbidden for Asymmetric UI) | Directional Metric (Mandatory) |
| :--- | :--- |
| `EdgeInsets.only(left: 16.w)` | `EdgeInsetsDirectional.only(start: 16.w)` |
| `EdgeInsets.only(right: 8.w)` | `EdgeInsetsDirectional.only(end: 8.w)` |
| `Alignment.centerLeft` | `AlignmentDirectional.centerStart` |
| `Positioned(left: 0, ...)` | `PositionedDirectional(start: 0, ...)` |

### Icon & Chevron Mirroring
- Standard navigation icons like back arrows flip automatically in RTL if wrapped in `Directionality`.
- For custom SVG chevron assets or directional indicators, verify mirroring:
  ```dart
  Widget buildAdaptiveChevron(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Transform.flip(
      flipX: isRtl,
      child: const Icon(Icons.arrow_forward_ios),
    );
  }
  ```

---

## 3. APP LOCALIZATION CONFIGURATION
In `main.dart` or `SakinaApp`:

```dart
MaterialApp.router(
  debugShowCheckedModeBanner: false,
  routerConfig: appRouter,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('ar'), // Default Sacred Arabic
);
```


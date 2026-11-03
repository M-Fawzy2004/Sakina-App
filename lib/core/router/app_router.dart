import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/widgets/navigation/main_scaffold_shell.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/athkar_screen.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/audio_reciters_screen.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/hisn_muslim_screen.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/istighfar_screen.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/sunnah_books_screen.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/inaba_screen.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/maladh_screen.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/onboarding_screen.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/quran_screen.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/surah_reader_screen.dart';
import 'package:sakina_app/features/settings/presentation/widgets/settings_screen.dart';
import 'package:sakina_app/features/splash/presentation/widgets/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Declarative GoRouter configuration with StatefulShellRoute preserving tab states.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.athkar,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AthkarScreen(),
    ),
    GoRoute(
      path: AppRoutes.hisnMuslim,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const HisnMuslimScreen(),
    ),
    GoRoute(
      path: AppRoutes.sunnahBooks,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SunnahBooksScreen(),
    ),
    GoRoute(
      path: AppRoutes.istighfar,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const IstighfarScreen(),
    ),

    // Stateful Navigation Shell preserving tab state & scroll physics across the 5 core features
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffoldShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Al-Maladh (The Sanctuary)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.maladh,
              builder: (context, state) => const MaladhScreen(),
            ),
          ],
        ),

        // Branch 1: Al-Mushaf (Holy Quran)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.quran,
              builder: (context, state) => const QuranScreen(),
              routes: [
                GoRoute(
                  path: '${AppRoutes.surahDetail}/:id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final surahId =
                        int.tryParse(state.pathParameters['id'] ?? '18') ?? 18;
                    final surah = state.extra as SurahEntity? ??
                        SurahEntity(
                          id: surahId,
                          nameArabic: 'الكَهْفِ',
                          englishName: 'Al-Kahf',
                          revelationType: 'مَكِّيَّة',
                          versesCount: 110,
                          pageNumber: 293,
                          juzNumber: 15,
                        );
                    return SurahReaderScreen(surah: surah);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 2: Al-Tilawat (Recitations & Audio)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.audio,
              builder: (context, state) => const AudioRecitersScreen(),
            ),
          ],
        ),

        // Branch 3: Al-Inaba (Spiritual Recovery)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.inaba,
              builder: (context, state) => const InabaScreen(),
            ),
          ],
        ),

        // Branch 4: Al-I'dadat (Settings & Preferences)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

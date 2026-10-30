import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/widgets/navigation/main_scaffold_shell.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/onboarding_screen.dart';
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
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('المَلَاذُ'),
                ),
              ),
            ),
          ],
        ),

        // Branch 1: Al-Mushaf (Holy Quran)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.quran,
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('المُصْحَفُ'),
                ),
              ),
            ),
          ],
        ),

        // Branch 2: Al-Tilawat (Recitations & Audio)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.audio,
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('التِّلَاوَاتُ'),
                ),
              ),
            ),
          ],
        ),

        // Branch 3: Al-Inaba (Spiritual Recovery)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.inaba,
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('الإِنَابَةُ'),
                ),
              ),
            ),
          ],
        ),

        // Branch 4: Al-I'dadat (Settings & Preferences)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('الإِعْدَادَاتُ'),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/onboarding_screen.dart';
import 'package:sakina_app/features/splash/presentation/widgets/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Declarative GoRouter configuration.
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
      path: AppRoutes.quran,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Quran Index'),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.audio,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Audio Reciters'),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.inaba,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Inaba Recovery'),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Settings'),
        ),
      ),
    ),
  ],
);

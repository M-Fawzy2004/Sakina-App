import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/router/route_constants.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Declarative GoRouter configuration.
/// Note: Screen builders currently return minimal zero-UI placeholders,
/// ready for full UI implementation starting with the Splash screen.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Sakina Sanctuary'),
        ),
      ),
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


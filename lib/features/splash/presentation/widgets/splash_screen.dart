import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/notifications/local_notification_service.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:sakina_app/features/splash/presentation/cubit/splash_state.dart';
import 'package:sakina_app/features/splash/presentation/widgets/components/splash_aura_pulse.dart';
import 'package:sakina_app/features/splash/presentation/widgets/components/splash_background_artwork.dart';
import 'package:sakina_app/features/splash/presentation/widgets/components/splash_foreground_logo.dart';
import 'package:sakina_app/features/splash/presentation/widgets/components/splash_spiritual_quote.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..initializeApp(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _auraController;

  late final Animation<double> _backgroundFade;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _quoteFade;
  late final Animation<double> _auraPulse;

  @override
  void initState() {
    super.initState();

    // 1. Entrance animation (Background -> Logo settling -> Quote reveal)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _backgroundFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _quoteFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    // 2. Serene radiant aura pulse (continuous breathing effect)
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _auraPulse = Tween<double>(begin: 0.20, end: 0.70).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    _entranceController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestInitialNotificationPermissions();
    });
  }

  Future<void> _requestInitialNotificationPermissions() async {
    if (!mounted) return;
    try {
      if (sl.isRegistered<LocalNotificationService>() &&
          sl.isRegistered<PreferencesService>()) {
        await sl<LocalNotificationService>().handleFirstLaunchPermissions(
          prefs: sl<PreferencesService>(),
        );
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _auraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          context.go(state.destinationRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.obsidianCore,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Full-Screen Background Image (background_splash.png)
            SplashBackgroundArtwork(fadeAnimation: _backgroundFade),

            // Layer 2: Radiant Center Halo Aura
            SplashAuraPulse(pulseAnimation: _auraPulse),

            // Layer 3: Foreground High-Resolution Logo on Top (splash_image.png)
            SplashForegroundLogo(
              fadeAnimation: _logoFade,
              scaleAnimation: _logoScale,
            ),

            // Layer 4: Spiritual Quranic Inscription (Anchored at lower safe margin)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 36.h),
                  child: SplashSpiritualQuote(fadeAnimation: _quoteFade),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

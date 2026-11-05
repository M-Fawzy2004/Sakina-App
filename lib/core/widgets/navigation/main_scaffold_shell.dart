import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/navigation/sakina_bottom_nav_bar.dart';

/// Luxury Main Scaffold Shell hosting the persistent bottom navigation bar.
///
/// Features:
/// 1. iPhone Home Indicator Clearance: Elevated above the iOS home swipe bar.
/// 2. Persistent Bottom Nav Bar: Anchored and visible across primary sanctuary tabs.
/// 3. Luxury Floating "Scroll-to-Top" Button (الرجوع إلى الأعلى): Appears on lengthy
///    reading views (such as Mushaf reader) when scrolled past threshold.
class MainScaffoldShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffoldShell({super.key, required this.navigationShell});

  @override
  State<MainScaffoldShell> createState() => _MainScaffoldShellState();
}

class _MainScaffoldShellState extends State<MainScaffoldShell> {
  bool _showScrollToTop = false;
  BuildContext? _activeScrollContext;
  DateTime? _lastBackPressTime;

  void _handlePopInvoked(bool didPop) {
    if (didPop) return;

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      HapticService.selectionClick();
      final colors = context.colors;
      AppTopSnackBar.show(
        context: context,
        message: 'اضغط مرة أخرى للخروج من التطبيق',
        icon: Iconsax.logout,
        iconColor: colors.accentGold,
        backgroundColor: colors.cardSurface,
        borderColor: colors.accentGold.withValues(alpha: 0.35),
        textColor: colors.textPrimary,
        duration: const Duration(seconds: 2),
      );
    } else {
      AppTopSnackBar.dismiss();
      SystemNavigator.pop();
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    // Only respond to vertical scrolling events
    if (notification.metrics.axis == Axis.vertical) {
      _activeScrollContext = notification.context;

      // Scroll-to-Top return icon ONLY activates on lengthy Quran reading views (tab index 1),
      // never on standard sanctuary screens like Maladh, Audio, or Settings.
      final isLongQuranReadingView = widget.navigationShell.currentIndex == 1;
      final shouldShowScrollToTop =
          isLongQuranReadingView && notification.metrics.pixels > 600;

      if (shouldShowScrollToTop != _showScrollToTop) {
        setState(() {
          _showScrollToTop = shouldShowScrollToTop;
        });
      }
    }
    return false;
  }

  void _scrollToTop() {
    HapticService.selectionClick();

    bool scrolled = false;
    if (_activeScrollContext != null && _activeScrollContext!.mounted) {
      final scrollable = Scrollable.maybeOf(_activeScrollContext!);
      if (scrollable != null && scrollable.position.hasPixels) {
        scrollable.position.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
        scrolled = true;
      }
    }

    if (!scrolled) {
      final primary = PrimaryScrollController.maybeOf(context);
      if (primary != null && primary.hasClients) {
        primary.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    // Refined bottom clearance: Lower the bar so it sits comfortably closer to the bottom edge
    final double bottomOffset = bottomPadding > 0
        ? (bottomPadding * 0.35 + 4.h)
        : 6.h;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handlePopInvoked(didPop),
      child: Scaffold(
        backgroundColor: colors.background,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Persistent State Branch View listening to scroll gestures
            Positioned.fill(
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScrollNotification,
                child: widget.navigationShell,
              ),
            ),

            // 2. Floating Luxury Scroll-to-Top Action Button (Mushaf long reader view only)
            if (!isKeyboardOpen)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                right: 20.w,
                bottom: bottomOffset + 76.h,
                child: _ScrollToTopButton(
                  isVisible: _showScrollToTop,
                  onTap: _scrollToTop,
                ),
              ),

            // 3. Persistent Floating Luxury Stadium Bottom Navigation Bar
            if (!isKeyboardOpen)
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomOffset,
                child: SakinaBottomNavBar(
                  currentIndex: widget.navigationShell.currentIndex,
                  onItemSelected: (index) {
                    if (_showScrollToTop) {
                      setState(() {
                        _showScrollToTop = false;
                      });
                    }
                    _activeScrollContext = null;
                    widget.navigationShell.goBranch(
                      index,
                      initialLocation:
                          index == widget.navigationShell.currentIndex,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Floating luxury circular "Scroll-to-Top" button.
/// Features frosted glass styling, emerald/gold accents, and haptic feedback.
class _ScrollToTopButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const _ScrollToTopButton({required this.isVisible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: colors.accentGold.withValues(alpha: 0.3),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              splashColor: colors.accentGold.withValues(alpha: 0.2),
              highlightColor: colors.accentGold.withValues(alpha: 0.1),
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.cardSurface.withValues(alpha: 0.95),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.75),
                    width: 1.2.r,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.accentGold.withValues(alpha: 0.15),
                      blurRadius: 10.r,
                      spreadRadius: 1.r,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Iconsax.arrow_up_3,
                    color: colors.accentGold,
                    size: 20.r,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

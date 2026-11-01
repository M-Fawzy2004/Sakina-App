import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/navigation/sakina_bottom_nav_bar.dart';

/// Luxury Main Scaffold Shell hosting the persistent bottom navigation bar.
///
/// Features:
/// 1. iPhone Home Indicator Clearance: Elevated above the iOS home swipe bar.
/// 2. Auto-Hiding Bottom Nav Bar: Smoothly slides down off-screen on downward scroll,
///    re-appears on upward scroll or when reaching the top.
/// 3. Luxury Floating "Scroll-to-Top" Button (الرجوع إلى الأعلى): Appears when scrolled
///    past threshold, smoothly animates back to 0 with haptic feedback.
class MainScaffoldShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainScaffoldShell> createState() => _MainScaffoldShellState();
}

class _MainScaffoldShellState extends State<MainScaffoldShell> {
  bool _isNavBarVisible = true;
  bool _showScrollToTop = false;
  BuildContext? _activeScrollContext;

  bool _onScrollNotification(ScrollNotification notification) {
    // Only respond to vertical scrolling events
    if (notification.metrics.axis == Axis.vertical) {
      _activeScrollContext = notification.context;

      // Toggle Scroll-to-Top button visibility
      final shouldShowScrollToTop = notification.metrics.pixels > 280;
      if (shouldShowScrollToTop != _showScrollToTop) {
        setState(() {
          _showScrollToTop = shouldShowScrollToTop;
        });
      }

      // Handle auto-hide and auto-show of Bottom Navigation Bar
      if (notification is UserScrollNotification) {
        if (notification.direction == ScrollDirection.reverse) {
          // Scrolling down -> hide navbar
          if (_isNavBarVisible) {
            setState(() {
              _isNavBarVisible = false;
            });
          }
        } else if (notification.direction == ScrollDirection.forward) {
          // Scrolling up -> show navbar
          if (!_isNavBarVisible) {
            setState(() {
              _isNavBarVisible = true;
            });
          }
        }
      } else if (notification is ScrollUpdateNotification) {
        // Re-show navbar if user reached near top of screen
        if (notification.metrics.pixels <= 20 && !_isNavBarVisible) {
          setState(() {
            _isNavBarVisible = true;
          });
        }
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

    if (!_isNavBarVisible) {
      setState(() {
        _isNavBarVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    // iPhone Home Indicator clearance: When bottomPadding > 0 (e.g. 34pt on iPhone),
    // elevate by bottomPadding + 10.h so the bar is comfortably above the swipe indicator line.
    final double bottomOffset =
        bottomPadding > 0 ? (bottomPadding + 10.h) : 14.h;

    return Scaffold(
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

          // 2. Floating Luxury Scroll-to-Top Action Button (الرجوع إلى الأعلى)
          if (!isKeyboardOpen)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              right: 20.w,
              bottom: bottomOffset + (_isNavBarVisible ? 76.h : 12.h),
              child: _ScrollToTopButton(
                isVisible: _showScrollToTop,
                onTap: _scrollToTop,
              ),
            ),

          // 3. Floating Luxury Stadium Bottom Navigation Bar (Auto-hiding on scroll, hidden on keyboard)
          if (!isKeyboardOpen)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              left: 0,
              right: 0,
              bottom: _isNavBarVisible ? bottomOffset : (-85.h),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _isNavBarVisible ? 1.0 : 0.0,
                child: SakinaBottomNavBar(
                  currentIndex: widget.navigationShell.currentIndex,
                  onItemSelected: (index) {
                    if (!_isNavBarVisible) {
                      setState(() {
                        _isNavBarVisible = true;
                      });
                    }
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
            ),
        ],
      ),
    );
  }
}

/// Floating luxury circular "Scroll-to-Top" button.
/// Features frosted glass styling, emerald/gold accents, and haptic feedback.
class _ScrollToTopButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const _ScrollToTopButton({
    required this.isVisible,
    required this.onTap,
  });

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

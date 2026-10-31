import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/widgets/navigation/sakina_bottom_nav_bar.dart';

class MainScaffoldShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      backgroundColor: context.colors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Persistent State Branch View
          Positioned.fill(
            child: navigationShell,
          ),

          // 2. Floating Luxury Stadium Bottom Navigation Bar (Hidden when keyboard is active)
          if (!isKeyboardOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: (bottomPadding > 0 ? 8.0 : 10.0).h,
              child: SakinaBottomNavBar(
                currentIndex: navigationShell.currentIndex,
                onItemSelected: (index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}


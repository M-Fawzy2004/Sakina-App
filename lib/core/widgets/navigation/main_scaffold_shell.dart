import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
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

    return Scaffold(
      backgroundColor: AppColors.obsidianCore,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Persistent State Branch View
          Positioned.fill(
            child: navigationShell,
          ),

          // 2. Floating Luxury Stadium Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPadding + 12.h,
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


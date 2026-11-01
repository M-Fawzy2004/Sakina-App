import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/widgets/navigation/sakina_nav_item.dart';

class SakinaBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const SakinaBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 66.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(33.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: colors.cardSurface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(33.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  // Tab 0: Al-Maladh (The Sanctuary / Home)
                  Expanded(
                    child: SakinaNavItem(
                      label: 'المَلَاذُ',
                      isSelected: currentIndex == 0,
                      onTap: () => onItemSelected(0),
                      iconWidget: Icon(
                        currentIndex == 0
                            ? FlutterIslamicIcons.solidCrescentMoon
                            : FlutterIslamicIcons.crescentMoon,
                        size: 24.r,
                        color: currentIndex == 0
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                    ),
                  ),

                  // Tab 1: Al-Mushaf (Holy Quran)
                  Expanded(
                    child: SakinaNavItem(
                      label: 'المُصْحَفُ',
                      isSelected: currentIndex == 1,
                      onTap: () => onItemSelected(1),
                      iconWidget: Icon(
                        currentIndex == 1
                            ? FlutterIslamicIcons.solidQuran2
                            : FlutterIslamicIcons.quran2,
                        size: 23.r,
                        color: currentIndex == 1
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                    ),
                  ),

                  // Tab 2: Al-Tilawat (Recitations & Audio)
                  Expanded(
                    child: SakinaNavItem(
                      label: 'التِّلَاوَاتُ',
                      isSelected: currentIndex == 2,
                      onTap: () => onItemSelected(2),
                      iconWidget: Icon(
                        Iconsax.music,
                        size: 23.r,
                        color: currentIndex == 2
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                    ),
                  ),

                  // Tab 3: Al-Inaba (Spiritual Recovery / Purity & Repentance)
                  Expanded(
                    child: SakinaNavItem(
                      label: 'الإِنَابَةُ',
                      isSelected: currentIndex == 3,
                      onTap: () => onItemSelected(3),
                      iconWidget: Icon(
                        FlutterIslamicIcons.prayingPerson,
                        size: 23.r,
                        color: currentIndex == 3
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                    ),
                  ),

                  // Tab 4: Al-I'dadat (Settings & Preferences)
                  Expanded(
                    child: SakinaNavItem(
                      label: 'الإِعْدَادَاتُ',
                      isSelected: currentIndex == 4,
                      onTap: () => onItemSelected(4),
                      iconWidget: Icon(
                        Iconsax.setting_2,
                        size: 23.r,
                        color: currentIndex == 4
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 68.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: AppColors.carbonSlate.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(36.r),
                border: Border.all(
                  color: AppColors.goldBorderStroke,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tab 0: Al-Maladh (The Sanctuary / Home)
                  SakinaNavItem(
                    label: 'المَلَاذُ',
                    isSelected: currentIndex == 0,
                    onTap: () => onItemSelected(0),
                    iconWidget: Icon(
                      currentIndex == 0
                          ? FlutterIslamicIcons.solidCrescentMoon
                          : FlutterIslamicIcons.crescentMoon,
                      size: 24.r,
                      color: currentIndex == 0
                          ? AppColors.champagneGold
                          : AppColors.mutedSilver,
                    ),
                  ),

                  // Tab 1: Al-Mushaf (Holy Quran)
                  SakinaNavItem(
                    label: 'المُصْحَفُ',
                    isSelected: currentIndex == 1,
                    onTap: () => onItemSelected(1),
                    iconWidget: Icon(
                      currentIndex == 1
                          ? FlutterIslamicIcons.solidQuran2
                          : FlutterIslamicIcons.quran2,
                      size: 23.r,
                      color: currentIndex == 1
                          ? AppColors.champagneGold
                          : AppColors.mutedSilver,
                    ),
                  ),

                  // Tab 2: Al-Tilawat (Recitations & Audio)
                  SakinaNavItem(
                    label: 'التِّلَاوَاتُ',
                    isSelected: currentIndex == 2,
                    onTap: () => onItemSelected(2),
                    iconWidget: HugeIcon(
                      icon: HugeIcons.strokeRoundedAudioWaveform,
                      color: currentIndex == 2
                          ? AppColors.champagneGold
                          : AppColors.mutedSilver,
                      size: 23.r,
                    ),
                  ),

                  // Tab 3: Al-Inaba (Spiritual Recovery / Purity Lotus)
                  SakinaNavItem(
                    label: 'الإِنَابَةُ',
                    isSelected: currentIndex == 3,
                    onTap: () => onItemSelected(3),
                    iconWidget: HugeIcon(
                      icon: HugeIcons.strokeRoundedFlower01,
                      color: currentIndex == 3
                          ? AppColors.champagneGold
                          : AppColors.mutedSilver,
                      size: 23.r,
                    ),
                  ),

                  // Tab 4: Al-I'dadat (Settings & Preferences)
                  SakinaNavItem(
                    label: 'الإِعْدَادَاتُ',
                    isSelected: currentIndex == 4,
                    onTap: () => onItemSelected(4),
                    iconWidget: HugeIcon(
                      icon: HugeIcons.strokeRoundedSlidersHorizontal,
                      color: currentIndex == 4
                          ? AppColors.champagneGold
                          : AppColors.mutedSilver,
                      size: 22.r,
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


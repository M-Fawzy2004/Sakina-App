import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/prayer_time_item.dart';

/// Luxury spiritual top-sliding modal sheet (نافذة علوية منسدلة من الأعلى)
/// allowing the user to explicitly record whether a prayer was performed
/// ("نعم، أُدِّيَت") or is still pending ("لا، لم تُؤَدَّ") without conflicting
/// with bottom navigation bars.
class PrayerStatusTopSheet extends StatelessWidget {
  final PrayerTimeItem prayer;
  final ValueChanged<bool> onStatusSelected;

  const PrayerStatusTopSheet({
    super.key,
    required this.prayer,
    required this.onStatusSelected,
  });

  /// Displays the luxury top modal sheet with smooth slide-down animation and tactile feedback.
  static Future<void> show({
    required BuildContext context,
    required PrayerTimeItem prayer,
    required ValueChanged<bool> onStatusSelected,
  }) {
    HapticService.lightImpact();
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'PrayerStatusTopSheet',
      barrierColor: Colors.black.withValues(alpha: 0.65),
      transitionDuration: const Duration(milliseconds: 320),
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: PrayerStatusTopSheet(
              prayer: prayer,
              onStatusSelected: onStatusSelected,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Swipe up to dismiss
        if (details.primaryDelta != null && details.primaryDelta! < -8) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.obsidianCore,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          border: Border(
            bottom: BorderSide(
              color: AppColors.goldBorderStroke,
              width: 1.r,
            ),
            left: BorderSide(
              color: AppColors.goldBorderStroke,
              width: 1.r,
            ),
            right: BorderSide(
              color: AppColors.goldBorderStroke,
              width: 1.r,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Crest & Prayer Title Header + Dismiss Action
              Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.champagneGold,
                        width: 1.r,
                      ),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedClock01,
                        color: AppColors.champagneGold,
                        size: 22.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تَسْجِيلُ أَدَاءِ الصَّلَاةِ',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.pureChalk,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'صَلَاةُ ${prayer.nameArabic} • ',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.champagneGold,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                prayer.timeEnglish,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.champagneGold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.mutedSilver,
                      size: 20.r,
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalMd,

              // 2. Question Prompt
              Text(
                'هَلْ قُمْتَ بِأَدَاءِ هَذِهِ الفَرِيضَةِ؟',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedSilver,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              AppSpacing.verticalMd,

              // 3. Option 1: "نعم، أُدِّيَت بحمد الله" (Yes, completed)
              _PrayerStatusOptionTile(
                title: 'نَعَمْ، أُدِّيَتْ بِحَمْدِ اللَّهِ',
                subtitle: 'تَسْجِيلُ الفَرِيضَةِ كَمُؤَدَّاةٍ فِي وَقْتِهَا',
                isSelected: prayer.isCompleted,
                activeColor: AppColors.emeraldGlow,
                activeBackgroundColor: const Color(0x2410B981),
                leadingIcon: Icons.check_circle_rounded,
                onTap: () {
                  HapticService.selectionClick();
                  Navigator.of(context).pop();
                  onStatusSelected(true);
                },
              ),

              AppSpacing.verticalSm,

              // 4. Option 2: "لا، لم تؤدَّ بعد" (No, still pending)
              _PrayerStatusOptionTile(
                title: 'لَا، لَمْ تُؤَدَّ بَعْدُ',
                subtitle: 'إِبْقَاءُ الفَرِيضَةِ قَيْدَ الِانْتِظَارِ',
                isSelected: !prayer.isCompleted,
                activeColor: AppColors.champagneGold,
                activeBackgroundColor: const Color(0x1AD4AF37),
                leadingIcon: Icons.radio_button_unchecked_rounded,
                onTap: () {
                  HapticService.selectionClick();
                  Navigator.of(context).pop();
                  onStatusSelected(false);
                },
              ),

              AppSpacing.verticalMd,

              // 5. Bottom Drag Handle Indicator (Swipe up hint)
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.mutedSilver.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An individual status selection option card inside the top sheet.
class _PrayerStatusOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color activeColor;
  final Color activeBackgroundColor;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const _PrayerStatusOptionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.activeColor,
    required this.activeBackgroundColor,
    required this.leadingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: activeColor.withValues(alpha: 0.15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? activeBackgroundColor : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.goldBorderStroke,
              width: isSelected ? 1.4.r : 1.r,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.2)
                      : AppColors.obsidianCore,
                  border: Border.all(
                    color: isSelected ? activeColor : AppColors.goldBorderStroke,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    leadingIcon,
                    color: isSelected ? activeColor : AppColors.mutedSilver,
                    size: 20.r,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? activeColor : AppColors.pureChalk,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.mutedSilver,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.obsidianCore,
                      size: 14.r,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


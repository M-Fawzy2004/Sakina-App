import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

/// "إنجاز الورد اليومي" - Daily Quranic portion completion card
/// displaying dynamic progress bar, streak commitment, and remaining pages note.
class MaladhDailyGoalCard extends StatelessWidget {
  final int completedPages;
  final int totalPages;
  final int streakDays;
  final String remainingNote;
  final VoidCallback? onTap;

  const MaladhDailyGoalCard({
    super.key,
    this.completedPages = 4,
    this.totalPages = 6,
    this.streakDays = 19,
    this.remainingNote = 'متبقي صفحتان لختام الورد',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressFraction = totalPages > 0
        ? (completedPages / totalPages).clamp(0.0, 1.0)
        : 0.0;
    final percentInt = (progressFraction * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        onTap: () {
          HapticService.selectionClick();
          onTap?.call();
        },
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Row: Flag Icon + Title (RTL Start) & Progress Fraction (RTL End)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right Side: Flag Emblem + Title
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedFlag01,
                      color: AppColors.champagneGold,
                      size: 18.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'إِنْجَازُ الوِرْدِ اليَوْمِي',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.pureChalk,
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Left Side: Fraction & Percent Label
                Text(
                  '$completedPages من $totalPages صفحات ($percentInt%)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.pureChalk,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5.sp,
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSm,

            // 2. Linear Gradient Progress Bar
            Container(
              height: 10.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.goldBorderStroke,
                  width: 0.8.r,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      width: constraints.maxWidth * progressFraction,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.emeraldGlow,
                            AppColors.champagneGold,
                            AppColors.paleRadiance,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                },
              ),
            ),

            AppSpacing.verticalSm,

            // 3. Bottom Status Row: Streak Commitment & Remaining Pages
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right Side: Streak Commitment Chain
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedSparkles,
                      color: AppColors.champagneGold,
                      size: 14.r,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'سلسلة الالتزام: $streakDays يوماً متتالياً',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.champagneGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),

                // Left Side: Remaining Pages Note
                Text(
                  remainingNote,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.mutedSilver,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


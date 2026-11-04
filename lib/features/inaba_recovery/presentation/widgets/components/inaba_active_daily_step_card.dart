import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';

/// Prominently displays the active daily milestone on the Inaba screen ("كل يوم بيومه").
class InabaActiveDailyStepCard extends StatelessWidget {
  final int currentDay;
  final SpiritualRecoveryPlanEntity plan;
  final VoidCallback onCompleteStep;
  final VoidCallback onViewFullPlan;

  const InabaActiveDailyStepCard({
    super.key,
    required this.currentDay,
    required this.plan,
    required this.onCompleteStep,
    required this.onViewFullPlan,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final step = plan.steps.firstWhere(
      (s) => s.dayNumber == currentDay,
      orElse: () => plan.steps.last,
    );
    final isDone = step.isCompleted;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDone
                ? colors.accentEmerald.withValues(alpha: 0.5)
                : colors.accentGold.withValues(alpha: 0.35),
            width: 1.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Badge & Navigation
            _StepHeaderRow(
              currentDay: currentDay,
              totalDays: plan.steps.length,
              isDone: isDone,
              onViewFullPlan: onViewFullPlan,
            ),
            SizedBox(height: 12.h),

            // Day Title
            Text(
              step.title,
              style: GoogleFonts.almarai(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),

            // Practical Action Box
            _PracticalActionBox(actionText: step.practicalAction),
            SizedBox(height: 10.h),

            // Dhikr of the day
            _DhikrBox(dhikrText: step.recommendedDhikr),
            SizedBox(height: 14.h),

            // Action / Complete Button
            _CompletionButton(
              isDone: isDone,
              onPressed: () {
                HapticFeedback.lightImpact();
                onCompleteStep();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StepHeaderRow extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final bool isDone;
  final VoidCallback onViewFullPlan;

  const _StepHeaderRow({
    required this.currentDay,
    required this.totalDays,
    required this.isDone,
    required this.onViewFullPlan,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.accentGold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.25),
                  width: 0.8.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.calendar_tick,
                    size: 14.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'اليوم $currentDay من $totalDays',
                    style: GoogleFonts.almarai(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.accentGold,
                    ),
                  ),
                ],
              ),
            ),
            if (isDone) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: colors.accentEmerald.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'مكتمل بنجاح ✓',
                  style: GoogleFonts.almarai(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.accentEmerald,
                  ),
                ),
              ),
            ],
          ],
        ),
        InkWell(
          onTap: onViewFullPlan,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الخطة كاملة',
                  style: GoogleFonts.almarai(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 12.r,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PracticalActionBox extends StatelessWidget {
  final String actionText;

  const _PracticalActionBox({required this.actionText});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.4),
          width: 0.8.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.task,
            size: 16.r,
            color: colors.accentGold,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المهمة العملية لليوم:',
                  style: GoogleFonts.almarai(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.accentGold,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  actionText,
                  style: GoogleFonts.almarai(
                    fontSize: 11.5.sp,
                    color: colors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrBox extends StatelessWidget {
  final String dhikrText;

  const _DhikrBox({required this.dhikrText});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.accentEmerald.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.accentEmerald.withValues(alpha: 0.25),
          width: 0.8.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Iconsax.heart,
            size: 16.r,
            color: colors.accentEmerald,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              dhikrText,
              style: GoogleFonts.amiri(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: colors.accentEmerald,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionButton extends StatelessWidget {
  final bool isDone;
  final VoidCallback onPressed;

  const _CompletionButton({
    required this.isDone,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 42.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDone
              ? colors.accentEmerald.withValues(alpha: 0.15)
              : colors.accentGold,
          foregroundColor: isDone ? colors.accentEmerald : colors.background,
          elevation: 0,
          side: isDone
              ? BorderSide(
                  color: colors.accentEmerald.withValues(alpha: 0.4),
                  width: 1.r,
                )
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDone ? Iconsax.tick_circle : Iconsax.verify,
              size: 16.r,
            ),
            SizedBox(width: 8.w),
            Text(
              isDone ? 'أتممت مهمة اليوم بحمد الله' : 'إتمام خطوة اليوم',
              style: GoogleFonts.almarai(
                fontWeight: FontWeight.bold,
                fontSize: 12.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

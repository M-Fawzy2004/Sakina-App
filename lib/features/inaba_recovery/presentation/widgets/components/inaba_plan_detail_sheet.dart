import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';

/// Interactive detail sheet allowing the worshipper to follow a spiritual plan day by day.
class InabaPlanDetailSheet extends StatelessWidget {
  final SpiritualRecoveryPlanEntity plan;
  final InabaCubit cubit;

  const InabaPlanDetailSheet({
    super.key,
    required this.plan,
    required this.cubit,
  });

  static Future<void> show(
    BuildContext context, {
    required SpiritualRecoveryPlanEntity plan,
    required InabaCubit cubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => InabaPlanDetailSheet(plan: plan, cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.88.sh),
        padding: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 14.h,
          bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.7),
            width: 1.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.borderHairline,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // Header Row: Title, Badge, Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.task_square,
                            size: 18.r,
                            color: colors.accentGold,
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              plan.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.almarai(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${plan.completedStepsCount} من أصل ${plan.steps.length} خطوات مكتملة',
                        style: GoogleFonts.almarai(
                          color: colors.accentEmerald,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.close_circle,
                    size: 20.r,
                    color: colors.textSecondary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Plan Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: LinearProgressIndicator(
                value: plan.progress,
                minHeight: 5.h,
                backgroundColor: colors.borderHairline.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  plan.isFullyCompleted
                      ? colors.accentEmerald
                      : colors.accentGold,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Description Box
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.surfaceElevated.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.4),
                  width: 0.8.r,
                ),
              ),
              child: Text(
                plan.description,
                style: GoogleFonts.almarai(
                  fontSize: 11.5.sp,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // List of Steps
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: plan.steps.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final step = plan.steps[index];
                  return _StepTile(
                    step: step,
                    onToggle: () {
                      HapticFeedback.lightImpact();
                      cubit.togglePlanStep(plan.id, step.dayNumber);
                    },
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

class _StepTile extends StatelessWidget {
  final RecoveryPlanDayStepEntity step;
  final VoidCallback onToggle;

  const _StepTile({
    required this.step,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: step.isCompleted
              ? colors.accentEmerald.withValues(alpha: 0.08)
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: step.isCompleted
                ? colors.accentEmerald.withValues(alpha: 0.5)
                : colors.borderHairline.withValues(alpha: 0.6),
            width: step.isCompleted ? 1.2.r : 0.8.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion Checkbox Circle
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isCompleted
                        ? colors.accentEmerald
                        : Colors.transparent,
                    border: Border.all(
                      color: step.isCompleted
                          ? colors.accentEmerald
                          : colors.textSecondary,
                      width: 1.6.r,
                    ),
                  ),
                  child: step.isCompleted
                      ? Icon(Icons.check, size: 15.r, color: colors.background)
                      : null,
                ),
                SizedBox(width: 10.w),

                // Title
                Expanded(
                  child: Text(
                    step.title,
                    style: GoogleFonts.almarai(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: step.isCompleted
                          ? colors.accentEmerald
                          : colors.textPrimary,
                      decoration: step.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // Practical Action
            Padding(
              padding: EdgeInsets.only(right: 34.w),
              child: Text(
                step.practicalAction,
                style: GoogleFonts.almarai(
                  fontSize: 11.5.sp,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),

            if (step.recommendedDhikr.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.only(right: 34.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    step.recommendedDhikr,
                    style: AppTextStyles.quranAyahOf(context).copyWith(
                      color: colors.accentGold,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],

            if (step.scripturalEvidence.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.only(right: 34.w),
                child: Text(
                  step.scripturalEvidence,
                  style: GoogleFonts.almarai(
                    fontSize: 10.5.sp,
                    color: colors.accentGold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


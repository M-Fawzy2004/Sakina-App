import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_daily_tasks_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_plan_step_tile.dart';

/// Interactive detail sheet allowing worshippers to follow recovery day by day with reactive updates.
class InabaPlanDetailSheet extends StatelessWidget {
  final String planId;

  const InabaPlanDetailSheet({
    super.key,
    required this.planId,
  });

  static Future<void> show(
    BuildContext context, {
    required String planId,
    required InabaCubit cubit,
  }) {
    final colors = context.colors;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: colors.cardSurface.withValues(alpha: 0),
      elevation: 0,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: InabaPlanDetailSheet(planId: planId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<InabaCubit, InabaState>(
      builder: (context, state) {
        final plan = state.recoveryPlans.firstWhere(
          (p) => p.id == planId,
          orElse: () => state.recoveryPlans.isNotEmpty
              ? state.recoveryPlans.first
              : const SpiritualRecoveryPlanEntity(
                  id: '',
                  title: '',
                  badge: '',
                  durationText: '',
                  description: '',
                  iconKey: '',
                  steps: [],
                ),
        );

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
                _DetailHeaderRow(plan: plan),
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
                _PlanDescriptionBox(description: plan.description),
                SizedBox(height: 12.h),

                // List of Steps (Day-by-Day sequential)
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: plan.steps.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final step = plan.steps[index];
                      final isUnlocked = plan.isStepUnlocked(step.dayNumber);
                      final isLockedUntilTomorrow =
                          plan.isStepLockedUntilTomorrow(step.dayNumber);
                      final isLocked = !isUnlocked;
                      final isCurrent =
                          step.dayNumber == plan.activeOrTodayStep.dayNumber;

                      return InabaPlanStepTile(
                        step: step,
                        isLocked: isLocked,
                        isCurrentDay: isCurrent,
                        isLockedUntilTomorrow: isLockedUntilTomorrow,
                        onToggle: () {
                          if (isLockedUntilTomorrow) {
                            HapticFeedback.lightImpact();
                            AppTopSnackBar.show(
                              context: context,
                              message:
                                  'أتممت مهام اليوم بفضل الله؛ خطوات العزم مبنية يوماً بيوم.. ستُفتح مهام اليوم ${step.dayNumber} غداً بإذن الله',
                            );
                            return;
                          }
                          if (isLocked) {
                            HapticFeedback.lightImpact();
                            AppTopSnackBar.show(
                              context: context,
                              message:
                                  'هذا اليوم مغلق؛ أتمم خطوات الأيام السابقة أولاً للتقدم',
                            );
                            return;
                          }
                          HapticFeedback.lightImpact();
                          InabaDailyTasksSheet.show(
                            context,
                            planId: plan.id,
                            dayNumber: step.dayNumber,
                            cubit: context.read<InabaCubit>(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailHeaderRow extends StatelessWidget {
  final SpiritualRecoveryPlanEntity plan;

  const _DetailHeaderRow({required this.plan});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
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
    );
  }
}

class _PlanDescriptionBox extends StatelessWidget {
  final String description;

  const _PlanDescriptionBox({required this.description});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
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
        description,
        style: GoogleFonts.almarai(
          fontSize: 11.5.sp,
          color: colors.textSecondary,
          height: 1.45,
        ),
      ),
    );
  }
}

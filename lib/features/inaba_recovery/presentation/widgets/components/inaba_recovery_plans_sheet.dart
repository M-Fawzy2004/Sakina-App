import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_plan_detail_sheet.dart';

/// Modal bottom sheet showcasing all structured spiritual recovery roadmaps.
class InabaRecoveryPlansSheet extends StatelessWidget {
  final List<SpiritualRecoveryPlanEntity> plans;
  final InabaCubit cubit;

  const InabaRecoveryPlansSheet({
    super.key,
    required this.plans,
    required this.cubit,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SpiritualRecoveryPlanEntity> plans,
    required InabaCubit cubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => InabaRecoveryPlansSheet(plans: plans, cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.85.sh),
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

            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.shield_tick,
                      size: 20.r,
                      color: colors.accentGold,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'خُطَطُ الإِنَابَةِ وَالتَّعَافِي المَنْهَجِيَّة',
                      style: GoogleFonts.almarai(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
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

            SizedBox(height: 14.h),

            // List of Plans
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: plans.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return _PlanCard(
                    plan: plan,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                      InabaPlanDetailSheet.show(
                        context,
                        plan: plan,
                        cubit: cubit,
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
  }
}

class _PlanCard extends StatelessWidget {
  final SpiritualRecoveryPlanEntity plan;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colors.surfaceElevated.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: plan.isFullyCompleted
                ? colors.accentEmerald.withValues(alpha: 0.6)
                : colors.borderHairline.withValues(alpha: 0.7),
            width: 1.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Ribbon: Badge & Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: colors.accentGold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    plan.badge,
                    style: GoogleFonts.almarai(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.accentGold,
                    ),
                  ),
                ),
                Text(
                  plan.durationText,
                  style: GoogleFonts.almarai(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.accentEmerald,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // Title
            Text(
              plan.title,
              style: GoogleFonts.almarai(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),

            SizedBox(height: 4.h),

            // Description
            Text(
              plan.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.almarai(
                fontSize: 11.5.sp,
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),

            SizedBox(height: 10.h),

            // Progress & Action Row
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: plan.progress,
                      minHeight: 4.h,
                      backgroundColor:
                          colors.borderHairline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        plan.isFullyCompleted
                            ? colors.accentEmerald
                            : colors.accentGold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${(plan.progress * 100).toInt()}%',
                  style: GoogleFonts.almarai(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 15.r,
                  color: colors.accentGold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

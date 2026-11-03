import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';

/// Home card on the Inaba screen giving worshippers quick access to their spiritual recovery roadmap.
class InabaPlansOverviewCard extends StatelessWidget {
  final List<SpiritualRecoveryPlanEntity> plans;
  final VoidCallback onTap;

  const InabaPlansOverviewCard({
    super.key,
    required this.plans,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final activePlan = plans.isNotEmpty ? plans.first : null;
    final totalCompleted =
        plans.fold<int>(0, (sum, p) => sum + p.completedStepsCount);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.7),
              width: 0.8.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Top Ribbon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.shield_tick,
                        size: 18.r,
                        color: colors.accentGold,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'خُطَطُ التَّعَافِي وَالتَّطَهُّرِ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: colors.accentEmerald.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '$totalCompleted خطوات',
                    style: GoogleFonts.almarai(
                      color: colors.accentEmerald,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Plan Title & Description
            if (activePlan != null) ...[
              Text(
                activePlan.title,
                style: GoogleFonts.almarai(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                activePlan.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.almarai(
                  fontSize: 11.5.sp,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: activePlan.progress,
                  minHeight: 4.h,
                  backgroundColor:
                      colors.borderHairline.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    activePlan.isFullyCompleted
                        ? colors.accentEmerald
                        : colors.accentGold,
                  ),
                ),
              ),
            ],

            SizedBox(height: 10.h),

            // Bottom CTA Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '٣ خُطَطٍ مُتَكَامِلَة (٧ أيام • ٣٠ يوماً • طوارئ)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 10.5.sp,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'استعراض',
                      style: GoogleFonts.almarai(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Iconsax.arrow_left_2,
                      size: 13.r,
                      color: colors.accentGold,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}

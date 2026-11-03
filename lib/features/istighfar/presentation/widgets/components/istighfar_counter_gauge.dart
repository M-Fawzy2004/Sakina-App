import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

/// Central tactile counter gauge displaying current cycle count,
/// progress ring relative to target, and quick cycle reset button.
class IstighfarCounterGauge extends StatelessWidget {
  final IstighfarItem item;
  final VoidCallback onCountTap;
  final VoidCallback onResetTap;

  const IstighfarCounterGauge({
    super.key,
    required this.item,
    required this.onCountTap,
    required this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = item.targetCount > 0
        ? (item.currentCycleCount / item.targetCount).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Tactile Elevated Counting Button Disc
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCountTap,
            borderRadius: BorderRadius.circular(65.r),
            child: Container(
              width: 125.r,
              height: 125.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.65),
                  width: 1.6.r,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  // Circular Progress Indicator Ring
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4.r,
                    backgroundColor: colors.borderHairline.withValues(alpha: 0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
                  ),

                  // Center Count Number
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${item.currentCycleCount}',
                            style: GoogleFonts.almarai(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                              height: 1.0,
                            ),
                          ),
                          if (item.targetCount > 0) ...[
                            SizedBox(height: 2.h),
                            Text(
                              '/ ${item.targetCount}',
                              style: GoogleFonts.almarai(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textSecondary,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 14.h),

        // 2. Auxiliary Row: Laps Completed & Reset Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Laps Pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.5),
                  width: 0.8.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.repeat,
                    size: 13.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'الدورات: ${item.lapsCompleted}',
                    style: GoogleFonts.almarai(
                      color: colors.textSecondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            // Cycle Reset Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onResetTap,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colors.borderHairline.withValues(alpha: 0.5),
                      width: 0.8.r,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.refresh,
                        size: 13.r,
                        color: colors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'تصفير الدورة',
                        style: GoogleFonts.almarai(
                          color: colors.textSecondary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

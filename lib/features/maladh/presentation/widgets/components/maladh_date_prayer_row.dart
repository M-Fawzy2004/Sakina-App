import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_prayer_countdown_ticker.dart';

/// Unified celestial status strip displaying the full authentic Hijri date
/// alongside the live ticking prayer countdown without truncation.
class MaladhDatePrayerRow extends StatelessWidget {
  final String hijriDate;
  final String nextPrayerName;
  final String nextPrayerRemaining;

  const MaladhDatePrayerRow({
    super.key,
    required this.hijriDate,
    required this.nextPrayerName,
    required this.nextPrayerRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Hijri Date with Calendar Icon (RTL Start)
          Flexible(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    color: colors.accentGold,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    hijriDate,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // 2. Next Prayer with Live Second Countdown Ticker (RTL End)
          Flexible(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerEnd,
              child: MaladhPrayerCountdownTicker(prayerName: nextPrayerName),
            ),
          ),
        ],
      ),
    );
  }
}

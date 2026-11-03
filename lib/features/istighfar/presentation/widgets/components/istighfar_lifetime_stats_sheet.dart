import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

/// Luxury bottom sheet displaying the worshipper's all-time lifetime stats
/// with an itemized breakdown of every Istighfar & Tasbeeh recited locally.
class IstighfarLifetimeStatsSheet extends StatelessWidget {
  final List<IstighfarItem> items;
  final int totalLifetimeCount;

  const IstighfarLifetimeStatsSheet({
    super.key,
    required this.items,
    required this.totalLifetimeCount,
  });

  static Future<void> show(
    BuildContext context, {
    required List<IstighfarItem> items,
    required int totalLifetimeCount,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => IstighfarLifetimeStatsSheet(
        items: items,
        totalLifetimeCount: totalLifetimeCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.82.sh),
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
            // Handle
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
                      FlutterIslamicIcons.solidCrescentMoon,
                      size: 18.r,
                      color: colors.accentGold,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'سِجِلُّ الاسْتِغْفَارِ وَالتَّسْبِيحِ',
                      style: AppTextStyles.titleMediumOf(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
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

            // Total Lifetime Hero Card
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.4),
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: colors.accentGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.award,
                        color: colors.accentGold,
                        size: 24.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إِجْمَالِيُّ الاسْتِغْفَارِ وَالتَّسْبِيحِ',
                          style: GoogleFonts.cairo(
                            color: colors.textSecondary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$totalLifetimeCount مَرَّة',
                          style: GoogleFonts.cairo(
                            color: colors.accentGold,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            // Section Header
            Text(
              'تَفْصِيلُ الأَذْكَارِ الْمَحْفُوظَةِ مَحَلِّيّاً',
              style: GoogleFonts.cairo(
                color: colors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 8.h),

            // List of Items with Breakdown
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final ratio = totalLifetimeCount > 0
                      ? (item.lifetimeCount / totalLifetimeCount).clamp(0.0, 1.0)
                      : 0.0;

                  return _StatItemTile(
                    item: item,
                    ratio: ratio,
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

class _StatItemTile extends StatelessWidget {
  final IstighfarItem item;
  final double ratio;

  const _StatItemTile({
    required this.item,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.6),
          width: 0.8.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.arabic,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    color: colors.textPrimary,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '${item.lifetimeCount} مَرَّة',
                style: GoogleFonts.cairo(
                  color: colors.accentGold,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 4.h,
              backgroundColor: colors.borderHairline.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Serene Spiritual Sanctuary Overview Card for the top of Settings.
/// Replaces the billboard hero card with a dignified Islamic identity,
/// displaying a sacred Quranic reminder and sanctuary status badges.
class SettingsSanctuaryCard extends StatelessWidget {
  const SettingsSanctuaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.8),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Sanctuary Crescent & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.accentGold.withValues(alpha: 0.5),
                          width: 1.r,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Iconsax.sun_fog,
                          color: colors.accentGold,
                          size: 18.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وَاحَةُ سَكِينَةَ المُبَارَكَةُ',
                            style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            'مَلَاذٌ رُوحَانِيٌّ آمِنٌ لِلذِّكْرِ وَالقُرْآنِ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              fontSize: 11.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Active Sanctuary Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.4),
                    width: 0.8.r,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        color: colors.accentGold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'آمِنٌ',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.accentGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Central Sacred Quranic Verse
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colors.borderHairline.withValues(alpha: 0.6),
                width: 0.8.r,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '«أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ»',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.accentGold,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'سُورَةُ الرَّعْدِ • آيَة ٢٨',
                  style: GoogleFonts.cairo(
                    fontSize: 10.5.sp,
                    color: colors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Three Quick Status Indicators
          Row(
            children: [
              const Expanded(
                child: _StatusPill(
                  icon: Iconsax.shield_tick,
                  title: 'حِصْنُ الأَذْكَارِ',
                  status: 'مُحَصَّنٌ',
                ),
              ),
              SizedBox(width: 8.w),
              const Expanded(
                child: _StatusPill(
                  icon: Iconsax.book_1,
                  title: 'الوِرْدُ اليَوْمِيُّ',
                  status: 'مُتَابَعٌ',
                ),
              ),
              SizedBox(width: 8.w),
              const Expanded(
                child: _StatusPill(
                  icon: Iconsax.refresh_2,
                  title: 'الإِنَابَةُ',
                  status: 'فِي مَعِيَّةِ اللَّهِ',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;

  const _StatusPill({
    required this.icon,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.4),
          width: 0.7.r,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 14.r, color: colors.accentGold),
          SizedBox(height: 3.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 9.sp,
              color: colors.accentGold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

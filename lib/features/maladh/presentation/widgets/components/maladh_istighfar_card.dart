import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';

/// "مَسْبَحَةُ الاسْتِغْفَارِ" - Interactive Sanctuary Istighfar & Tasbeeh Card in Al-Maladh.
/// Displays lifetime count progress and launches the dedicated interactive Sibha screen.
class MaladhIstighfarCard extends StatefulWidget {
  final VoidCallback? onTap;

  const MaladhIstighfarCard({
    super.key,
    this.onTap,
  });

  @override
  State<MaladhIstighfarCard> createState() => _MaladhIstighfarCardState();
}

class _MaladhIstighfarCardState extends State<MaladhIstighfarCard> {
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLifetimeCount();
  }

  Future<void> _loadLifetimeCount() async {
    try {
      if (sl.isRegistered<IstighfarLocalDataSource>()) {
        final total = await sl<IstighfarLocalDataSource>().getTotalLifetimeCount();
        if (mounted) {
          setState(() {
            _totalCount = total;
          });
        }
      }
    } catch (_) {}
  }

  void _handleTap(BuildContext context) {
    HapticService.selectionClick();
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      context.push(AppRoutes.istighfar).then((_) => _loadLifetimeCount());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: TactileGlassCard(
        onTap: () => _handleTap(context),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Ribbon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        FlutterIslamicIcons.tasbihHand,
                        size: 18.r,
                        color: colors.accentGold,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'مَسْبَحَةُ الاسْتِغْفَارِ وَالتَّسْبِيح',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMediumOf(context).copyWith(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Lifetime Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: colors.accentEmerald.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _totalCount > 0 ? '$_totalCount مَرَّة' : 'ابدأ الذكر',
                    style: GoogleFonts.cairo(
                      color: colors.accentEmerald,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // 2. Prophetic Quote
            Text(
              '«أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ»',
              textAlign: TextAlign.center,
              style: AppTextStyles.quranAyahOf(context).copyWith(
                fontSize: 15.sp,
                height: 1.7,
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 10.h),

            // 3. Footer Call to Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'سبحة تفاعلية مع حفظ تلقائي محلي',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      color: colors.textSecondary,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'فتح المسبحة',
                      style: GoogleFonts.cairo(
                        color: colors.accentGold,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Iconsax.arrow_left_2,
                      size: 12.r,
                      color: colors.accentGold,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

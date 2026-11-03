import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

/// Venerable typographic presentation of the active Istighfar / Tasbeeh phrase
/// displaying the core sacred Arabic text and its authentic prophetic virtue.
class IstighfarPhraseDisplay extends StatelessWidget {
  final IstighfarItem item;

  const IstighfarPhraseDisplay({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Primary Prophetic Dhikr Arabic Text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: Text(
              item.arabic,
              key: ValueKey(item.id),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.quranAyahOf(context).copyWith(
                fontSize: 25.sp,
                height: 1.8,
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (item.virtue.isNotEmpty) ...[
            SizedBox(height: 6.h),

            // Delicate Diamond Divider (matching reference photo: ─── ◆ ───)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32.w,
                  height: 0.8.h,
                  color: colors.accentGold.withValues(alpha: 0.4),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      width: 4.5.r,
                      height: 4.5.r,
                      color: colors.accentGold,
                    ),
                  ),
                ),
                Container(
                  width: 32.w,
                  height: 0.8.h,
                  color: colors.accentGold.withValues(alpha: 0.4),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // 2. Prophetic Virtue Pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.5),
                  width: 0.8.r,
                ),
              ),
              child: Text(
                '«${item.virtue}»',
                textAlign: TextAlign.center,
                style: GoogleFonts.almarai(
                  color: colors.accentGold,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


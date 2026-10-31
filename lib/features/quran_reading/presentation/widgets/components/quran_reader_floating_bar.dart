import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Compact single-row floating bar for the Al-Mushaf reader.
/// - If an ayah is selected: actions apply to that ayah.
/// - Otherwise: actions apply to the current page / surah.
class QuranReaderFloatingBar extends StatelessWidget {
  final int pageNumber;
  final int juzNumber;
  final int? selectedAyahNumber;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onPlay;
  final VoidCallback onTafsir;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;

  const QuranReaderFloatingBar({
    super.key,
    required this.pageNumber,
    required this.juzNumber,
    required this.selectedAyahNumber,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onPlay,
    required this.onTafsir,
    required this.onCopy,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedAyahNumber != null;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.carbonSlate.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: hasSelection
                ? AppColors.emeraldGlow.withValues(alpha: 0.6)
                : AppColors.goldBorderStroke,
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            _IconBtn(
              icon: isRtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              tooltip: 'الصفحة السابقة',
              size: 22,
              onTap: onPreviousPage,
            ),

            // Info: page · juz  /  ayah badge
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: hasSelection
                      ? _Badge(
                          key: ValueKey('ayah-$selectedAyahNumber'),
                          text: 'الآية $selectedAyahNumber',
                          color: AppColors.emeraldGlow,
                          filled: true,
                        )
                      : _Badge(
                          key: ValueKey('page-$pageNumber-$juzNumber'),
                          text: 'ص $pageNumber • جزء $juzNumber',
                          color: AppColors.champagneGold,
                        ),
                ),
              ),
            ),

            _IconBtn(
              icon: isRtl
                  ? Icons.chevron_right_rounded
                  : Icons.chevron_left_rounded,
              tooltip: 'الصفحة التالية',
              size: 22,
              onTap: onNextPage,
            ),

            Container(
              width: 1,
              height: 20.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: AppColors.goldBorderStroke.withValues(alpha: 0.5),
            ),

            _IconBtn(
              icon: Icons.play_arrow_rounded,
              tooltip: 'تِلَاوَة',
              size: 24,
              onTap: onPlay,
            ),
            _IconBtn(
              icon: HugeIcons.strokeRoundedBookOpen01,
              tooltip: 'تَفْسِير',
              color: AppColors.emeraldGlow,
              size: 19,
              onTap: onTafsir,
            ),
            _IconBtn(
              icon: Icons.copy_rounded,
              tooltip: 'نَسْخ',
              size: 18,
              onTap: onCopy,
            ),
            _IconBtn(
              icon: Icons.bookmark_add_rounded,
              tooltip: 'حِفْظ',
              size: 20,
              onTap: onBookmark,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool filled;

  const _Badge({
    super.key,
    required this.text,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: filled
            ? Border.all(color: color.withValues(alpha: 0.7), width: 0.8.r)
            : null,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final dynamic icon; // IconData | List<List<dynamic>> (HugeIcons)
  final String tooltip;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color = AppColors.champagneGold,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (icon is IconData) {
      child = Icon(icon as IconData, color: color, size: size.r);
    } else if (icon is List<List<dynamic>>) {
      child = HugeIcon(
        icon: icon as List<List<dynamic>>,
        color: color,
        size: size.r,
      );
    } else {
      child = const SizedBox.shrink();
    }

    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkResponse(
          radius: 20.r,
          onTap: () {
            HapticService.selectionClick();
            onTap();
          },
          child: SizedBox(
            width: 34.r,
            height: 34.r,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_mockup_card.dart';

/// 2-Column Responsive Grid of Surah Cards matching user's design reference:
/// - 2 columns per row with clean card proportions
/// - Responsive gutter spacing with ScreenUtil tokens
/// - Smooth sliver layout integrating seamlessly with CustomScrollView
class QuranSurahsList extends StatelessWidget {
  final List<SurahEntity> surahs;
  final ValueChanged<SurahEntity> onSurahTap;

  const QuranSurahsList({
    super.key,
    required this.surahs,
    required this.onSurahTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (surahs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Text(
              'لم يتم العثور على سور مطابقة للبحث',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          mainAxisExtent: 96.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final surah = surahs[index];
            return QuranSurahMockupCard(
              surah: surah,
              onTap: () => onSurahTap(surah),
            );
          },
          childCount: surahs.length,
        ),
      ),
    );
  }
}

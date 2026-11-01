import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/juz_tile.dart';

/// 2-Column Responsive Grid of 30 Juz Cards matching the Surah card design:
/// - 2 columns per row with clean card proportions
/// - Responsive gutter spacing with ScreenUtil tokens
/// - Smooth sliver layout integrating seamlessly with CustomScrollView
class QuranJuzsList extends StatelessWidget {
  final List<JuzEntity> juzs;
  final List<SurahEntity> allSurahs;
  final ValueChanged<JuzEntity> onJuzTap;

  const QuranJuzsList({
    super.key,
    required this.juzs,
    required this.allSurahs,
    required this.onJuzTap,
  });

  @override
  Widget build(BuildContext context) {
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
            final juz = juzs[index];
            return JuzTile(
              juz: juz,
              onTap: () => onJuzTap(juz),
            );
          },
          childCount: juzs.length,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_mockup_card.dart';

/// Slivers of Surah cards with clean responsive layout.
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
    if (surahs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Text(
              'لم يتم العثور على سور مطابقة للبحث',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedSilver,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
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
    );
  }
}


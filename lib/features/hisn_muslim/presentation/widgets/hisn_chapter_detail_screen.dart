import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/components/hisn_dua_card.dart';

class HisnChapterDetailScreen extends StatelessWidget {
  final HisnChapterEntity chapter;

  const HisnChapterDetailScreen({
    super.key,
    required this.chapter,
  });

  static Future<void> open(BuildContext context, HisnChapterEntity chapter) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => HisnChapterDetailScreen(chapter: chapter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        HapticService.selectionClick();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: colors.borderHairline,
                            width: 1.r,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Iconsax.arrow_right_3,
                            size: 20.r,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.titleAr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMediumOf(context).copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${chapter.category} • ${chapter.itemCount} ${chapter.itemCount == 1 ? "ذكر" : "أدعية"}',
                            style: AppTextStyles.captionOf(context).copyWith(
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
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final dua = chapter.items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: HisnDuaCard(
                        dua: dua,
                        index: index + 1,
                        totalInChapter: chapter.itemCount,
                      ),
                    );
                  },
                  childCount: chapter.items.length,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: 32.h),
            ),
          ],
        ),
      ),
    );
  }
}


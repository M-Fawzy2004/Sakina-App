import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_level_entity.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';

class InabaTreeOfLightSheet extends StatelessWidget {
  const InabaTreeOfLightSheet({super.key});

  static Future<void> show(
    BuildContext context, {
    required InabaCubit cubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const InabaTreeOfLightSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<InabaCubit, InabaState>(
      builder: (context, state) {
        final streakDays = state.overview?.streakDays ?? 0;
        final progress = state.overview?.streakProgress ?? 0.0;
        final levels = state.spiritualLevels;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 0.88.sh,
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 16.h,
              bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
            ),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              border: Border.all(
                color: colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Column(
              children: [
                // Handle Bar
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
                SizedBox(height: 16.h),

                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: colors.borderHairline,
                          width: 1.r,
                        ),
                      ),
                      child: Icon(
                        Iconsax.tree,
                        size: 22.r,
                        color: colors.accentGold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'شَجَرَةُ النُّورِ وَالثَّبَاتِ',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'كل يوم تقترب من الله.. وتنمو شجرة إيمانك',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Visual Tree Display Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.4),
                      width: 1.2.r,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Illuminated Tree Symbol
                      Container(
                        width: 76.r,
                        height: 76.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.cardSurface,
                          border: Border.all(
                            color: colors.accentGold,
                            width: 1.5.r,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Iconsax.tree,
                            size: 42.r,
                            color: colors.accentGold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        '$streakDays يَوْماً مِنَ النَّقَاءِ',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'نسبة الثبات الإيماني: ${(progress * 100).toInt()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.accentGold,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: SizedBox(
                          height: 6.h,
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.05, 1.0),
                            backgroundColor: colors.cardSurface,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(colors.accentGold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Levels Title
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'المُسْتَوَيَاتُ الإِيمَانِيَّةُ:',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Levels List
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: levels.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final level = levels[index];
                      return _LevelMilestoneCard(level: level);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LevelMilestoneCard extends StatelessWidget {
  final SpiritualLevelEntity level;

  const _LevelMilestoneCard({required this.level});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: level.isCurrent ? colors.surfaceElevated : colors.cardSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: level.isCurrent ? colors.accentGold : colors.borderHairline,
          width: level.isCurrent ? 1.5.r : 1.r,
        ),
      ),
      child: Row(
        children: [
          // Badge
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: level.isUnlocked
                  ? colors.accentGold.withValues(alpha: 0.15)
                  : colors.surfaceElevated,
              border: Border.all(
                color: level.isUnlocked
                    ? colors.accentGold
                    : colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Center(
              child: Icon(
                level.isUnlocked ? Iconsax.medal_star : Iconsax.lock,
                size: 18.r,
                color: level.isUnlocked
                    ? colors.accentGold
                    : colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      level.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '${level.minDays} - ${level.maxDays} يوماً',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.accentGold,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  level.description,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_add_deed_dialog.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_good_deed_tile.dart';

class InabaGoodDeedsSheet extends StatelessWidget {
  const InabaGoodDeedsSheet({super.key});

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
        child: const InabaGoodDeedsSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<InabaCubit, InabaState>(
      builder: (context, state) {
        final deeds = state.goodDeeds;
        final cubit = context.read<InabaCubit>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 0.85.sh,
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
                        Iconsax.heart_add,
                        size: 22.r,
                        color: colors.accentGold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحَسَنَاتُ المَاحِيَةُ',
                          style: AppTextStyles.titleMediumOf(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'اختر عملاً صالحاً يبدل سيئة بحسنة ويقربك من الله',
                          style: AppTextStyles.captionOf(context).copyWith(
                            color: colors.textSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    '﴿ إِنَّ الْحَسَنَاتِ يُذْهِبْنَ السَّيِّئَاتِ ۚ ذَٰلِكَ ذِكْرَىٰ لِلذَّاكِرِينَ ﴾',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.quranAyahOf(context).copyWith(
                      color: colors.accentGold,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: deeds.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final deed = deeds[index];
                      return InabaGoodDeedTile(
                        deed: deed,
                        onTap: () => cubit.toggleGoodDeed(deed.id),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.accentGold,
                      side: BorderSide(
                        color: colors.accentGold,
                        width: 1.2.r,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: () => InabaAddDeedDialog.show(context, cubit),
                    icon: Icon(
                      Iconsax.add,
                      size: 20.r,
                      color: colors.accentGold,
                    ),
                    label: Text(
                      'أَضِفْ عَمَلاً صَالِحاً خَاصّاً بِكَ +',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold,
                      ),
                    ),
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

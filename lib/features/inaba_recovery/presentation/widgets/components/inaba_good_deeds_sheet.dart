import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';

class InabaGoodDeedsSheet extends StatelessWidget {
  final List<GoodDeedEntity> deeds;
  final ValueChanged<String> onToggleDeed;
  final Function(String title, String category) onAddDeed;

  const InabaGoodDeedsSheet({
    super.key,
    required this.deeds,
    required this.onToggleDeed,
    required this.onAddDeed,
  });

  static Future<void> show(
    BuildContext context, {
    required List<GoodDeedEntity> deeds,
    required ValueChanged<String> onToggleDeed,
    required Function(String title, String category) onAddDeed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) => InabaGoodDeedsSheet(
        deeds: deeds,
        onToggleDeed: onToggleDeed,
        onAddDeed: onAddDeed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
            // Sheet Handle
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

            // Header Row
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

            // Quran Quote Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
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

            // Deeds List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: deeds.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final deed = deeds[index];
                  return _GoodDeedTile(
                    deed: deed,
                    onTap: () => onToggleDeed(deed.id),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),

            // Add Custom Deed Button
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
                onPressed: () => _showAddDeedDialog(context),
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
  }

  void _showAddDeedDialog(BuildContext context) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(color: colors.borderHairline, width: 1.r),
          ),
          title: Text(
            'إضافة عمل صالح خاص',
            style: AppTextStyles.titleMediumOf(context).copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'مثال: صيام يوم تطوعاً، سقاية ماء...',
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                  filled: true,
                  fillColor: colors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: colors.borderHairline),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: 'التصنيف (مثال: عبادة، إحسان، صيام...)',
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                  filled: true,
                  fillColor: colors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: colors.borderHairline),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                final category = categoryController.text.trim();
                if (title.isNotEmpty) {
                  onAddDeed(title, category);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text(
                'إضافة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoodDeedTile extends StatelessWidget {
  final GoodDeedEntity deed;
  final VoidCallback onTap;

  const _GoodDeedTile({
    required this.deed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: deed.isCompletedToday
                ? colors.surfaceElevated
                : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: deed.isCompletedToday
                  ? colors.accentGold
                  : colors.borderHairline,
              width: deed.isCompletedToday ? 1.5.r : 1.r,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: deed.isCompletedToday
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Icon(
                  _mapIconKey(deed.iconKey),
                  size: 20.r,
                  color: deed.isCompletedToday
                      ? colors.accentGold
                      : colors.textSecondary,
                ),
              ),
              SizedBox(width: 12.w),

              // Title and Reward
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            deed.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMediumOf(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '(${deed.completionCount}x)',
                          style: AppTextStyles.captionOf(context).copyWith(
                            color: colors.accentGold,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      deed.rewardDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Completion Indicator
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: deed.isCompletedToday
                      ? colors.accentGold
                      : colors.surfaceElevated,
                  border: Border.all(
                    color: deed.isCompletedToday
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.tick_circle,
                    size: 16.r,
                    color: deed.isCompletedToday
                        ? colors.background
                        : colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapIconKey(String key) {
    switch (key) {
      case 'moon':
        return FlutterIslamicIcons.solidCrescentMoon;
      case 'tasbih':
        return FlutterIslamicIcons.tasbihHand;
      case 'book':
        return FlutterIslamicIcons.quran2;
      case 'people':
        return Iconsax.people;
      case 'hands':
        return Iconsax.lovely;
      case 'heart':
      default:
        return Iconsax.heart;
    }
  }
}

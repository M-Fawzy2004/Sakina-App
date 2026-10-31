import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';

class InabaSanctuaryConfessionSheet extends StatefulWidget {
  final bool isUnlocked;
  final List<SpiritualReflectionEntity> reflections;
  final VoidCallback onUnlock;
  final VoidCallback onLock;
  final Function({
    required String title,
    required String content,
    required String moodTag,
  }) onSaveReflection;
  final ValueChanged<String> onDeleteReflection;

  const InabaSanctuaryConfessionSheet({
    super.key,
    required this.isUnlocked,
    required this.reflections,
    required this.onUnlock,
    required this.onLock,
    required this.onSaveReflection,
    required this.onDeleteReflection,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isUnlocked,
    required List<SpiritualReflectionEntity> reflections,
    required VoidCallback onUnlock,
    required VoidCallback onLock,
    required Function({
      required String title,
      required String content,
      required String moodTag,
    }) onSaveReflection,
    required ValueChanged<String> onDeleteReflection,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) => InabaSanctuaryConfessionSheet(
        isUnlocked: isUnlocked,
        reflections: reflections,
        onUnlock: onUnlock,
        onLock: onLock,
        onSaveReflection: onSaveReflection,
        onDeleteReflection: onDeleteReflection,
      ),
    );
  }

  @override
  State<InabaSanctuaryConfessionSheet> createState() =>
      _InabaSanctuaryConfessionSheetState();
}

class _InabaSanctuaryConfessionSheetState
    extends State<InabaSanctuaryConfessionSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  String _selectedMood = 'ندم ورجاء';

  final List<String> _moodTags = const [
    'ندم ورجاء',
    'شكر واطمئنان',
    'مجاهدة النفس',
    'تضرع ودعاء',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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

            // Top Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        widget.isUnlocked ? Iconsax.lock_slash : Iconsax.lock,
                        size: 20.r,
                        color: colors.accentGold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مِحْرَابُ البَوْحِ',
                          style: AppTextStyles.titleMediumOf(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'مساحتك الآمنة للتأمل والمحاسبة بينك وبين الله',
                          style: AppTextStyles.captionOf(context).copyWith(
                            color: colors.textSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.isUnlocked)
                  IconButton(
                    tooltip: 'قفل المحراب',
                    icon: Icon(
                      Iconsax.lock,
                      size: 20.r,
                      color: colors.accentGold,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onLock();
                    },
                  ),
              ],
            ),
            SizedBox(height: 16.h),

            // Content: Locked vs Unlocked
            Expanded(
              child: widget.isUnlocked
                  ? _buildUnlockedView(context)
                  : _buildLockedView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedView(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88.r,
            height: 88.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceElevated,
              border: Border.all(
                color: colors.accentGold,
                width: 2.r,
              ),
            ),
            child: Center(
              child: Icon(
                Iconsax.lock,
                size: 40.r,
                color: colors.accentGold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'محرابك محمي ومشفّر',
            style: AppTextStyles.titleMediumOf(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'هنا مساحتك الخاصة لتفريغ ما في صدرك، ومحاسبة النفس بصدق بين يدي خالقك.',
              textAlign: TextAlign.center,
              style: AppTextStyles.captionOf(context).copyWith(
                color: colors.textSecondary,
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Unlock Button
          SizedBox(
            width: 220.w,
            height: 48.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                widget.onUnlock();
              },
              icon: Icon(
                Iconsax.finger_scan,
                size: 20.r,
                color: colors.background,
              ),
              label: Text(
                'فَتْحُ المِحْرَابِ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.background,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Reassurance Verse
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Text(
              '﴿ وَمَا كَانَ اللَّهُ مُعَذِّبَهُمْ وَهُمْ يَسْتَغْفِرُونَ ﴾',
              style: AppTextStyles.quranAyahOf(context).copyWith(
                color: colors.accentGold,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockedView(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood Selector Pills
          Text(
            'حَالُ القَلْبِ الآن:',
            style: AppTextStyles.caption.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 6.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _moodTags.map((mood) {
                final isSelected = mood == _selectedMood;
                return Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: ChoiceChip(
                    label: Text(
                      mood,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? colors.background
                            : colors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: colors.accentGold,
                    backgroundColor: colors.surfaceElevated,
                    elevation: 0,
                    side: BorderSide(
                      color: isSelected
                          ? colors.accentGold
                          : colors.borderHairline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedMood = mood);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12.h),

          // Title Input
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'عنوان الخاطرة (مثال: عودة بعد غفلة...)',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: colors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: colors.borderHairline),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Content Input
          TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'اكتب بأمان واطمئنان.. لا أحد يطّلع على هذا غير الله',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: colors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: colors.borderHairline),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Action Buttons: Save & Clear
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentGold,
                    foregroundColor: colors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    final content = _contentController.text.trim();
                    if (content.isNotEmpty) {
                      HapticFeedback.lightImpact();
                      widget.onSaveReflection(
                        title: _titleController.text.trim(),
                        content: content,
                        moodTag: _selectedMood,
                      );
                      _titleController.clear();
                      _contentController.clear();
                    }
                  },
                  icon: Icon(
                    Iconsax.document_upload,
                    size: 18.r,
                    color: colors.background,
                  ),
                  label: Text(
                    'حفظ في المحراب',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.background,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textSecondary,
                  side: BorderSide(color: colors.borderHairline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () {
                  _titleController.clear();
                  _contentController.clear();
                },
                child: Text(
                  'محو',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Saved Reflections Section
          Text(
            'خَوَاطِرُكَ المَحْفُوظَةُ (${widget.reflections.length})',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),

          if (widget.reflections.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Text(
                  'لم تسجل أي خواطر بعد.. المحراب ينتظر صدقك',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            )
          else
            ...widget.reflections.map((r) {
              return _ReflectionCard(
                reflection: r,
                onDelete: () => widget.onDeleteReflection(r.id),
              );
            }),
        ],
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  final SpiritualReflectionEntity reflection;
  final VoidCallback onDelete;

  const _ReflectionCard({
    required this.reflection,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: colors.accentGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      reflection.moodTag,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    reflection.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Iconsax.trash,
                  size: 16.r,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onDelete();
                },
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            reflection.content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textPrimary,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

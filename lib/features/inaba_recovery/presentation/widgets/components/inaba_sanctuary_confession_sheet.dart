import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_reflection_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_reflection_composer_form.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_sanctuary_locked_view.dart';

class InabaSanctuaryConfessionSheet extends StatefulWidget {
  const InabaSanctuaryConfessionSheet({super.key});

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
        child: const InabaSanctuaryConfessionSheet(),
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

  void _onSaveReflection(InabaCubit cubit) {
    final content = _contentController.text.trim();
    if (content.isNotEmpty) {
      cubit.saveReflection(
        title: _titleController.text.trim(),
        content: content,
        moodTag: _selectedMood,
      );
      _titleController.clear();
      _contentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<InabaCubit, InabaState>(
      builder: (context, state) {
        final cubit = context.read<InabaCubit>();
        final isUnlocked = state.isConfessionUnlocked;
        final reflections = state.reflections;

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
                            isUnlocked ? Iconsax.lock_slash : Iconsax.lock,
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
                              style:
                                  AppTextStyles.titleMediumOf(context).copyWith(
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
                    if (isUnlocked)
                      IconButton(
                        tooltip: 'قفل المحراب',
                        icon: Icon(
                          Iconsax.lock,
                          size: 20.r,
                          color: colors.accentGold,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          cubit.lockConfessionSanctuary();
                        },
                      ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Content: Locked vs Unlocked
                Expanded(
                  child: isUnlocked
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InabaReflectionComposerForm(
                                titleController: _titleController,
                                contentController: _contentController,
                                selectedMood: _selectedMood,
                                moodTags: _moodTags,
                                onMoodSelected: (m) =>
                                    setState(() => _selectedMood = m),
                                onSave: () => _onSaveReflection(cubit),
                                onClear: () {
                                  _titleController.clear();
                                  _contentController.clear();
                                },
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'خَوَاطِرُكَ المَحْفُوظَةُ (${reflections.length})',
                                style: AppTextStyles.titleMediumOf(context)
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                  color: colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              if (reflections.isEmpty)
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 24.h),
                                    child: Text(
                                      'لم تسجل أي خواطر بعد.. المحراب ينتظر صدقك',
                                      style: AppTextStyles.captionOf(context)
                                          .copyWith(
                                        color: colors.textSecondary,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...reflections.map((r) {
                                  return InabaReflectionCard(
                                    reflection: r,
                                    onDelete: () =>
                                        cubit.deleteReflection(r.id),
                                  );
                                }),
                            ],
                          ),
                        )
                      : InabaSanctuaryLockedView(
                          onUnlock: cubit.unlockConfessionSanctuary,
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';

class InabaAddDeedDialog extends StatefulWidget {
  final InabaCubit cubit;

  const InabaAddDeedDialog({
    super.key,
    required this.cubit,
  });

  static Future<void> show(BuildContext context, InabaCubit cubit) {
    return showDialog(
      context: context,
      builder: (ctx) => InabaAddDeedDialog(cubit: cubit),
    );
  }

  @override
  State<InabaAddDeedDialog> createState() => _InabaAddDeedDialogState();
}

class _InabaAddDeedDialogState extends State<InabaAddDeedDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
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
              controller: _titleController,
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
              controller: _categoryController,
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
            onPressed: () => Navigator.of(context).pop(),
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
              final title = _titleController.text.trim();
              final category = _categoryController.text.trim();
              if (title.isNotEmpty) {
                widget.cubit.addCustomGoodDeed(title, category);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'إضافة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}


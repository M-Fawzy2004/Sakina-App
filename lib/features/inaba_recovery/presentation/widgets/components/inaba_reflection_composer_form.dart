import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Form widget for composing new reflections with mood chips and inputs.
class InabaReflectionComposerForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String selectedMood;
  final List<String> moodTags;
  final ValueChanged<String> onMoodSelected;
  final VoidCallback onSave;
  final VoidCallback onClear;

  const InabaReflectionComposerForm({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.selectedMood,
    required this.moodTags,
    required this.onMoodSelected,
    required this.onSave,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mood Selector Pills
        Text(
          'حَالُ القَلْبِ الآن:',
          style: AppTextStyles.captionOf(context).copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          ),
        ),
        SizedBox(height: 6.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: moodTags.map((mood) {
              final isSelected = mood == selectedMood;
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
                      onMoodSelected(mood);
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
          controller: titleController,
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
          controller: contentController,
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
                  HapticFeedback.lightImpact();
                  onSave();
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
              onPressed: onClear,
              child: Text(
                'محو',
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


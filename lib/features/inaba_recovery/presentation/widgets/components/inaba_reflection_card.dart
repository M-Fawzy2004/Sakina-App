import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';

/// Card presenting a saved personal confession/reflection with mood tag and delete action.
class InabaReflectionCard extends StatelessWidget {
  final SpiritualReflectionEntity reflection;
  final VoidCallback onDelete;

  const InabaReflectionCard({
    super.key,
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
                    style: AppTextStyles.titleMediumOf(context).copyWith(
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
            style: AppTextStyles.bodyMediumOf(context).copyWith(
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


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';

class InabaCovenantRenewalSheet extends StatelessWidget {
  final List<RepentanceStepEntity> steps;
  final ValueChanged<String> onToggleStep;
  final VoidCallback onRenewCovenant;

  const InabaCovenantRenewalSheet({
    super.key,
    required this.steps,
    required this.onToggleStep,
    required this.onRenewCovenant,
  });

  static Future<void> show(
    BuildContext context, {
    required List<RepentanceStepEntity> steps,
    required ValueChanged<String> onToggleStep,
    required VoidCallback onRenewCovenant,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) => InabaCovenantRenewalSheet(
        steps: steps,
        onToggleStep: onToggleStep,
        onRenewCovenant: onRenewCovenant,
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
                    Iconsax.refresh_2,
                    size: 22.r,
                    color: colors.accentGold,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تَجْدِيدُ العَهْدِ وَالتَّوْبَةِ',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'ابدأ من جديد.. فالله يغفر ويقبل ويفرح بعودتك',
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

            // Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.3),
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    FlutterIslamicIcons.prayingPerson,
                    size: 24.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'كل ابن آدم خطاء، وخير الخطائين التوابون. لا تيأس أبداً، كل لحظة هي بداية مباركة.',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textPrimary,
                        fontSize: 12.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Steps Checklist
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: steps.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return _RepentanceStepTile(
                    step: step,
                    onToggle: () => onToggleStep(step.id),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),

            // Sincere Renewal Action Button
            SizedBox(
              width: double.infinity,
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
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).pop();
                  onRenewCovenant();
                },
                icon: Icon(
                  Iconsax.magic_star,
                  size: 20.r,
                  color: colors.background,
                ),
                label: Text(
                  'ابْدَأْ رِحْلَتِي مِنْ جَدِيدٍ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RepentanceStepTile extends StatelessWidget {
  final RepentanceStepEntity step;
  final VoidCallback onToggle;

  const _RepentanceStepTile({
    required this.step,
    required this.onToggle,
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
          onToggle();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: step.isCompleted
                ? colors.surfaceElevated
                : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: step.isCompleted
                  ? colors.accentGold
                  : colors.borderHairline,
              width: step.isCompleted ? 1.5.r : 1.r,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox indicator
              Container(
                width: 26.r,
                height: 26.r,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isCompleted
                      ? colors.accentGold
                      : colors.surfaceElevated,
                  border: Border.all(
                    color: step.isCompleted
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.tick_circle,
                    size: 16.r,
                    color: step.isCompleted
                        ? colors.background
                        : colors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Title, subtitle & evidence
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        color: colors.textPrimary,
                        decoration: step.isCompleted
                            ? TextDecoration.none
                            : TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      step.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      step.evidence,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.accentGold,
                        fontSize: 10.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

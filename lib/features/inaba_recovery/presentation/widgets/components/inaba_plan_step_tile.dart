import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';

/// Single interactive step tile within a spiritual recovery plan.
class InabaPlanStepTile extends StatelessWidget {
  final RecoveryPlanDayStepEntity step;
  final bool isLocked;
  final bool isCurrentDay;
  final bool isLockedUntilTomorrow;
  final VoidCallback onToggle;

  const InabaPlanStepTile({
    super.key,
    required this.step,
    required this.isLocked,
    required this.isCurrentDay,
    this.isLockedUntilTomorrow = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: step.isCompleted
              ? colors.accentEmerald.withValues(alpha: 0.08)
              : (isCurrentDay
                  ? colors.accentGold.withValues(alpha: 0.06)
                  : colors.cardSurface),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: step.isCompleted
                ? colors.accentEmerald.withValues(alpha: 0.5)
                : (isCurrentDay
                    ? colors.accentGold.withValues(alpha: 0.6)
                    : colors.borderHairline.withValues(alpha: 0.6)),
            width: (step.isCompleted || isCurrentDay) ? 1.2.r : 0.8.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepIndicator(
                  isCompleted: step.isCompleted,
                  isLocked: isLocked,
                  isCurrentDay: isCurrentDay,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _StepTitleRow(
                    title: step.title,
                    isCompleted: step.isCompleted,
                    isLocked: isLocked,
                    isCurrentDay: isCurrentDay,
                    isLockedUntilTomorrow: isLockedUntilTomorrow,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _StepActionText(
              action: step.practicalAction,
              isLocked: isLocked,
            ),
            if (step.recommendedDhikr.isNotEmpty) ...[
              SizedBox(height: 6.h),
              _StepDhikrBox(
                dhikr: step.recommendedDhikr,
                isLocked: isLocked,
              ),
            ],
            if (step.scripturalEvidence.isNotEmpty) ...[
              SizedBox(height: 6.h),
              _StepEvidenceText(
                evidence: step.scripturalEvidence,
                isLocked: isLocked,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrentDay;

  const _StepIndicator({
    required this.isCompleted,
    required this.isLocked,
    required this.isCurrentDay,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? colors.accentEmerald
            : colors.cardSurface.withValues(alpha: 0),
        border: Border.all(
          color: isCompleted
              ? colors.accentEmerald
              : (isLocked
                  ? colors.borderHairline
                  : (isCurrentDay ? colors.accentGold : colors.textSecondary)),
          width: 1.5.r,
        ),
      ),
      child: isCompleted
          ? Icon(Icons.check, size: 14.r, color: colors.background)
          : (isLocked
              ? Icon(Iconsax.lock, size: 12.r, color: colors.textSecondary)
              : (isCurrentDay
                  ? Icon(Iconsax.flash_1, size: 12.r, color: colors.accentGold)
                  : null)),
    );
  }
}

class _StepTitleRow extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrentDay;
  final bool isLockedUntilTomorrow;

  const _StepTitleRow({
    required this.title,
    required this.isCompleted,
    required this.isLocked,
    required this.isCurrentDay,
    this.isLockedUntilTomorrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.almarai(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isLocked
                  ? colors.textSecondary.withValues(alpha: 0.7)
                  : (isCompleted ? colors.accentEmerald : colors.textPrimary),
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        if (isCurrentDay && !isCompleted)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colors.accentGold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'اليوم الحالي',
              style: GoogleFonts.almarai(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: colors.accentGold,
              ),
            ),
          )
        else if (isLockedUntilTomorrow)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colors.accentGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: colors.accentGold.withValues(alpha: 0.3),
                width: 0.6.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.clock,
                  size: 10.r,
                  color: colors.accentGold,
                ),
                SizedBox(width: 4.w),
                Text(
                  'يُفتح غداً',
                  style: GoogleFonts.almarai(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.accentGold,
                  ),
                ),
              ],
            ),
          )
        else if (isLocked)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'مغلق',
              style: GoogleFonts.almarai(
                fontSize: 10.sp,
                color: colors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _StepActionText extends StatelessWidget {
  final String action;
  final bool isLocked;

  const _StepActionText({
    required this.action,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(right: 34.w),
      child: Text(
        action,
        style: GoogleFonts.almarai(
          fontSize: 11.5.sp,
          color: isLocked
              ? colors.textSecondary.withValues(alpha: 0.6)
              : colors.textSecondary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _StepDhikrBox extends StatelessWidget {
  final String dhikr;
  final bool isLocked;

  const _StepDhikrBox({
    required this.dhikr,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(right: 34.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          dhikr,
          style: AppTextStyles.quranAyahOf(context).copyWith(
            color: isLocked
                ? colors.textSecondary.withValues(alpha: 0.7)
                : colors.accentGold,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StepEvidenceText extends StatelessWidget {
  final String evidence;
  final bool isLocked;

  const _StepEvidenceText({
    required this.evidence,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(right: 34.w),
      child: Text(
        evidence,
        style: GoogleFonts.almarai(
          fontSize: 10.5.sp,
          color: isLocked
              ? colors.textSecondary.withValues(alpha: 0.5)
              : colors.accentGold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}


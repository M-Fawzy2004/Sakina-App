import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';

/// Immersive dedicated bottom sheet presenting all actionable tasks, dhikr, and evidences for a specific day.
/// Once completed, the day locks and the subsequent day will unlock on the next calendar day.
class InabaDailyTasksSheet extends StatefulWidget {
  final String planId;
  final int dayNumber;

  const InabaDailyTasksSheet({
    super.key,
    required this.planId,
    required this.dayNumber,
  });

  static Future<void> show(
    BuildContext context, {
    required String planId,
    required int dayNumber,
    required InabaCubit cubit,
  }) {
    final colors = context.colors;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: colors.cardSurface.withValues(alpha: 0),
      elevation: 0,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: InabaDailyTasksSheet(
          planId: planId,
          dayNumber: dayNumber,
        ),
      ),
    );
  }

  @override
  State<InabaDailyTasksSheet> createState() => _InabaDailyTasksSheetState();
}

class _InabaDailyTasksSheetState extends State<InabaDailyTasksSheet> {
  int _tasbihCount = 0;
  bool _practicalDone = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<InabaCubit, InabaState>(
      builder: (context, state) {
        final plan = state.recoveryPlans.firstWhere(
          (p) => p.id == widget.planId,
          orElse: () => state.recoveryPlans.first,
        );
        final step = plan.steps.firstWhere(
          (s) => s.dayNumber == widget.dayNumber,
          orElse: () => plan.steps.first,
        );
        final isCompleted = step.isCompleted;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            constraints: BoxConstraints(maxHeight: 0.90.sh),
            padding: EdgeInsets.only(
              left: 18.w,
              right: 18.w,
              top: 14.h,
              bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
            ),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              border: Border.all(
                color: colors.borderHairline.withValues(alpha: 0.7),
                width: 1.r,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Handle Bar
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
                SizedBox(height: 14.h),

                // Sheet Header Row
                _HeaderRow(
                  dayNumber: step.dayNumber,
                  totalDays: plan.steps.length,
                  isCompleted: isCompleted,
                  onClose: () => Navigator.of(context).pop(),
                ),
                SizedBox(height: 12.h),

                // Day Title Banner
                Text(
                  step.title,
                  style: GoogleFonts.almarai(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 14.h),

                // Scrollable Tasks List
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Task 1: Practical Action
                      _PracticalTaskCard(
                        actionText: step.practicalAction,
                        isChecked: _practicalDone || isCompleted,
                        onToggleCheck: isCompleted
                            ? null
                            : () {
                                HapticFeedback.selectionClick();
                                setState(() => _practicalDone = !_practicalDone);
                              },
                      ),
                      SizedBox(height: 12.h),

                      // Task 2: Recommended Dhikr & Tasbih Counter
                      if (step.recommendedDhikr.isNotEmpty) ...[
                        _DhikrTaskCard(
                          dhikrText: step.recommendedDhikr,
                          counter: _tasbihCount,
                          onIncrement: () {
                            HapticFeedback.lightImpact();
                            setState(() => _tasbihCount++);
                          },
                          onReset: () {
                            HapticFeedback.selectionClick();
                            setState(() => _tasbihCount = 0);
                          },
                        ),
                        SizedBox(height: 12.h),
                      ],

                      // Task 3: Scriptural Evidence
                      if (step.scripturalEvidence.isNotEmpty) ...[
                        _EvidenceTaskCard(evidenceText: step.scripturalEvidence),
                        SizedBox(height: 12.h),
                      ],

                      // Task 4: Intention & Spiritual Covenant Note
                      const _IntentionNoteCard(),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // Completion Action Button
                if (!isCompleted)
                  _FinishDayButton(
                    dayNumber: step.dayNumber,
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      final cubit = context.read<InabaCubit>();
                      await cubit.completePlanStep(widget.planId, widget.dayNumber);

                      if (context.mounted) {
                        AppTopSnackBar.showSuccess(
                          context: context,
                          message:
                              'هنيئاً لك إتمام مهام اليوم ${step.dayNumber}! ستُفتح مهام اليوم التالي غداً بإذن الله',
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  )
                else
                  _AlreadyCompletedBanner(dayNumber: step.dayNumber),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final int dayNumber;
  final int totalDays;
  final bool isCompleted;
  final VoidCallback onClose;

  const _HeaderRow({
    required this.dayNumber,
    required this.totalDays,
    required this.isCompleted,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isCompleted
                  ? colors.accentEmerald.withValues(alpha: 0.15)
                  : colors.accentGold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isCompleted
                    ? colors.accentEmerald.withValues(alpha: 0.4)
                    : colors.accentGold.withValues(alpha: 0.35),
                width: 0.8.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCompleted ? Iconsax.verify : Iconsax.calendar_1,
                  size: 14.r,
                  color: isCompleted ? colors.accentEmerald : colors.accentGold,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    'مَهَامُ اليَوْمِ $dayNumber مِنْ أصل $totalDays أَيَّام',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? colors.accentEmerald : colors.accentGold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Iconsax.close_circle,
            size: 22.r,
            color: colors.textSecondary,
          ),
          onPressed: onClose,
        ),
      ],
    );
  }
}

class _PracticalTaskCard extends StatelessWidget {
  final String actionText;
  final bool isChecked;
  final VoidCallback? onToggleCheck;

  const _PracticalTaskCard({
    required this.actionText,
    required this.isChecked,
    this.onToggleCheck,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isChecked
              ? colors.accentEmerald.withValues(alpha: 0.4)
              : colors.borderHairline.withValues(alpha: 0.7),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Iconsax.flash_1,
                  size: 16.r,
                  color: colors.accentGold,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'الخُطْوَةُ التَّطْبِيقِيَّةُ وَعَمَلُ اليَوْم',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.almarai(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            actionText,
            style: GoogleFonts.almarai(
              fontSize: 12.5.sp,
              color: colors.textPrimary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 10.h),
          InkWell(
            onTap: onToggleCheck,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isChecked
                    ? colors.accentEmerald.withValues(alpha: 0.12)
                    : colors.cardSurface,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isChecked
                      ? colors.accentEmerald.withValues(alpha: 0.5)
                      : colors.borderHairline,
                  width: 0.8.r,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isChecked ? Iconsax.tick_circle : Iconsax.record,
                    size: 18.r,
                    color: isChecked
                        ? colors.accentEmerald
                        : colors.textSecondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isChecked ? 'أتممت هذه الخطوة العملية' : 'تأكيد إتمام الخطوة',
                    style: GoogleFonts.almarai(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isChecked
                          ? colors.accentEmerald
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrTaskCard extends StatelessWidget {
  final String dhikrText;
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const _DhikrTaskCard({
    required this.dhikrText,
    required this.counter,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.accentEmerald.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.accentEmerald.withValues(alpha: 0.3),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: colors.accentEmerald.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Iconsax.heart,
                        size: 16.r,
                        color: colors.accentEmerald,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        'الوِرْدُ النَّبَوِيُّ وَذِكْرُ اليَوْمِ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.almarai(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.accentEmerald,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (counter > 0)
                GestureDetector(
                  onTap: onReset,
                  child: Text(
                    'إعادة ضبط',
                    style: GoogleFonts.almarai(
                      fontSize: 11.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            dhikrText,
            style: GoogleFonts.amiri(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              height: 1.7,
            ),
          ),
          SizedBox(height: 12.h),
          // Interactive Tasbih Disc
          InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: colors.accentEmerald.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.accentEmerald.withValues(alpha: 0.4),
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.refresh_2,
                    size: 16.r,
                    color: colors.accentEmerald,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تسبيح وحضور قلب: ',
                    style: GoogleFonts.almarai(
                      fontSize: 12.sp,
                      color: colors.accentEmerald,
                    ),
                  ),
                  Text(
                    '$counter',
                    style: GoogleFonts.almarai(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.accentEmerald,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidenceTaskCard extends StatelessWidget {
  final String evidenceText;

  const _EvidenceTaskCard({required this.evidenceText});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.7),
          width: 0.8.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.book_1,
                size: 16.r,
                color: colors.accentGold,
              ),
              SizedBox(width: 8.w),
              Text(
                'البُشْرَى وَالدَّلِيلُ الشَّرْعِيُّ',
                style: GoogleFonts.almarai(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            evidenceText,
            style: GoogleFonts.amiri(
              fontSize: 13.5.sp,
              color: colors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntentionNoteCard extends StatelessWidget {
  const _IntentionNoteCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.5),
          width: 0.8.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.shield_tick,
            size: 16.r,
            color: colors.accentGold,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'مسار العزم والتوبة مبنيٌّ يوماً بيوم؛ ترويض النفس يحتاج الصبر والتأني، والخطوة التالية تفتح في موعدها غداً بإذن الله لترسيخ الثبات.',
              style: GoogleFonts.almarai(
                fontSize: 11.sp,
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinishDayButton extends StatelessWidget {
  final int dayNumber;
  final VoidCallback onPressed;

  const _FinishDayButton({
    required this.dayNumber,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accentGold,
          foregroundColor: colors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.verify, size: 18.r),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                'إِتْمَامُ مَهَامِ اليَوْمِ $dayNumber',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.almarai(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlreadyCompletedBanner extends StatelessWidget {
  final int dayNumber;

  const _AlreadyCompletedBanner({required this.dayNumber});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.accentEmerald.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colors.accentEmerald.withValues(alpha: 0.4),
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.tick_circle,
            size: 20.r,
            color: colors.accentEmerald,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              'أتممت مهام اليوم $dayNumber بحمد الله • تفتح مهام الغد في موعدها',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.almarai(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: colors.accentEmerald,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


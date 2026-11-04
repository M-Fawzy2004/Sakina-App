import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/maladh/domain/entities/spiritual_habits_state.dart';
import 'package:sakina_app/features/maladh/domain/services/spiritual_habits_manager.dart';

/// "عَادَاتُ السَّكِينَةِ اليَوْمِيَّة" (Daily Spiritual Habit Tracker).
/// Tracks 3 essential, lightweight daily spiritual habits (Athkar, Quran, Witr/Istighfar)
/// with completion rings, streak tracking, and local midnight persistence.
class MaladhSpiritualHabitsCard extends StatefulWidget {
  const MaladhSpiritualHabitsCard({super.key});

  @override
  State<MaladhSpiritualHabitsCard> createState() =>
      _MaladhSpiritualHabitsCardState();
}

class _MaladhSpiritualHabitsCardState extends State<MaladhSpiritualHabitsCard> {
  late SpiritualHabitsState _state;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() {
    if (sl.isRegistered<PreferencesService>()) {
      _state = SpiritualHabitsManager.load(sl<PreferencesService>());
    } else {
      _state = SpiritualHabitsState.initial(SpiritualHabitsManager.todayString);
    }
  }

  Future<void> _toggleHabit({
    bool? athkar,
    bool? quran,
    bool? witr,
  }) async {
    HapticService.selectionClick();
    final wasAllCompleted = _state.isAllCompleted;

    final newState = _state.copyWith(
      athkarDone: athkar ?? _state.athkarDone,
      quranDone: quran ?? _state.quranDone,
      witrDone: witr ?? _state.witrDone,
    );

    setState(() => _state = newState);

    if (sl.isRegistered<PreferencesService>()) {
      await SpiritualHabitsManager.save(sl<PreferencesService>(), newState);
    }

    if (mounted && !wasAllCompleted && newState.isAllCompleted) {
      AppTopSnackBar.showSuccess(
        context: context,
        message: 'مَا شَاءَ اللَّهُ! أتممت عادات السكينة لليوم وثبتك الله على طاعته',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header: Title, Streak Badge & Fraction Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.status_up,
                        size: 18.r,
                        color: colors.accentGold,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'عَادَاتُ السَّكِينَةِ اليَوْمِيَّة',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: colors.accentGold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.4),
                      width: 0.8.r,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.magic_star,
                        size: 12.r,
                        color: colors.accentGold,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${_state.completedCount} من ${_state.totalCount}',
                        style: GoogleFonts.cairo(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 2. Segmented 3-Ring Visual Progress Bar
            Row(
              children: [
                _ProgressRingSegment(
                  title: 'الأذكار',
                  isCompleted: _state.athkarDone,
                  color: colors.accentGold,
                ),
                SizedBox(width: 6.w),
                _ProgressRingSegment(
                  title: 'القرآن',
                  isCompleted: _state.quranDone,
                  color: colors.accentEmerald,
                ),
                SizedBox(width: 6.w),
                _ProgressRingSegment(
                  title: 'الوتر/الاستغفار',
                  isCompleted: _state.witrDone,
                  color: colors.accentGold,
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 3. Three Interactive Daily Habit Tiles
            _HabitTile(
              icon: Iconsax.sun_1,
              title: 'أَذْكَارُ الصَّبَاحِ أَوِ المَسَاءِ',
              subtitle: 'حِصْنُ المُسْلِمِ وَطُمَأْنِينَةُ النَّفْس',
              isCompleted: _state.athkarDone,
              onToggle: () => _toggleHabit(athkar: !_state.athkarDone),
              onNavigate: () => context.push(AppRoutes.athkar),
            ),
            SizedBox(height: 8.h),
            _HabitTile(
              icon: FlutterIslamicIcons.quran2,
              title: 'قِرَاءَةُ صَفْحَةٍ مِنَ القُرْآنِ',
              subtitle: 'نُورُ القَلْبِ وَحَيَاةُ الرُّوح',
              isCompleted: _state.quranDone,
              onToggle: () => _toggleHabit(quran: !_state.quranDone),
              onNavigate: () => context.go(AppRoutes.quran),
            ),
            SizedBox(height: 8.h),
            _HabitTile(
              icon: Iconsax.moon,
              title: 'رَكْعَةُ الوِتْرِ أَوِ الاسْتِغْفَار',
              subtitle: 'خِتَامُ اليَوْمِ وَنَفَحَاتُ الأَسْحَار',
              isCompleted: _state.witrDone,
              onToggle: () => _toggleHabit(witr: !_state.witrDone),
              onNavigate: () => context.push(AppRoutes.inaba),
            ),

            // 4. Celebratory Hadith Banner on All Completed
            if (_state.isAllCompleted) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.35),
                    width: 0.8.r,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.heart5,
                      size: 14.r,
                      color: colors.accentGold,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'قال ﷺ: «أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ»',
                        style: GoogleFonts.amiri(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressRingSegment extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final Color color;

  const _ProgressRingSegment({
    required this.title,
    required this.isCompleted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 6.h,
        decoration: BoxDecoration(
          color: isCompleted ? color : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isCompleted
                ? color
                : colors.borderHairline.withValues(alpha: 0.5),
            width: 0.5.r,
          ),
        ),
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onNavigate;

  const _HabitTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onToggle,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isCompleted
              ? colors.accentGold.withValues(alpha: 0.08)
              : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isCompleted
                ? colors.accentGold.withValues(alpha: 0.45)
                : colors.borderHairline.withValues(alpha: 0.6),
            width: isCompleted ? 1.r : 0.8.r,
          ),
        ),
        child: Row(
          children: [
            // Circular Ring Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? colors.accentGold : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.2.r,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check_rounded,
                          size: 15.r,
                          color: colors.background,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Icon Badge
            Icon(
              icon,
              size: 16.r,
              color: isCompleted ? colors.accentGold : colors.textSecondary,
            ),
            SizedBox(width: 8.w),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: isCompleted
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isCompleted
                          ? colors.textPrimary
                          : colors.textSecondary,
                      decoration: isCompleted
                          ? TextDecoration.none
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 9.5.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Jump Shortcut
            IconButton(
              icon: Icon(
                Iconsax.arrow_left_2,
                size: 14.r,
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
              onPressed: onNavigate,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

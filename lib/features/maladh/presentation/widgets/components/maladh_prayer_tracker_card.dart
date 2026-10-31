import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/maladh/domain/entities/prayer_time_item.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_status_top_sheet.dart';

/// "مواقيت الصلاة وتتبع الفروض" - Daily prayer schedule and interactive tracker card.
/// Displays all 6 daily prayers with high-legibility English numerals,
/// completion checkmarks, active prayer highlight, and tap-to-complete interactions.
class MaladhPrayerTrackerCard extends StatefulWidget {
  final ValueChanged<String>? onPrayerToggled;

  const MaladhPrayerTrackerCard({super.key, this.onPrayerToggled});

  @override
  State<MaladhPrayerTrackerCard> createState() =>
      _MaladhPrayerTrackerCardState();
}

class _MaladhPrayerTrackerCardState extends State<MaladhPrayerTrackerCard> {
  late List<PrayerTimeItem> _prayers;

  @override
  void initState() {
    super.initState();
    _prayers = [
      const PrayerTimeItem(
        id: 'fajr',
        nameArabic: 'الْفَجْرُ',
        timeEnglish: '04:42 AM',
        isCompleted: false,
        isNext: true,
      ),
      const PrayerTimeItem(
        id: 'sunrise',
        nameArabic: 'الشُّرُوقُ',
        timeEnglish: '06:08 AM',
        isCompleted: false,
        isNext: false,
      ),
      const PrayerTimeItem(
        id: 'dhuhr',
        nameArabic: 'الظُّهْرُ',
        timeEnglish: '11:45 AM',
        isCompleted: false,
        isNext: false,
      ),
      const PrayerTimeItem(
        id: 'asr',
        nameArabic: 'الْعَصْرُ',
        timeEnglish: '02:55 PM',
        isCompleted: false,
        isNext: false,
      ),
      const PrayerTimeItem(
        id: 'maghrib',
        nameArabic: 'الْمَغْرِبُ',
        timeEnglish: '05:12 PM',
        isCompleted: false,
        isNext: false,
      ),
      const PrayerTimeItem(
        id: 'isha',
        nameArabic: 'الْعِشَاءُ',
        timeEnglish: '06:32 PM',
        isCompleted: false,
        isNext: false,
      ),
    ];
  }

  void _togglePrayerCompletion(int index) {
    HapticService.selectionClick();
    setState(() {
      _prayers = [
        for (int i = 0; i < _prayers.length; i++)
          if (i == index)
            _prayers[i].copyWith(isCompleted: !_prayers[i].isCompleted)
          else
            _prayers[i],
      ];
    });
    widget.onPrayerToggled?.call(_prayers[index].id);
  }

  void _setPrayerCompletion(int index, bool isCompleted) {
    HapticService.selectionClick();
    setState(() {
      _prayers = [
        for (int i = 0; i < _prayers.length; i++)
          if (i == index)
            _prayers[i].copyWith(isCompleted: isCompleted)
          else
            _prayers[i],
      ];
    });
    widget.onPrayerToggled?.call(_prayers[index].id);
  }

  void _openPrayerStatusModal(int index) {
    PrayerStatusTopSheet.show(
      context: context,
      prayer: _prayers[index],
      onStatusSelected: (bool isCompleted) {
        _setPrayerCompletion(index, isCompleted);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mandatoryPrayers = _prayers.where((p) => p.id != 'sunrise').toList();
    final completedCount = mandatoryPrayers.where((p) => p.isCompleted).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Bar: Title & Dynamic Prayer Progress Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right Side: Clock Icon + Section Title (RTL Start)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.clock, color: colors.accentGold, size: 19.r),
                    SizedBox(width: 8.w),
                    Text(
                      'مَوَاقِيتُ الصَّلَاةِ',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.textPrimary,
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Left Side: Completed Count Badge (RTL End)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: completedCount == 5
                          ? colors.accentEmerald
                          : colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    'أُدِّيَت $completedCount من 5',
                    style: AppTextStyles.caption.copyWith(
                      color: completedCount == 5
                          ? colors.accentEmerald
                          : colors.accentGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSm,

            // 2. The 6 Prayers Horizontal Grid Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_prayers.length, (index) {
                final prayer = _prayers[index];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: _PrayerSlotItem(
                      prayer: prayer,
                      onTap: () => _openPrayerStatusModal(index),
                      onQuickToggle: () => _togglePrayerCompletion(index),
                    ),
                  ),
                );
              }),
            ),

            AppSpacing.verticalSm,

            // 3. Bottom Guide Note
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.finger_cricle,
                      color: colors.accentGold,
                      size: 13.r,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'اضغط لتحديد (أُدِّيَت ✓ / لم تُؤَدَّ) • المس الدائرة للتبديل السريع',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerSlotItem extends StatelessWidget {
  final PrayerTimeItem prayer;
  final VoidCallback onTap;
  final VoidCallback onQuickToggle;

  const _PrayerSlotItem({
    required this.prayer,
    required this.onTap,
    required this.onQuickToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isNext = prayer.isNext;
    final isCompleted = prayer.isCompleted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onQuickToggle,
        borderRadius: BorderRadius.circular(14.r),
        splashColor: colors.accentGold.withValues(alpha: 0.1),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isCompleted
                ? colors.accentEmerald.withValues(alpha: 0.15)
                : (isNext
                      ? colors.accentGold.withValues(alpha: 0.18)
                      : colors.surfaceElevated),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isCompleted
                  ? colors.accentEmerald
                  : (isNext ? colors.accentGold : colors.borderHairline),
              width: 1.r,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Prayer Name (Arabic)
              Text(
                prayer.nameArabic,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: isCompleted
                      ? colors.accentEmerald
                      : (isNext ? colors.accentGold : colors.textPrimary),
                  fontWeight: (isNext || isCompleted)
                      ? FontWeight.w800
                      : FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),

              SizedBox(height: 6.h),

              // Status Badge
              GestureDetector(
                onTap: onQuickToggle,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? colors.accentEmerald
                        : (isNext
                              ? colors.accentGold.withValues(alpha: 0.2)
                              : Colors.transparent),
                    border: Border.all(
                      color: isCompleted
                          ? colors.accentEmerald
                          : (isNext
                                ? colors.accentGold
                                : colors.borderHairline),
                      width: 1.2.r,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(
                            Iconsax.tick_circle,
                            color: colors.background,
                            size: 16.r,
                          )
                        : (isNext
                              ? Container(
                                  width: 6.r,
                                  height: 6.r,
                                  decoration: BoxDecoration(
                                    color: colors.accentGold,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : const SizedBox.shrink()),
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Status Tag: "أُدِّيَت" vs "لم تُؤَدَّ"
              Text(
                isCompleted ? 'أُدِّيَت' : (isNext ? 'القادمة' : 'لم تُؤَدَّ'),
                style: AppTextStyles.caption.copyWith(
                  color: isCompleted
                      ? colors.accentEmerald
                      : (isNext ? colors.accentGold : colors.textSecondary),
                  fontSize: 9.sp,
                  fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
                ),
              ),

              SizedBox(height: 4.h),

              // English Clock Time
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  prayer.timeEnglish.replaceAll(' ', '\n'),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textPrimary,
                    fontWeight: isNext ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 9.5.sp,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

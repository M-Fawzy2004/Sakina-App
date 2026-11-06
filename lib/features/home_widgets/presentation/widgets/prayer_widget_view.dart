import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/widget_common.dart';

// ─── PRIVATE ATOMIC COMPONENTS ────────────────────────────────────────────────

IconData _prayerIcon(String name) {
  if (name.contains('فجر')) return Icons.brightness_low_rounded;
  if (name.contains('شروق')) return Icons.wb_twilight_rounded;
  if (name.contains('ظهر')) return Icons.light_mode_rounded;
  if (name.contains('عصر')) return Icons.wb_sunny_outlined;
  if (name.contains('مغرب')) return Icons.wb_twilight_rounded;
  return Icons.nightlight_round;
}

class _TimeText extends StatelessWidget {
  final String time;
  final double mainSize;
  final double suffixSize;
  final Color color;
  final Color suffixColor;
  final bool inline;

  const _TimeText({
    required this.time,
    required this.mainSize,
    required this.suffixSize,
    required this.color,
    required this.suffixColor,
    this.inline = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = splitTime12(time);
    final main = Text(
      t.main,
      style: GoogleFonts.almarai(
        fontSize: mainSize,
        color: color,
        fontWeight: FontWeight.bold,
        height: 1.1,
      ),
      maxLines: 1,
    );
    if (t.suffix.isEmpty) return main;
    final suffix = Text(
      t.suffix,
      style: GoogleFonts.almarai(
        fontSize: suffixSize,
        color: suffixColor,
        fontWeight: FontWeight.w600,
        height: 1.1,
      ),
      maxLines: 1,
    );
    if (inline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [main, const SizedBox(width: 3), suffix],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [main, const SizedBox(height: 1), suffix],
    );
  }
}

class _PrayerHeader extends StatelessWidget {
  final String cityName;
  final String hijriDate;
  static const double fontSize = 12;

  const _PrayerHeader({
    required this.cityName,
    required this.hijriDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.champagneGold,
                size: fontSize + 2,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  cityName,
                  style: GoogleFonts.almarai(
                    fontSize: fontSize,
                    color: AppColors.pureChalk,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            hijriDate,
            style: GoogleFonts.almarai(
              fontSize: fontSize - 1.5,
              color: AppColors.champagneGold,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// One column of the horizontal (4×2) layout.
class _PrayerColumn extends StatelessWidget {
  final WidgetPrayerItem prayer;

  const _PrayerColumn({required this.prayer});

  @override
  Widget build(BuildContext context) {
    final isNext = prayer.isNext;
    final accent = isNext ? AppColors.champagneGold : AppColors.pureChalk;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isNext
              ? AppColors.champagneGold.withValues(alpha: 0.12)
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(13),
          border: isNext
              ? Border.all(
                  color: AppColors.champagneGold.withValues(alpha: 0.85),
                  width: 1.2,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _prayerIcon(prayer.name),
              size: 18,
              color: isNext ? AppColors.champagneGold : AppColors.mutedSilver,
            ),
            const SizedBox(height: 5),
            Text(
              prayer.name,
              style: GoogleFonts.almarai(
                fontSize: 11,
                color: accent,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            _TimeText(
              time: prayer.time,
              mainSize: 12.5,
              suffixSize: 8.5,
              color: accent,
              suffixColor:
                  isNext ? AppColors.champagneGold : AppColors.mutedSilver,
            ),
          ],
        ),
      ),
    );
  }
}

/// One row of the vertical (4×4) layout.
class _PrayerRow extends StatelessWidget {
  final WidgetPrayerItem prayer;

  const _PrayerRow({required this.prayer});

  @override
  Widget build(BuildContext context) {
    final isNext = prayer.isNext;
    final accent = isNext ? AppColors.champagneGold : AppColors.pureChalk;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isNext
            ? AppColors.champagneGold.withValues(alpha: 0.12)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(
                color: AppColors.champagneGold.withValues(alpha: 0.8),
                width: 1.1,
              )
            : null,
      ),
      child: Row(
        children: [
          Icon(
            _prayerIcon(prayer.name),
            size: 16,
            color: isNext ? AppColors.champagneGold : AppColors.mutedSilver,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              prayer.name,
              style: GoogleFonts.almarai(
                fontSize: 13.5,
                color: accent,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          _TimeText(
            time: prayer.time,
            mainSize: 13.5,
            suffixSize: 9.5,
            color: accent,
            suffixColor:
                isNext ? AppColors.champagneGold : AppColors.mutedSilver,
            inline: true,
          ),
        ],
      ),
    );
  }
}

// ─── PRAYER LARGE (4×4) ─────────────────────────────────────────────────────

class PrayerLargeWidgetView extends StatelessWidget {
  final WidgetPrayerData data;

  const PrayerLargeWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 360,
          height: 360,
          child: WidgetFrame(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PrayerHeader(
                  cityName: data.cityName,
                  hijriDate: data.hijriDate,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.charcoalCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.champagneGold.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              AppColors.champagneGold.withValues(alpha: 0.12),
                          border: Border.all(
                            color:
                                AppColors.champagneGold.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _prayerIcon(data.nextPrayerName),
                          color: AppColors.champagneGold,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'الصلاة القادمة',
                              style: GoogleFonts.almarai(
                                fontSize: 10.5,
                                color: AppColors.champagneGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              data.nextPrayerName,
                              style: GoogleFonts.almarai(
                                fontSize: 22,
                                color: AppColors.pureChalk,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _TimeText(
                            time: data.nextPrayerTime,
                            mainSize: 18,
                            suffixSize: 11,
                            color: AppColors.champagneGold,
                            suffixColor: AppColors.champagneGold,
                            inline: true,
                          ),
                          const SizedBox(height: 5),
                          WidgetPill(
                            text: data.remainingCountdown,
                            fontSize: 9.5,
                            filled: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const OrnamentDivider(),
                const SizedBox(height: 6),
                Expanded(
                  child: Column(
                    children: [
                      for (final p in data.prayers)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.5),
                            child: _PrayerRow(prayer: p),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── PRAYER MEDIUM (4×2) — horizontal timetable ─────────────────────────────

class PrayerMediumWidgetView extends StatelessWidget {
  final WidgetPrayerData data;

  const PrayerMediumWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 360,
          height: 170,
          child: WidgetFrame(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _PrayerHeader(
                    cityName: data.cityName,
                    hijriDate: data.hijriDate,
                  ),
                ),
                const SizedBox(height: 7),
                Expanded(
                  child: Row(
                    children: [
                      for (final p in data.prayers) _PrayerColumn(prayer: p),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'الأذان القادم: ${data.nextPrayerName} ${data.remainingCountdown}',
                          style: GoogleFonts.almarai(
                            fontSize: 9.5,
                            color: AppColors.mutedSilver,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const WidgetBrandMark(fontSize: 11),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── PRAYER SMALL (2×2) ─────────────────────────────────────────────────────

class PrayerSmallWidgetView extends StatelessWidget {
  final WidgetPrayerData data;

  const PrayerSmallWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 170,
          height: 170,
          child: WidgetFrame(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: WidgetTitle(
                        icon: Icons.access_time_filled_rounded,
                        text: 'الصلاة القادمة',
                        fontSize: 9.5,
                        iconSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (data.cityName.isNotEmpty)
                      Flexible(
                        child: Text(
                          data.cityName,
                          style: GoogleFonts.almarai(
                            fontSize: 9,
                            color: AppColors.mutedSilver,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                const OrnamentDivider(),
                Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.champagneGold.withValues(alpha: 0.12),
                            border: Border.all(
                              color: AppColors.champagneGold.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _prayerIcon(data.nextPrayerName),
                            color: AppColors.champagneGold,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.nextPrayerName,
                                style: GoogleFonts.almarai(
                                  fontSize: 18,
                                  color: AppColors.pureChalk,
                                  fontWeight: FontWeight.bold,
                                  height: 1.15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              _TimeText(
                                time: data.nextPrayerTime,
                                mainSize: 14,
                                suffixSize: 8.5,
                                color: AppColors.champagneGold,
                                suffixColor: AppColors.champagneGold,
                                inline: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: WidgetPill(
                        text: data.remainingCountdown,
                        fontSize: 8.5,
                        filled: true,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const WidgetBrandMark(fontSize: 8.5),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';

// ─── Shared design tokens ────────────────────────────────────────────────────
const _kBg = Color(0xFF0C1120);
const _kCard = Color(0xFF141B2D);
const _kGold = Color(0xFFD4AF37);
const _kText = Colors.white;
const _kSubText = Color(0xFF94A3B8);
const _kBlue = Color(0xFF38BDF8);
const _kBorder = Color(0x1FD4AF37);
const _kNextHighlight = Color(0x22D4AF37);

TextStyle _almarai({
  double size = 13,
  Color color = _kText,
  FontWeight weight = FontWeight.w500,
  double height = 1.4,
}) =>
    GoogleFonts.almarai(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    );

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
        child: Container(
          width: 360,
          height: 360,
          color: _kBg,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top Bar: City & Hijri Date ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: _kGold,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            data.cityName,
                            style: _almarai(
                                size: 13,
                                color: _kText,
                                weight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    data.hijriDate,
                    style: _almarai(size: 11, color: _kGold),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Next Prayer Hero Card ────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kGold.withAlpha(80)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: label + name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الصلاة القادمة',
                            style: _almarai(
                                size: 10,
                                color: _kBlue,
                                weight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.nextPrayerName,
                            style: _almarai(
                                size: 20,
                                color: _kText,
                                weight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Right: time + countdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          data.nextPrayerTime,
                          style: _almarai(
                              size: 20, color: _kGold, weight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _kBlue.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'متبقي ${data.remainingCountdown}',
                            style: _almarai(
                                size: 10,
                                color: _kBlue,
                                weight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── Thin divider ─────────────────────────────────────────────
              Container(height: 1, color: _kBorder),
              const SizedBox(height: 6),

              // ── Prayer List ──────────────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: data.prayers.map((prayer) {
                    final isNext = prayer.isNext;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isNext ? _kNextHighlight : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isNext
                            ? Border.all(color: _kGold.withAlpha(60))
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prayer.name,
                            style: _almarai(
                              size: 13,
                              color: isNext ? _kGold : _kText,
                              weight: isNext
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                          Text(
                            prayer.time,
                            style: _almarai(
                              size: 13,
                              color: isNext ? _kGold : _kSubText,
                              weight: isNext
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PRAYER MEDIUM (4×2) ────────────────────────────────────────────────────
class PrayerMediumWidgetView extends StatelessWidget {
  final WidgetPrayerData data;

  const PrayerMediumWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 360,
          height: 170,
          color: _kBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── City & Hijri ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: _kGold, size: 13),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            data.cityName,
                            style: _almarai(
                                size: 12,
                                color: _kText,
                                weight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(data.hijriDate,
                      style: _almarai(size: 10, color: _kSubText)),
                ],
              ),
              const SizedBox(height: 8),

              // ── Two-column layout ────────────────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: Next prayer (hero)
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _kGold.withAlpha(80)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'الصلاة القادمة',
                              style: _almarai(
                                  size: 10,
                                  color: _kBlue,
                                  weight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.nextPrayerName,
                              style: _almarai(
                                  size: 17,
                                  color: _kGold,
                                  weight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.nextPrayerTime,
                              style: _almarai(
                                  size: 13,
                                  color: _kText,
                                  weight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'فاضل ${data.remainingCountdown}',
                              style: _almarai(
                                  size: 10,
                                  color: _kBlue,
                                  weight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Right: Previous prayer
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _kCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'الصلاة السابقة',
                              style: _almarai(size: 10, color: _kSubText),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.previousPrayerName,
                              style: _almarai(
                                  size: 14,
                                  color: _kText,
                                  weight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.previousPrayerTime,
                              style: _almarai(size: 11, color: _kSubText),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
        child: Container(
          width: 170,
          height: 170,
          color: _kBg,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // City
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: _kGold, size: 12),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      data.cityName,
                      style: _almarai(size: 10, color: _kSubText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Prayer name & time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الصلاة القادمة',
                    style:
                        _almarai(size: 9, color: _kBlue, weight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.nextPrayerName,
                    style:
                        _almarai(size: 20, color: _kGold, weight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.nextPrayerTime,
                    style:
                        _almarai(size: 15, color: _kText, weight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              // Countdown pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kBlue.withAlpha(28),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'متبقي ${data.remainingCountdown}',
                  style: _almarai(
                      size: 9.5, color: _kBlue, weight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

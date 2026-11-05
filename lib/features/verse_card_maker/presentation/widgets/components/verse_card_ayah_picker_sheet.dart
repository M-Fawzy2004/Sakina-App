import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/arabic_text_utils.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_surahs_seed_data.dart';
import 'package:sakina_app/features/quran_reading/data/models/ayah_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/surah_model.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';

/// Luxury bottom sheet for selecting any Surah and Ayah / Range of Ayahs
/// for rendering on high-definition cards or video reels.
class VerseCardAyahPickerSheet extends StatefulWidget {
  final bool isVideoMode;
  final int videoDurationSeconds;
  final ValueChanged<VerseCardItem> onVerseSelected;

  const VerseCardAyahPickerSheet({
    super.key,
    required this.isVideoMode,
    this.videoDurationSeconds = 0,
    required this.onVerseSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required bool isVideoMode,
    int videoDurationSeconds = 0,
    required ValueChanged<VerseCardItem> onVerseSelected,
  }) {
    HapticService.selectionClick();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VerseCardAyahPickerSheet(
        isVideoMode: isVideoMode,
        videoDurationSeconds: videoDurationSeconds,
        onVerseSelected: onVerseSelected,
      ),
    );
  }

  @override
  State<VerseCardAyahPickerSheet> createState() =>
      _VerseCardAyahPickerSheetState();
}

class _VerseCardAyahPickerSheetState extends State<VerseCardAyahPickerSheet> {
  late SurahModel _selectedSurah;
  int _startAyah = 1;
  int _endAyah = 1;
  List<AyahModel> _surahVerses = [];
  bool _isLoadingVerses = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedSurah = kDefaultSurahsList.first;
    _loadSurahVerses(_selectedSurah.id);
  }

  Future<void> _loadSurahVerses(int surahId) async {
    setState(() => _isLoadingVerses = true);
    try {
      final verses = await sl<QuranLocalDataSource>().getSurahVerses(surahId);
      if (mounted) {
        setState(() {
          _surahVerses = verses;
          _startAyah = 1;
          _endAyah = widget.isVideoMode && verses.length >= 2 ? 2 : 1;
          _isLoadingVerses = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingVerses = false);
    }
  }

  String _buildCompositeText() {
    if (_surahVerses.isEmpty) return '';
    final maxIdx = _surahVerses.length;
    final start = (_startAyah - 1).clamp(0, maxIdx - 1);
    final end = _endAyah.clamp(_startAyah, maxIdx);
    final slice = _surahVerses.sublist(start, end);

    if (slice.isEmpty) return '';
    if (slice.length == 1) return slice.first.text;

    return slice.map((v) => '${v.text} \u06DD').join(' ');
  }

  int _calculateEstimatedDuration() {
    final count = (_endAyah - _startAyah + 1).clamp(1, 10);
    return count * 7;
  }

  void _handleConfirm() {
    HapticService.selectionClick();
    final isRange = widget.isVideoMode && _endAyah > _startAyah;
    final maxIdx = _surahVerses.length;
    final start = (_startAyah - 1).clamp(0, maxIdx - 1);
    final end = _endAyah.clamp(_startAyah, maxIdx);
    final slice = _surahVerses.sublist(start, end);

    final List<String> individualTexts = slice.map((v) => v.text).toList();
    final text = _buildCompositeText();
    final estimatedDuration = _calculateEstimatedDuration();

    final item = VerseCardItem(
      surahNumber: _selectedSurah.id,
      ayahNumber: _startAyah,
      endAyahNumber: isRange ? _endAyah : null,
      surahName: _selectedSurah.nameArabic,
      ayahText: text,
      theme: 'سورة ${_selectedSurah.nameArabic}',
      durationSeconds: estimatedDuration,
      versesTextList: individualTexts,
    );

    widget.onVerseSelected(item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final normalizedQuery = ArabicTextUtils.normalize(_searchQuery.trim());
    final filteredSurahs = kDefaultSurahsList.where((s) {
      if (normalizedQuery.isEmpty) return true;
      final ar = ArabicTextUtils.normalize(s.nameArabic).contains(normalizedQuery);
      final en = s.englishName.toLowerCase().contains(_searchQuery.toLowerCase());
      final id = s.id.toString() == _searchQuery.trim();
      return ar || en || id;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 620.h,
        margin: EdgeInsets.only(bottom: bottomInset),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: colors.borderHairline, width: 1.r),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.borderHairline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 10.h),

            // Header title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.book_1, size: 18.r, color: colors.accentGold),
                    SizedBox(width: 8.w),
                    Text(
                      widget.isVideoMode
                          ? 'اخْتِيَارُ آيَاتِ الفِيدْيُو'
                          : 'اخْتِيَارُ آيَةِ البِطَاقَةِ',
                      style: GoogleFonts.cairo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.isVideoMode ? 'آيات متعددة حسب مدة الفيديو' : 'آية فردية للتصميم',
                  style: GoogleFonts.cairo(
                    fontSize: 10.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Surah search bar
            Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colors.borderHairline, width: 0.8.r),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.search_normal, size: 16.r, color: colors.textSecondary),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ابحث باسم السورة أو رقمها...',
                        hintStyle: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          color: colors.textSecondary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Horizontal Surahs Pills
            SizedBox(
              height: 38.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: filteredSurahs.length,
                separatorBuilder: (_, _) => SizedBox(width: 6.w),
                itemBuilder: (ctx, idx) {
                  final s = filteredSurahs[idx];
                  final isSel = s.id == _selectedSurah.id;
                  return GestureDetector(
                    onTap: () {
                      HapticService.selectionClick();
                      setState(() => _selectedSurah = s);
                      _loadSurahVerses(s.id);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isSel
                            ? colors.accentGold.withValues(alpha: 0.18)
                            : colors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSel ? colors.accentGold : colors.borderHairline,
                          width: 1.r,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${s.id}. ${s.nameArabic}',
                          style: GoogleFonts.cairo(
                            fontSize: 11.sp,
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                            color: isSel ? colors.accentGold : colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),

            // Ayah Range Selectors
            if (_isLoadingVerses)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Start Ayah Slider / Selector
                    _AyahNumberSelector(
                      label: widget.isVideoMode ? 'مِنَ الآيَةِ رَقْم:' : 'رَقْمُ الآيَةِ:',
                      value: _startAyah,
                      max: _surahVerses.length,
                      accentColor: colors.accentGold,
                      colors: colors,
                      onChanged: (v) {
                        setState(() {
                          _startAyah = v;
                          if (_endAyah < _startAyah) _endAyah = _startAyah;
                        });
                      },
                    ),

                    if (widget.isVideoMode) ...[
                      SizedBox(height: 8.h),
                      _AyahNumberSelector(
                        label: 'إِلَى الآيَةِ رَقْم:',
                        value: _endAyah,
                        min: _startAyah,
                        max: _surahVerses.length,
                        accentColor: colors.accentGold,
                        colors: colors,
                        onChanged: (v) => setState(() => _endAyah = v),
                      ),
                      SizedBox(height: 8.h),

                      // Duration Harmony Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: colors.borderHairline, width: 0.8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'عَدَدُ الآيَاتِ: ${_endAyah - _startAyah + 1}',
                              style: GoogleFonts.cairo(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              'التِّلَاوَةُ: ~${_calculateEstimatedDuration()}ث'
                              '${widget.videoDurationSeconds > 0 ? " | الفِيدْيُو: ${widget.videoDurationSeconds}ث" : ""}',
                              style: GoogleFonts.cairo(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.accentGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 10.h),

                    // Live Verse Scripture Preview
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.borderHairline, width: 0.8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.eye, size: 14.r, color: colors.textSecondary),
                              SizedBox(width: 6.w),
                              Text(
                                'مُعَايَنَةُ النَّصِّ القُرْآنِيِّ:',
                                style: GoogleFonts.cairo(
                                  fontSize: 10.5.sp,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _buildCompositeText(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              height: 2.0,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 10.h),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accentGold,
                  foregroundColor: colors.background,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: _surahVerses.isEmpty ? null : _handleConfirm,
                icon: Icon(Iconsax.tick_circle, size: 18.r, color: colors.background),
                label: Text(
                  'تَأْكِيدُ اخْتِيَارِ الآيَاتِ',
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
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

class _AyahNumberSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Color accentColor;
  final AppColorsScheme colors;
  final ValueChanged<int> onChanged;

  const _AyahNumberSelector({
    required this.label,
    required this.value,
    this.min = 1,
    required this.max,
    required this.accentColor,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (max <= 0) return const SizedBox.shrink();

    return Row(
      children: [
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Iconsax.minus_cirlce, size: 20.r, color: accentColor),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: colors.borderHairline, width: 0.8.r),
          ),
          child: Text(
            '$value / $max',
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Iconsax.add_circle, size: 20.r, color: accentColor),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: accentColor,
              inactiveTrackColor: colors.borderHairline,
              thumbColor: accentColor,
              trackHeight: 3.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
            ),
            child: Slider(
              value: value.toDouble().clamp(min.toDouble(), max.toDouble()),
              min: min.toDouble(),
              max: max.toDouble() > min.toDouble() ? max.toDouble() : (min + 1).toDouble(),
              divisions: (max - min) > 0 ? (max - min) : 1,
              onChanged: (val) => onChanged(val.round().clamp(min, max)),
            ),
          ),
        ),
      ],
    );
  }
}


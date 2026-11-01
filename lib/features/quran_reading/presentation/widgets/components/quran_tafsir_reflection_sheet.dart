import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/tafsir_entity.dart';

/// Clean, minimalistic, scrollable Tafsir & Reflection Bottom Sheet:
/// - Constrained to a max height of ~75% of the screen height (between 0.7 and 0.8)
/// - Pure Tafsir & Tadabbur reading experience without audio recorder or large verse box
/// - Instant local switching between exegeses (المختصر، الجلالين، السعدي)
/// - Fluid bouncing scrollable area preventing any viewport overflow
class QuranTafsirReflectionSheet extends StatefulWidget {
  final SurahEntity surah;
  final AyahEntity ayah;
  final VoidCallback onClose;

  const QuranTafsirReflectionSheet({
    super.key,
    required this.surah,
    required this.ayah,
    required this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required SurahEntity surah,
    required AyahEntity ayah,
  }) {
    HapticService.lightImpact();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (modalContext) => QuranTafsirReflectionSheet(
        surah: surah,
        ayah: ayah,
        onClose: () => Navigator.of(modalContext).pop(),
      ),
    );
  }

  @override
  State<QuranTafsirReflectionSheet> createState() =>
      _QuranTafsirReflectionSheetState();
}

class _QuranTafsirReflectionSheetState extends State<QuranTafsirReflectionSheet> {
  int _selectedTafsirIndex = 0;

  TafsirEntity? get _currentTafsir {
    if (widget.ayah.tafsirs.isEmpty) return null;
    final clamped = _selectedTafsirIndex.clamp(0, widget.ayah.tafsirs.length - 1);
    return widget.ayah.tafsirs[clamped];
  }

  String get _currentTafsirText {
    final tafsir = _currentTafsir;
    if (tafsir != null && tafsir.text.trim().isNotEmpty) {
      return tafsir.text.trim();
    }
    return widget.ayah.tafsir ??
        'الآية الكريمة تتضمن بياناً شاملاً من آيات الذكر الحكيم، تزيد القلب إيماناً ورسوخاً.';
  }

  String get _currentTafsirType {
    final tafsir = _currentTafsir;
    if (tafsir != null && tafsir.type.trim().isNotEmpty) {
      return tafsir.type.trim();
    }
    return 'التَّفْسِيرُ المَيْسَر';
  }

  void _copyTafsir(BuildContext context) {
    final colors = context.colors;
    HapticService.selectionClick();

    final copyText =
        '«سورة ${widget.surah.nameArabic} - الآية ${widget.ayah.numberInSurah}»\n\n'
        '$_currentTafsirType:\n$_currentTafsirText'
        '${widget.ayah.reflection != null ? "\n\nالتدبر:\n${widget.ayah.reflection}" : ""}';

    Clipboard.setData(ClipboardData(text: copyText));

    AppTopSnackBar.show(
      context: context,
      message: 'تم نسخ نص التفسير بنجاح ✓',
      icon: Iconsax.copy,
      iconColor: colors.accentEmerald,
      backgroundColor: colors.cardSurface,
      borderColor: colors.accentEmerald,
      textColor: colors.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxSheetHeight = screenHeight * 0.75;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxSheetHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
          border: Border.all(color: colors.borderHairline, width: 1.r),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Drag Handle Pill
              const _SheetDragHandle(),

              // 2. Surah & Ayah Title Bar with Close Button
              _TafsirHeader(
                surah: widget.surah,
                ayah: widget.ayah,
                onClose: widget.onClose,
              ),

              // 3. Tafsir Variant Selector Chips (when multiple exegeses exist)
              if (widget.ayah.tafsirs.length > 1) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  child: _TafsirTypeChips(
                    tafsirs: widget.ayah.tafsirs,
                    selectedIndex: _selectedTafsirIndex,
                    onSelected: (idx) {
                      setState(() {
                        _selectedTafsirIndex = idx;
                      });
                    },
                  ),
                ),
              ],

              Divider(
                color: colors.borderHairline.withValues(alpha: 0.6),
                height: 12.h,
                thickness: 0.8.r,
              ),

              // 4. Smooth Scrollable Tafsir & Reflection Body
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tafsir Body Card
                      _TafsirBodyCard(
                        tafsirType: _currentTafsirType,
                        tafsirText: _currentTafsirText,
                      ),

                      // Optional Spiritual Reflection (التدبر الإيماني)
                      if (widget.ayah.reflection != null &&
                          widget.ayah.reflection!.trim().isNotEmpty) ...[
                        AppSpacing.verticalSm,
                        _SpiritualReflectionCard(
                          reflectionText: widget.ayah.reflection!.trim(),
                        ),
                      ],

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),

              // 5. Bottom Action Bar (Copy, Reference)
              _TafsirBottomBar(
                ayah: widget.ayah,
                onCopy: () => _copyTafsir(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Center-aligned drag handle pill for sheet gesture dismissal.
class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
      child: Center(
        child: Container(
          width: 42.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: colors.textSecondary.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

/// Header row presenting Ayah number badge, Surah title, and close button.
class _TafsirHeader extends StatelessWidget {
  final SurahEntity surah;
  final AyahEntity ayah;
  final VoidCallback onClose;

  const _TafsirHeader({
    required this.surah,
    required this.ayah,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.accentGold,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${ayah.numberInSurah}',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.accentGold,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سُورَةُ ${surah.nameArabic}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    'الآية ${ayah.numberInSurah} • صَفْحَةُ ${ayah.page} • جُزْءُ ${ayah.juz}',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.accentGold,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Iconsax.close_circle,
              color: colors.textSecondary,
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal selector chips for Tafsir schools (المختصر، السعدي، الجلالين).
class _TafsirTypeChips extends StatelessWidget {
  final List<TafsirEntity> tafsirs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TafsirTypeChips({
    required this.tafsirs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tafsirs.length, (index) {
          final isSelected = index == selectedIndex;
          final item = tafsirs[index];

          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: InkWell(
              onTap: () {
                HapticService.selectionClick();
                onSelected(index);
              },
              borderRadius: BorderRadius.circular(10.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.accentEmerald.withValues(alpha: 0.16)
                      : colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected
                        ? colors.accentEmerald
                        : colors.borderHairline,
                    width: isSelected ? 1.2.r : 0.8.r,
                  ),
                ),
                child: Text(
                  item.type,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? colors.accentEmerald
                        : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11.5.sp,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Dedicated card presenting the authentic exegesis with high-legibility typography.
class _TafsirBodyCard extends StatelessWidget {
  final String tafsirType;
  final String tafsirText;

  const _TafsirBodyCard({
    required this.tafsirType,
    required this.tafsirText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.borderHairline, width: 1.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tafsirType,
                style: AppTextStyles.caption.copyWith(
                  color: colors.accentGold,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5.sp,
                ),
              ),
              Icon(
                Iconsax.book_1,
                color: colors.accentGold,
                size: 17.r,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            tafsirText,
            style: GoogleFonts.cairo(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
              height: 1.85,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Callout card displaying spiritual contemplation (التدبر الإيماني).
class _SpiritualReflectionCard extends StatelessWidget {
  final String reflectionText;

  const _SpiritualReflectionCard({
    required this.reflectionText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.accentEmerald.withValues(alpha: 0.45),
          width: 0.9.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.lamp_charge,
            color: colors.accentEmerald,
            size: 18.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التَّدَبُّرُ الإِيمَانِيُّ',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.accentEmerald,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  reflectionText,
                  style: GoogleFonts.cairo(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Action bar at the bottom containing Copy and Juz/Page label.
class _TafsirBottomBar extends StatelessWidget {
  final AyahEntity ayah;
  final VoidCallback onCopy;

  const _TafsirBottomBar({
    required this.ayah,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.borderHairline.withValues(alpha: 0.5), width: 0.8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onCopy,
            icon: Icon(
              Iconsax.copy,
              color: colors.accentEmerald,
              size: 16.r,
            ),
            label: Text(
              'نَسْخ',
              style: AppTextStyles.caption.copyWith(
                color: colors.accentEmerald,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          Text(
            'جُزْءُ ${ayah.juz} • ص ${ayah.page}',
            style: AppTextStyles.caption.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

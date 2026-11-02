import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/tafsir_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/tafsir/tafsir_content_cards.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/tafsir/tafsir_header_and_chips.dart';

/// Clean, minimalistic, scrollable Tafsir & Reflection Bottom Sheet:
/// - Constrained to a max height of ~75% of the screen height
/// - Pure Tafsir & Tadabbur reading experience
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

class _QuranTafsirReflectionSheetState
    extends State<QuranTafsirReflectionSheet> {
  int _selectedTafsirIndex = 0;

  TafsirEntity? get _currentTafsir {
    if (widget.ayah.tafsirs.isEmpty) return null;
    final clamped =
        _selectedTafsirIndex.clamp(0, widget.ayah.tafsirs.length - 1);
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
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
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
              const TafsirSheetDragHandle(),
              TafsirHeader(
                surah: widget.surah,
                ayah: widget.ayah,
                onClose: widget.onClose,
              ),
              if (widget.ayah.tafsirs.length > 1) ...[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  child: TafsirTypeChips(
                    tafsirs: widget.ayah.tafsirs,
                    selectedIndex: _selectedTafsirIndex,
                    onSelected: (idx) {
                      setState(() => _selectedTafsirIndex = idx);
                    },
                  ),
                ),
              ],
              Divider(
                color: colors.borderHairline.withValues(alpha: 0.6),
                height: 12.h,
                thickness: 0.8.r,
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TafsirBodyCard(
                        tafsirType: _currentTafsirType,
                        tafsirText: _currentTafsirText,
                      ),
                      if (widget.ayah.reflection != null &&
                          widget.ayah.reflection!.trim().isNotEmpty) ...[
                        AppSpacing.verticalSm,
                        SpiritualReflectionCard(
                          reflectionText: widget.ayah.reflection!.trim(),
                        ),
                      ],
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
              TafsirBottomBar(
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

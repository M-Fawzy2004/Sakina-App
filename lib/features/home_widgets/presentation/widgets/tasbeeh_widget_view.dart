import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/utils/arabic_numerals.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/widget_common.dart';

// ─── TASBEEH SMALL (2×2) ────────────────────────────────────────────────────

class TasbeehSmallWidgetView extends StatelessWidget {
  final WidgetTasbeehData data;

  const TasbeehSmallWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final current = ArabicNumerals.format(data.currentCount);
    final target = ArabicNumerals.format(data.targetCount);
    final progress = data.targetCount <= 0
        ? 0.0
        : (data.currentCount / data.targetCount).clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 170,
          height: 170,
          child: WidgetFrame(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const WidgetTitle(
                      icon: Icons.blur_circular_rounded,
                      text: 'التسبيح اليومي',
                      fontSize: 10,
                      iconSize: 12,
                    ),
                    if (data.shortTitle.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.shortTitle,
                          textAlign: TextAlign.end,
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
                  ],
                ),
                const SizedBox(height: 5),
                const OrnamentDivider(),
                Expanded(
                  child: AutoFitText(
                    text: data.phrase,
                    maxLines: 4,
                    style: GoogleFonts.amiri(
                      fontSize: 15,
                      color: AppColors.pureChalk,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
                // Progress bar (gold only)
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.champagneGold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 12,
                      color: AppColors.mutedSilver,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        'اضغط للعد',
                        style: GoogleFonts.almarai(
                          fontSize: 9,
                          color: AppColors.mutedSilver,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    WidgetPill(
                      text: '$current / $target',
                      fontSize: 10,
                      filled: true,
                    ),
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
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_hisn_muslim_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_portal_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_portals_header.dart';

/// "بَوَّابَاتُ السَّكِينَةِ" - 2x2 grid section of quick-access spiritual portals with Hisn al-Muslim flagship card.
class MaladhPortalsSection extends StatelessWidget {
  final VoidCallback? onDirectAccessTap;
  final VoidCallback? onMushafTap;
  final VoidCallback? onMaqraTap;
  final VoidCallback? onCardMakerTap;
  final VoidCallback? onAthkarTap;
  final VoidCallback? onHisnMuslimTap;

  const MaladhPortalsSection({
    super.key,
    this.onDirectAccessTap,
    this.onMushafTap,
    this.onMaqraTap,
    this.onCardMakerTap,
    this.onAthkarTap,
    this.onHisnMuslimTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Section Header: "بَوَّابَاتُ السَّكِينَةِ"
        MaladhPortalsHeader(
          onDirectAccessTap: onDirectAccessTap,
        ),

        AppSpacing.verticalXs,

        // 2. The 2x2 Portals Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // Row 1: Mushaf (Right) & Maqra (Left)
              Row(
                children: [
                  // Portal 1: مصحف الورق الحي (RTL Start)
                  Expanded(
                    child: MaladhPortalCard(
                      title: 'مُصْحَفُ الوَرَقِ الحَيِّ',
                      subtitle: 'خط المدينة المحسّن لمسياً',
                      badgeText: 'ص 531',
                      iconWidget: Icon(
                        FlutterIslamicIcons.solidQuran2,
                        color: colors.accentGold,
                        size: 20.r,
                      ),
                      onTap: onMushafTap,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Portal 2: مقرأة الشيوخ (RTL End)
                  Expanded(
                    child: MaladhPortalCard(
                      title: 'مَقْرَأَةُ الشُّيُوخِ',
                      subtitle: 'استماع نقي بدون إنترنت',
                      badgeText: 'محفوظ',
                      isEmerald: true,
                      iconWidget: Icon(
                        Iconsax.volume_high,
                        color: colors.accentEmerald,
                        size: 20.r,
                      ),
                      onTap: onMaqraTap,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // Row 2: Card Maker (Right) & Athkar / Tasbih (Left)
              Row(
                children: [
                  // Portal 3: صانع بطاقات الآيات (RTL Start)
                  Expanded(
                    child: MaladhPortalCard(
                      title: 'صَانِعُ بِطَاقَاتِ الآيَاتِ',
                      subtitle: 'تصميم بدقة 4K للمشاركة',
                      badgeText: 'مشاركة',
                      iconWidget: Icon(
                        Iconsax.brush_1,
                        color: colors.accentGold,
                        size: 20.r,
                      ),
                      onTap: onCardMakerTap,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Portal 4: الأذكار والمسابح (RTL End)
                  Expanded(
                    child: MaladhPortalCard(
                      title: 'الأَذْكَارُ وَالمَسَابِحُ',
                      subtitle: 'أوراد يومية وتسبيح تفاعلي',
                      badgeText: '8 أقسام',
                      isEmerald: true,
                      iconWidget: Icon(
                        Iconsax.finger_cricle,
                        color: colors.accentEmerald,
                        size: 20.r,
                      ),
                      onTap: onAthkarTap,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // Row 3: حصن المسلم - Hisn al-Muslim Flagship Card
              MaladhHisnMuslimCard(
                onTap: onHisnMuslimTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


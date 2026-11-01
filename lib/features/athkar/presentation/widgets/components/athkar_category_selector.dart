import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_category_chip.dart';

/// Horizontally scrollable category selector row.
class AthkarCategorySelector extends StatelessWidget {
  final List<AthkarCategoryEntity> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const AthkarCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat.name == selectedCategory;
          return AthkarCategoryChip(
            category: cat,
            isSelected: isSelected,
            onTap: () => onSelectCategory(cat.name),
          );
        },
      ),
    );
  }
}

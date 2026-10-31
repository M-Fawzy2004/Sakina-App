import 'package:equatable/equatable.dart';

/// Represents an authentic righteous deed that expiates sins ("الحسنات الماحية").
class GoodDeedEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String rewardDescription;
  final int completionCount;
  final bool isCompletedToday;
  final String iconKey;

  const GoodDeedEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.rewardDescription,
    required this.completionCount,
    required this.isCompletedToday,
    required this.iconKey,
  });

  GoodDeedEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? rewardDescription,
    int? completionCount,
    bool? isCompletedToday,
    String? iconKey,
  }) {
    return GoodDeedEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      completionCount: completionCount ?? this.completionCount,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      iconKey: iconKey ?? this.iconKey,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        rewardDescription,
        completionCount,
        isCompletedToday,
        iconKey,
      ];
}


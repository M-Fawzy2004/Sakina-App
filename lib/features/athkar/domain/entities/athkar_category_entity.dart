import 'package:equatable/equatable.dart';

/// Immutable domain entity representing an Athkar Category.
class AthkarCategoryEntity extends Equatable {
  final String name;
  final int count;
  final String description;
  final String iconKey;

  const AthkarCategoryEntity({
    required this.name,
    required this.count,
    required this.description,
    required this.iconKey,
  });

  @override
  List<Object?> get props => [
        name,
        count,
        description,
        iconKey,
      ];
}


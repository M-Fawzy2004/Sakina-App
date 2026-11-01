import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a single Thikr or Dua item.
class AthkarItemEntity extends Equatable {
  final String category;
  final int count;
  final String description;
  final String reference;
  final String content;

  const AthkarItemEntity({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.content,
  });

  @override
  List<Object?> get props => [
        category,
        count,
        description,
        reference,
        content,
      ];
}


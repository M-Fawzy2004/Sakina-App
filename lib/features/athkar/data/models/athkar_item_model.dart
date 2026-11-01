import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';

/// DTO model for Athkar items mapping directly from `assets/azkar/azkar.json`.
class AthkarItemModel extends AthkarItemEntity {
  const AthkarItemModel({
    required super.category,
    required super.count,
    required super.description,
    required super.reference,
    required super.content,
  });

  factory AthkarItemModel.fromJson(Map<String, dynamic> json) {
    final rawCount = json['count'];
    int parsedCount = 1;
    if (rawCount is int) {
      parsedCount = rawCount;
    } else if (rawCount is String) {
      parsedCount = int.tryParse(rawCount.trim()) ?? 1;
    }
    if (parsedCount <= 0) {
      parsedCount = 1;
    }

    return AthkarItemModel(
      category: json['category'] as String? ?? '',
      count: parsedCount,
      description: json['description'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      content: (json['content'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'count': count.toString(),
        'description': description,
        'reference': reference,
        'content': content,
      };

  AthkarItemEntity toEntity() => AthkarItemEntity(
        category: category,
        count: count,
        description: description,
        reference: reference,
        content: content,
      );
}


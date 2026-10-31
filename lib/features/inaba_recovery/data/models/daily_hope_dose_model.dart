import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';

class DailyHopeDoseModel extends DailyHopeDoseEntity {
  const DailyHopeDoseModel({
    required super.id,
    required super.quotation,
    required super.source,
    required super.explanation,
    required super.isSaved,
  });

  factory DailyHopeDoseModel.fromJson(Map<String, dynamic> json) {
    return DailyHopeDoseModel(
      id: json['id'] as String,
      quotation: json['quotation'] as String,
      source: json['source'] as String,
      explanation: json['explanation'] as String,
      isSaved: json['is_saved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quotation': quotation,
      'source': source,
      'explanation': explanation,
      'is_saved': isSaved,
    };
  }

  factory DailyHopeDoseModel.fromEntity(DailyHopeDoseEntity entity) {
    return DailyHopeDoseModel(
      id: entity.id,
      quotation: entity.quotation,
      source: entity.source,
      explanation: entity.explanation,
      isSaved: entity.isSaved,
    );
  }
}


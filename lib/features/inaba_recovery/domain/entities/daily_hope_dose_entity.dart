import 'package:equatable/equatable.dart';

/// Represents a daily dose of hope ("جرعة أمل يومية") containing prophetic hadiths or inspiring verses.
class DailyHopeDoseEntity extends Equatable {
  final String id;
  final String quotation;
  final String source;
  final String explanation;
  final bool isSaved;

  const DailyHopeDoseEntity({
    required this.id,
    required this.quotation,
    required this.source,
    required this.explanation,
    required this.isSaved,
  });

  DailyHopeDoseEntity copyWith({
    String? id,
    String? quotation,
    String? source,
    String? explanation,
    bool? isSaved,
  }) {
    return DailyHopeDoseEntity(
      id: id ?? this.id,
      quotation: quotation ?? this.quotation,
      source: source ?? this.source,
      explanation: explanation ?? this.explanation,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
        id,
        quotation,
        source,
        explanation,
        isSaved,
      ];
}


import 'package:equatable/equatable.dart';

/// Represents a practical step in the renewal of repentance checklist ("تجديد العهد والتوبة").
class RepentanceStepEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String evidence;
  final bool isCompleted;

  const RepentanceStepEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.evidence,
    required this.isCompleted,
  });

  RepentanceStepEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? evidence,
    bool? isCompleted,
  }) {
    return RepentanceStepEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      evidence: evidence ?? this.evidence,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        evidence,
        isCompleted,
      ];
}


import 'package:equatable/equatable.dart';

/// Represents a private reflection or repentance journal entry in "محراب البوح".
class SpiritualReflectionEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String moodTag;

  const SpiritualReflectionEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.moodTag,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        createdAt,
        moodTag,
      ];
}


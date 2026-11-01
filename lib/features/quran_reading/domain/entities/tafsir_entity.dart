import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a Tafsir (Exegesis) entry for a Quranic Ayah.
class TafsirEntity extends Equatable {
  /// The school or scholar of exegesis (e.g., 'التفسير المختصر', 'تفسير الجلالين', 'تفسير السعدي').
  final String type;

  /// The authentic exegesis body text.
  final String text;

  const TafsirEntity({
    required this.type,
    required this.text,
  });

  @override
  List<Object?> get props => [type, text];
}


import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';

class HadithModel extends HadithEntity {
  const HadithModel({
    required super.id,
    required super.idInBook,
    required super.chapterId,
    required super.bookId,
    required super.arabic,
    required super.englishNarrator,
    required super.englishText,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    final rawEnglish = json['english'];
    String narrator = '';
    String text = '';

    if (rawEnglish is Map<String, dynamic>) {
      narrator = (rawEnglish['narrator'] as String? ?? '').trim();
      text = (rawEnglish['text'] as String? ?? '').trim();
    } else if (rawEnglish is String) {
      text = rawEnglish.trim();
    }

    return HadithModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      idInBook: (json['idInBook'] as num?)?.toInt() ?? 0,
      chapterId: (json['chapterId'] as num?)?.toInt() ?? 0,
      bookId: (json['bookId'] as num?)?.toInt() ?? 0,
      arabic: (json['arabic'] as String? ?? '').trim(),
      englishNarrator: narrator,
      englishText: text,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idInBook': idInBook,
      'chapterId': chapterId,
      'bookId': bookId,
      'arabic': arabic,
      'english': {
        'narrator': englishNarrator,
        'text': englishText,
      },
    };
  }
}


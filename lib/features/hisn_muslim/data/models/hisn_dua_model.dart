import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';

class HisnDuaModel extends HisnDuaEntity {
  const HisnDuaModel({
    required super.id,
    required super.chapterId,
    required super.chapterTitle,
    required super.chapterTitleAr,
    required super.reference,
    required super.arabic,
    required super.english,
  });

  factory HisnDuaModel.fromJson(
    Map<String, dynamic> json, {
    required int id,
    required int chapterId,
    required String chapterTitleAr,
  }) {
    final rawReference = (json['reference'] as String? ?? '').trim();
    // Normalize unicode non-breaking spaces or artifacts
    final cleanedReference = rawReference
        .replaceAll(RegExp(r'[\u00A0\u200B\uFEFF]+'), ' ')
        .replaceAll('ReferenceA : A ', 'Reference: ')
        .replaceAll('ReferenceA : ', 'Reference: ')
        .replaceAll('Reference :', 'Reference: ')
        .trim();

    final rawArabic = (json['arabic'] as String? ?? '').trim();
    final rawEnglish = (json['english'] as String? ?? '').trim();
    final rawTitle = (json['title'] as String? ?? '').trim();

    return HisnDuaModel(
      id: id,
      chapterId: chapterId,
      chapterTitle: rawTitle,
      chapterTitleAr: chapterTitleAr,
      reference: cleanedReference,
      arabic: rawArabic,
      english: rawEnglish,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'title': chapterTitle,
      'titleAr': chapterTitleAr,
      'reference': reference,
      'arabic': arabic,
      'english': english,
    };
  }
}


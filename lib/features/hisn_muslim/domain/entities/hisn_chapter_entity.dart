import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';

class HisnChapterEntity extends Equatable {
  final int id;
  final String title;
  final String titleAr;
  final String category;
  final List<HisnDuaEntity> items;

  const HisnChapterEntity({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.category,
    required this.items,
  });

  int get itemCount => items.length;

  @override
  List<Object?> get props => [
        id,
        title,
        titleAr,
        category,
        items,
      ];
}


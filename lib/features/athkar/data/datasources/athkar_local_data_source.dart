import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sakina_app/features/athkar/data/models/athkar_item_model.dart';

/// Contract for local Athkar data source.
abstract interface class AthkarLocalDataSource {
  Future<Map<String, List<AthkarItemModel>>> loadAllAthkar();
  Future<List<AthkarItemModel>> getAthkarByCategory(String category);
}

/// Offline-first implementation loading structured Athkar from local assets.
class AthkarLocalDataSourceImpl implements AthkarLocalDataSource {
  static const String _kAzkarJsonPath = 'assets/azkar/azkar.json';
  Map<String, List<AthkarItemModel>>? _memoryCache;

  @override
  Future<Map<String, List<AthkarItemModel>>> loadAllAthkar() async {
    if (_memoryCache != null) {
      return _memoryCache!;
    }

    final jsonString = await rootBundle.loadString(_kAzkarJsonPath);
    final dynamic decoded = json.decode(jsonString);

    final Map<String, List<AthkarItemModel>> result = {};

    if (decoded is Map<String, dynamic>) {
      for (final entry in decoded.entries) {
        final categoryName = entry.key;
        final itemsRaw = entry.value;
        if (itemsRaw is List) {
          result[categoryName] = itemsRaw
              .whereType<Map<String, dynamic>>()
              .map((itemJson) => AthkarItemModel.fromJson(itemJson))
              .toList();
        }
      }
    }

    _memoryCache = result;
    return result;
  }

  @override
  Future<List<AthkarItemModel>> getAthkarByCategory(String category) async {
    final all = await loadAllAthkar();
    return all[category] ?? [];
  }
}


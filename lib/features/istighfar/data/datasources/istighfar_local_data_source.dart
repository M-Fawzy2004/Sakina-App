import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakina_app/features/istighfar/data/models/istighfar_item_model.dart';

abstract interface class IstighfarLocalDataSource {
  Future<List<IstighfarItemModel>> getIstighfarItems();
  Future<IstighfarItemModel> incrementCount(String itemId);
  Future<IstighfarItemModel> resetCurrentCycle(String itemId);
  Future<int> getTotalLifetimeCount();
  Future<IstighfarItemModel> setTargetCount(String itemId, int target);
  Future<String?> getSelectedItemId();
  Future<void> setSelectedItemId(String itemId);
}

class IstighfarLocalDataSourceImpl implements IstighfarLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _kPrefixLifetime = 'istighfar_lifetime_';
  static const String _kPrefixCurrent = 'istighfar_current_';
  static const String _kPrefixTarget = 'istighfar_target_';
  static const String _kPrefixLaps = 'istighfar_laps_';
  static const String _kSelectedId = 'istighfar_selected_id';

  const IstighfarLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<IstighfarItemModel>> getIstighfarItems() async {
    final list = <IstighfarItemModel>[];

    for (final base in IstighfarItemModel.defaultItems) {
      final lifetime = sharedPreferences.getInt('$_kPrefixLifetime${base.id}') ?? 0;
      final current = sharedPreferences.getInt('$_kPrefixCurrent${base.id}') ?? 0;
      final target = sharedPreferences.getInt('$_kPrefixTarget${base.id}') ?? base.targetCount;
      final laps = sharedPreferences.getInt('$_kPrefixLaps${base.id}') ?? 0;

      list.add(
        IstighfarItemModel(
          id: base.id,
          arabic: base.arabic,
          shortTitle: base.shortTitle,
          virtue: base.virtue,
          currentCycleCount: current,
          targetCount: target,
          lifetimeCount: lifetime,
          lapsCompleted: laps,
        ),
      );
    }

    return list;
  }

  @override
  Future<IstighfarItemModel> incrementCount(String itemId) async {
    final base = IstighfarItemModel.defaultItems.firstWhere(
      (item) => item.id == itemId,
      orElse: () => IstighfarItemModel.defaultItems.first,
    );

    final lifetimeKey = '$_kPrefixLifetime$itemId';
    final currentKey = '$_kPrefixCurrent$itemId';
    final targetKey = '$_kPrefixTarget$itemId';
    final lapsKey = '$_kPrefixLaps$itemId';

    final oldLifetime = sharedPreferences.getInt(lifetimeKey) ?? 0;
    final oldCurrent = sharedPreferences.getInt(currentKey) ?? 0;
    final target = sharedPreferences.getInt(targetKey) ?? base.targetCount;
    var laps = sharedPreferences.getInt(lapsKey) ?? 0;

    final newLifetime = oldLifetime + 1;
    var newCurrent = oldCurrent + 1;

    // When cycle hits target (e.g. 33 or 100), cycle resets and increments laps
    if (target > 0 && newCurrent >= target) {
      newCurrent = 0;
      laps += 1;
      await sharedPreferences.setInt(lapsKey, laps);
    }

    await sharedPreferences.setInt(lifetimeKey, newLifetime);
    await sharedPreferences.setInt(currentKey, newCurrent);

    return IstighfarItemModel(
      id: base.id,
      arabic: base.arabic,
      shortTitle: base.shortTitle,
      virtue: base.virtue,
      currentCycleCount: newCurrent,
      targetCount: target,
      lifetimeCount: newLifetime,
      lapsCompleted: laps,
    );
  }

  @override
  Future<IstighfarItemModel> resetCurrentCycle(String itemId) async {
    final base = IstighfarItemModel.defaultItems.firstWhere(
      (item) => item.id == itemId,
      orElse: () => IstighfarItemModel.defaultItems.first,
    );

    final currentKey = '$_kPrefixCurrent$itemId';
    final targetKey = '$_kPrefixTarget$itemId';
    final lifetimeKey = '$_kPrefixLifetime$itemId';
    final lapsKey = '$_kPrefixLaps$itemId';

    await sharedPreferences.setInt(currentKey, 0);
    final lifetime = sharedPreferences.getInt(lifetimeKey) ?? 0;
    final target = sharedPreferences.getInt(targetKey) ?? base.targetCount;
    final laps = sharedPreferences.getInt(lapsKey) ?? 0;

    return IstighfarItemModel(
      id: base.id,
      arabic: base.arabic,
      shortTitle: base.shortTitle,
      virtue: base.virtue,
      currentCycleCount: 0,
      targetCount: target,
      lifetimeCount: lifetime,
      lapsCompleted: laps,
    );
  }

  @override
  Future<int> getTotalLifetimeCount() async {
    int sum = 0;
    for (final base in IstighfarItemModel.defaultItems) {
      sum += sharedPreferences.getInt('$_kPrefixLifetime${base.id}') ?? 0;
    }
    return sum;
  }

  @override
  Future<IstighfarItemModel> setTargetCount(String itemId, int target) async {
    final base = IstighfarItemModel.defaultItems.firstWhere(
      (item) => item.id == itemId,
      orElse: () => IstighfarItemModel.defaultItems.first,
    );

    final targetKey = '$_kPrefixTarget$itemId';
    final lifetimeKey = '$_kPrefixLifetime$itemId';
    final currentKey = '$_kPrefixCurrent$itemId';
    final lapsKey = '$_kPrefixLaps$itemId';

    await sharedPreferences.setInt(targetKey, target);
    final lifetime = sharedPreferences.getInt(lifetimeKey) ?? 0;
    final current = sharedPreferences.getInt(currentKey) ?? 0;
    final laps = sharedPreferences.getInt(lapsKey) ?? 0;

    return IstighfarItemModel(
      id: base.id,
      arabic: base.arabic,
      shortTitle: base.shortTitle,
      virtue: base.virtue,
      currentCycleCount: current,
      targetCount: target,
      lifetimeCount: lifetime,
      lapsCompleted: laps,
    );
  }

  @override
  Future<String?> getSelectedItemId() async {
    return sharedPreferences.getString(_kSelectedId);
  }

  @override
  Future<void> setSelectedItemId(String itemId) async {
    await sharedPreferences.setString(_kSelectedId, itemId);
  }
}


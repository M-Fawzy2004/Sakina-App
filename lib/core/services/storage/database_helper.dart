import 'package:path/path.dart' as p;
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

abstract interface class DatabaseHelper {
  Future<Database> get database;
  Future<void> close();
}

class DatabaseHelperImpl implements DatabaseHelper {
  static Database? _dbInstance;

  @override
  Future<Database> get database async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initDatabase();
    return _dbInstance!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, AppConstants.databaseName);

      return await openDatabase(
        path,
        version: AppConstants.databaseVersion,
        onCreate: (db, version) async {
          await _createTables(db);
        },
      );
    } catch (e) {
      throw const DatabaseException(message: 'تعذر تهيئة قاعدة البيانات المحلية');
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS surahs (
        id INTEGER PRIMARY KEY,
        number INTEGER NOT NULL,
        name_arabic TEXT NOT NULL,
        name_english TEXT NOT NULL,
        revelation_type TEXT NOT NULL,
        verses_count INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ayahs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        text_uthmani TEXT NOT NULL,
        text_simple TEXT NOT NULL,
        page_number INTEGER NOT NULL,
        juz_number INTEGER NOT NULL,
        hizb_number INTEGER NOT NULL,
        sajdah INTEGER DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        page_number INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        note TEXT
      );
    ''');

    // Composite indexes for 0ms deterministic querying
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_ayahs_surah_ayah ON ayahs(surah_number, ayah_number);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_ayahs_page ON ayahs(page_number);',
    );
  }

  @override
  Future<void> close() async {
    if (_dbInstance != null) {
      await _dbInstance!.close();
      _dbInstance = null;
    }
  }
}

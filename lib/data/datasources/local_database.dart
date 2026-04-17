import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('xnotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      const idType = 'TEXT PRIMARY KEY';
      const textType = 'TEXT NOT NULL';
      const integerType = 'INTEGER NOT NULL';

      await db.execute('''
CREATE TABLE IF NOT EXISTS agendas (
  id $idType,
  title $textType,
  description $textType,
  date_time $textType,
  is_completed $integerType,
  reminder_id $integerType
  )
''');
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE notes (
  id $idType,
  title $textType,
  text_content $textType,
  media_path $textNullableType,
  media_type $textType,
  created_at $textType
  )
''');

    await db.execute('''
CREATE TABLE agendas (
  id $idType,
  title $textType,
  description $textType,
  date_time $textType,
  is_completed $integerType,
  reminder_id $integerType
  )
''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

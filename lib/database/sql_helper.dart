import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_meucao/model/dog_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('dogs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        photoPath TEXT NOT NULL
      )
    ''');
  }

  Future<int> createDog(DogModel dog) async {
    final db = await instance.database;
    return await db.insert('dogs', dog.toMap());
  }

  Future<DogModel?> getDog(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'dogs',
      columns: ['id', 'name', 'age', 'photoPath'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DogModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<DogModel>> getAllDogs() async {
    final db = await instance.database;
    final result = await db.query('dogs');
    return result.map((json) => DogModel.fromMap(json)).toList();
  }

  Future<int> updateDog(DogModel dog) async {
    final db = await instance.database;
    return db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  Future<int> deleteDog(int id) async {
    final db = await instance.database;
    return db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

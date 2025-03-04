import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_sqlite/models/dog.dart';

class DogsDatabase {
  static final DogsDatabase instance = DogsDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    var path = await getDatabasesPath();
    var fullPath = join(path, "dogs.db");

    _database = await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE dogs 
            (
            _id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT NOT NULL, 
            age INTEGER NOT NULL
            )
        ''');
      },
    );

    return _database!;
  }

  Future<void> createDog(Dog dog) async {
    Database db = await instance.database;

    await db.insert("dogs", dog.toJson());
  }

  Future<void> updateDog(Dog dog) async {
    Database db = await instance.database;

    await db.update(
      "dogs",
      dog.toJson(),
      where: "_id = ?",
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    Database db = await instance.database;

    await db.delete("dogs", where: "_id = ?", whereArgs: [id]);
  }

  Future<List<Dog>> getAllDogs() async {
    Database db = await instance.database;

    List<Map<String, Object?>> result = await db.query("dogs");

    return result.map((json) => Dog.fromJson(json)).toList();
  }

  Future<void> closeDatabase() async {
    Database db = await instance.database;
    db.close();
  }

  DogsDatabase._init();
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT NOT NULL, 
            age INTEGER NOT NULL
            )
        ''');
      },
    );

    return _database!;
  }

  Future<void> closeDatabase() async {
    Database db = await instance.database;
    db.close();
  }

  DogsDatabase._init();
}

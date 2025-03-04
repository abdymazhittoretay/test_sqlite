import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_sqlite/pages/home_page.dart';
import 'package:test_sqlite/pages/page_to_test.dart';
import 'database/databases.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), "students.db"),
    version: 1,
    onCreate: (db, version) {
      return db.execute('''
      CREATE TABLE students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      age INTEGER )''');
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: PageToTest());
  }
}

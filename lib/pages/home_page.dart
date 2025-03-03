import 'package:flutter/material.dart';
import 'package:test_sqlite/databases.dart';
import 'package:test_sqlite/models/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> insertStudent(Student student) async {
    final db = await database;

    await db.insert("students", student.toJson());
  }

  Future<List<Student>> getStudents() async {
    final db = await database;

    final List<Map<String, Object?>> studentMaps = await db.query('students');

    return [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in studentMaps)
        Student(id: id, name: name, age: age),
    ];
  }

  Future<void> updateStudent(Student student) async {
    final db = await database;

    await db.update(
      "students",
      student.toJson(),
      where: "id = ?",
      whereArgs: [student.id],
    );
  }

  Future<void> deleteStudent(int id) async {
    final db = await database;

    await db.delete("students", where: "id = ?", whereArgs: [id]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white);
  }
}

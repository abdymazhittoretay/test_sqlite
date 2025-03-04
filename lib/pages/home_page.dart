import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_sqlite/database/databases.dart';
import 'package:test_sqlite/models/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> insertStudent(Student student) async {
    final db = await database;

    await db.insert(
      "students",
      student.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Text("SQLite"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Student>>(
        future: getStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<Student> students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${students[index].id} ${students[index].name} ${students[index].age}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          _controller.text = students[index].name;
                          openDialog(id: students[index].id);
                          setState(() {});
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await deleteStudent(students[index].id);
                          setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("There are no data."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void openDialog({int? id}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add/Update your data:"),
          content: TextField(controller: _controller),
          actions: [
            TextButton(
              onPressed: () {
                _controller.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty && id == null) {
                  await insertStudent(
                    Student(id: 0, name: _controller.text, age: 24),
                  );
                } else if (_controller.text.isNotEmpty && id != null) {
                  await updateStudent(
                    Student(id: 0, name: _controller.text, age: 15),
                  );
                }
                _controller.clear();
                setState(() {});
                Navigator.pop(context);
              },
              child: Text("Add/Update"),
            ),
          ],
        );
      },
    );
  }
}

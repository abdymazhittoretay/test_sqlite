import 'package:flutter/material.dart';
import 'package:test_sqlite/database/dogs_database.dart';
import 'package:test_sqlite/models/dog.dart';

class PageToTest extends StatefulWidget {
  const PageToTest({super.key});

  @override
  State<PageToTest> createState() => _PageToTestState();
}

class _PageToTestState extends State<PageToTest> {
  List<Dog>? _dogs;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final dogs = await DogsDatabase.instance.getAllDogs();
    setState(() {
      _dogs = dogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _dogs != null && _dogs!.isNotEmpty
              ? ListView.builder(
                itemCount: _dogs!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${_dogs![index].id} ${_dogs![index].name} ${_dogs![index].age}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            _controller.text = _dogs![index].name;
                            openDialog(id: _dogs![index].id);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            await DogsDatabase.instance.deleteDog(
                              _dogs![index].id!,
                            );
                            _getData();
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              )
              : Center(child: Text("No data!")),
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
                if (id == null) {
                  await DogsDatabase.instance.createDog(
                    Dog(name: _controller.text, age: 15),
                  );
                } else {
                  await DogsDatabase.instance.updateDog(
                    Dog(id: id, name: _controller.text, age: 24),
                  );
                }
                _getData();
                _controller.clear();
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

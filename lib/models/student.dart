class Student {
  final int id;
  final String name;
  final int age;

  Student({required this.id, required this.name, required this.age});

  Map<String, Object?> toJson() {
    return {"id": id, "name": name, "age": age};
  }

  @override
  String toString() {
    return "Student(id: $id, name $name, age: $age)";
  }
}

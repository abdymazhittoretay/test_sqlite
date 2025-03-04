class Dog {
  final int? id;
  final String name;
  final int age;

  Dog({this.id, required this.name, required this.age});

  Dog copy({int? id, String? name, int? age}) =>
      Dog(id: id ?? this.id, name: name ?? this.name, age: age ?? this.age);

  static Dog fromJson(Map<String, Object?> json) => Dog(
    id: json["_id"] as int?,
    name: json["name"] as String,
    age: json["age"] as int,
  );

  Map<String, Object?> toJson() => {"_id": id, "name": name, "age": age};
}

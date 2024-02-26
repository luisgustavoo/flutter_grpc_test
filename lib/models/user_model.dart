import 'dart:convert';

class UserModel {
  UserModel({required this.id, required this.name, required this.age});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  final int id;
  final String name;
  final int age;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
    };
  }

  String toJson() => json.encode(toMap());
}

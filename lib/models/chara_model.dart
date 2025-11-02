// Nama file: chara_model.dart
// Nama class: Character

class Character {
  final int id;
  final String name;
  final List<String>? alias;
  final List<String>? species; // <-- Ini yang kita perbaiki tadi
  final String? gender;
  final int? age;
  final String? height;
  final String? status;
  final String? occupation;
  final List<dynamic>? groups; 
  final String? pictureUrl;

  Character({
    required this.id,
    required this.name,
    this.alias,
    this.species, 
    this.gender,
    this.age,
    this.height,
    this.status,
    this.occupation,
    this.groups,
    this.pictureUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    int? parseAge(dynamic age) {
      if (age == null) return null;
      if (age is int) return age;
      if (age is String) {
        return int.tryParse(age);
      }
      return null;
    }
    return Character(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      alias: json['alias'] != null ? List<String>.from(json['alias']) : null,
      species: json['species'] != null ? List<String>.from(json['species']) : null,
      gender: json['gender'],
      age: parseAge(json['age']),
      height: json['height'],
      status: json['status'],
      occupation: json['occupation'],
      groups: json['groups'], 
      pictureUrl: json['img'],
    );
  }
}
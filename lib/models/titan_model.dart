// Nama file: titan_model.dart
// Nama class: Titan

class Titan {
  final int id;
  final String name;
  final String? description;
  final String? height;
  final String? pictureUrl;

  Titan({
    required this.id,
    required this.name,
    this.description,
    this.height,
    this.pictureUrl,
  });

  factory Titan.fromJson(Map<String, dynamic> json) {
    return Titan(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      height: json['height'],
      pictureUrl: json['picture_url'],
    );
  }
}
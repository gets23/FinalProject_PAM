// Nama file: org_model.dart
// Nama class: Organization

class Organization {
  final int id;
  final String name;
  final String? description;
  final String? pictureUrl;

  Organization({
    required this.id,
    required this.name,
    this.description,
    this.pictureUrl,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      pictureUrl: json['picture_url'],
    );
  }
}
// Nama file: loc_model.dart
// Nama class: Location

class Location {
  final int id;
  final String name;
  final String? territory;
  final String? region;

  Location({
    required this.id,
    required this.name,
    this.territory,
    this.region,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      territory: json['territory'],
      region: json['region'],
    );
  }
}
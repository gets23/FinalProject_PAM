// lib/models/favorite_titan_model.dart

class FavoriteTitanModel {
  final int? id;
  final int userId;
  final int titanId;
  final String titanName;
  final String? titanImage;
  final String addedAt;

  FavoriteTitanModel({
    this.id,
    required this.userId,
    required this.titanId,
    required this.titanName,
    this.titanImage,
    required this.addedAt,
  });

  // Untuk KIRIM ke DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'titan_id': titanId,
      'titan_name': titanName,
      'titan_image': titanImage,
      'added_at': addedAt,
    };
  }

  // Untuk BACA dari DB
  factory FavoriteTitanModel.fromMap(Map<String, dynamic> map) {
    return FavoriteTitanModel(
      id: map['id'],
      userId: map['user_id'],
      titanId: map['titan_id'],
      titanName: map['titan_name'],
      titanImage: map['titan_image'],
      addedAt: map['added_at'] ?? '',
    );
  }
}
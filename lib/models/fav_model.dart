// lib/models/favorite_model.dart

class FavoriteModel {
  final int? id;
  final int userId;
  final int characterId;
  final String characterName;
  final String? characterImage;
  final String addedAt;

  FavoriteModel({
    this.id,
    required this.userId,
    required this.characterId,
    required this.characterName,
    this.characterImage,
    required this.addedAt,
  });

  // Untuk KIRIM ke DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'character_id': characterId,
      'character_name': characterName,
      'character_image': characterImage,
      'added_at': addedAt,
    };
  }

  // Untuk BACA dari DB
  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      userId: map['user_id'],
      characterId: map['character_id'],
      characterName: map['character_name'],
      characterImage: map['character_image'],
      addedAt: map['added_at'],
    );
  }
}
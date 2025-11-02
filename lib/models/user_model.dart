// lib/models/user_model.dart

class User {
  final int? id;
  final String username;
  final String email;
  final String password; // Encrypted
  final String? fullName;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    this.profileImage,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert User object to Map (untuk insert ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Convert Map to User object (dari database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      fullName: map['full_name'] as String?,
      profileImage: map['profile_image'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at'] as String) 
          : null,
    );
  }

  // CopyWith method (untuk update data)
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? fullName,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email)';
  }
}

// Session Model
class Session {
  final int? id;
  final int userId;
  final String token;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isActive;

  Session({
    this.id,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'token': token,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      token: map['token'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      expiresAt: DateTime.parse(map['expires_at'] as String),
      isActive: (map['is_active'] as int) == 1,
    );
  }

  // Check if session is still valid
  bool get isValid {
    return isActive && DateTime.now().isBefore(expiresAt);
  }

  @override
  String toString() {
    return 'Session(id: $id, userId: $userId, isValid: $isValid)';
  }
}

// Favorite Character Model
class FavoriteCharacter {
  final int? id;
  final int userId;
  final int characterId;
  final String characterName;
  final String? characterImage;
  final DateTime addedAt;

  FavoriteCharacter({
    this.id,
    required this.userId,
    required this.characterId,
    required this.characterName,
    this.characterImage,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'character_id': characterId,
      'character_name': characterName,
      'character_image': characterImage,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory FavoriteCharacter.fromMap(Map<String, dynamic> map) {
    return FavoriteCharacter(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      characterId: map['character_id'] as int,
      characterName: map['character_name'] as String,
      characterImage: map['character_image'] as String?,
      addedAt: DateTime.parse(map['added_at'] as String),
    );
  }
}

// Watched Episode Model
class WatchedEpisode {
  final int? id;
  final int userId;
  final int episodeId;
  final String episodeName;
  final DateTime watchedAt;

  WatchedEpisode({
    this.id,
    required this.userId,
    required this.episodeId,
    required this.episodeName,
    required this.watchedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'episode_id': episodeId,
      'episode_name': episodeName,
      'watched_at': watchedAt.toIso8601String(),
    };
  }

  factory WatchedEpisode.fromMap(Map<String, dynamic> map) {
    return WatchedEpisode(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      episodeId: map['episode_id'] as int,
      episodeName: map['episode_name'] as String,
      watchedAt: DateTime.parse(map['watched_at'] as String),
    );
  }
}
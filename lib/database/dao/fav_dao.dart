// lib/database/dao/favorite_dao.dart
import 'package:sqflite/sqflite.dart';
import '/database/db_helper.dart';
import '/models/user_model.dart';

class FavoriteDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ============= CREATE =============
  
  // Add character to favorites
  Future<int> addFavorite(FavoriteCharacter favorite) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ============= READ =============
  
  // Get all favorites for a user
  Future<List<FavoriteCharacter>> getUserFavorites(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'added_at DESC',
    );

    return List.generate(maps.length, (i) => FavoriteCharacter.fromMap(maps[i]));
  }

  // Check if character is favorited
  Future<bool> isFavorite(int userId, int characterId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'user_id = ? AND character_id = ?',
      whereArgs: [userId, characterId],
    );

    return maps.isNotEmpty;
  }

  // Get favorite by character ID
  Future<FavoriteCharacter?> getFavoriteByCharacterId(int userId, int characterId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'user_id = ? AND character_id = ?',
      whereArgs: [userId, characterId],
    );

    if (maps.isEmpty) return null;
    return FavoriteCharacter.fromMap(maps.first);
  }

  // Get favorites count for user
  Future<int> getFavoritesCount(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM favorites WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ============= DELETE =============
  
  // Remove from favorites
  Future<int> removeFavorite(int userId, int characterId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'favorites',
      where: 'user_id = ? AND character_id = ?',
      whereArgs: [userId, characterId],
    );
  }

  // Remove all favorites for a user
  Future<int> removeAllUserFavorites(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ============= UTILITY =============
  
  // Toggle favorite (add if not exists, remove if exists)
  Future<bool> toggleFavorite(FavoriteCharacter favorite) async {
    final isFav = await isFavorite(favorite.userId, favorite.characterId);
    
    if (isFav) {
      await removeFavorite(favorite.userId, favorite.characterId);
      return false; // Removed
    } else {
      await addFavorite(favorite);
      return true; // Added
    }
  }
}

// ============= WATCHED EPISODES DAO =============

class WatchedEpisodeDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ============= CREATE =============
  
  // Mark episode as watched
  Future<int> markAsWatched(WatchedEpisode watched) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'watched_episodes',
      watched.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ============= READ =============
  
  // Get all watched episodes for user
  Future<List<WatchedEpisode>> getUserWatchedEpisodes(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watched_episodes',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'watched_at DESC',
    );

    return List.generate(maps.length, (i) => WatchedEpisode.fromMap(maps[i]));
  }

  // Check if episode is watched
  Future<bool> isWatched(int userId, int episodeId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watched_episodes',
      where: 'user_id = ? AND episode_id = ?',
      whereArgs: [userId, episodeId],
    );

    return maps.isNotEmpty;
  }

  // Get watched episodes count
  Future<int> getWatchedCount(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM watched_episodes WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ============= DELETE =============
  
  // Unmark episode as watched
  Future<int> unmarkAsWatched(int userId, int episodeId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'watched_episodes',
      where: 'user_id = ? AND episode_id = ?',
      whereArgs: [userId, episodeId],
    );
  }

  // Remove all watched episodes for user
  Future<int> removeAllWatchedEpisodes(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'watched_episodes',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ============= UTILITY =============
  
  // Toggle watched status
  Future<bool> toggleWatched(WatchedEpisode watched) async {
    final isWatchedStatus = await isWatched(watched.userId, watched.episodeId);
    
    if (isWatchedStatus) {
      await unmarkAsWatched(watched.userId, watched.episodeId);
      return false; // Unmarked
    } else {
      await markAsWatched(watched);
      return true; // Marked
    }
  }
}
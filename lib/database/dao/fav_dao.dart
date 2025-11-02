// lib/database/dao/favorite_dao.dart
import 'package:sqflite/sqflite.dart';
import '../db_helper.dart';
import '/models/fav_model.dart';
// import '/models/chara_model.dart'; // Kita butuh ini

class FavoriteDao {
  final dbHelper = DatabaseHelper.instance;

  /// 1. Menambahkan karakter ke favorit
  Future<void> addFavorite(FavoriteModel favorite) async {
    try {
      final db = await dbHelper.database;
      await db.insert(
        'favorites',
        favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Jika sdh ada, timpa saja
      );
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  /// 2. Menghapus karakter dari favorit
  Future<void> removeFavorite(int userId, int characterId) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'favorites',
        where: 'user_id = ? AND character_id = ?',
        whereArgs: [userId, characterId],
      );
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  /// 3. Cek apakah sebuah karakter sudah difavoritkan
  Future<bool> isFavorite(int userId, int characterId) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'user_id = ? AND character_id = ?',
        whereArgs: [userId, characterId],
        limit: 1,
      );
      return maps.isNotEmpty; // Jika list tidak kosong, berarti sudah favorit
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  /// 4. Ambil semua karakter favorit (untuk halaman "Favorit Saya")
  Future<List<FavoriteModel>> getAllFavorites(int userId) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'added_at DESC',
      );
      
      // Ubah List<Map> jadi List<FavoriteModel>
      return List.generate(maps.length, (i) {
        return FavoriteModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error getting all favorites: $e');
      return [];
    }
  }

  /// 5. Cek semua ID favorit (helper cepat untuk UI)
  Future<Set<int>> getAllFavoriteIds(int userId) async {
    try {
      final db = await dbHelper.database;
      // Kita hanya ambil kolom 'character_id'
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        columns: ['character_id'],
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      
      // Ubah List<Map> jadi Set<int> (Set lebih cepat untuk lookup)
      return maps.map((map) => map['character_id'] as int).toSet();
    } catch (e) {
      print('Error getting favorite IDs: $e');
      return {};
    }
  }
}
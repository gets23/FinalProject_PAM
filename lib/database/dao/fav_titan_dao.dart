// lib/database/dao/favorite_titan_dao.dart
import 'package:sqflite/sqflite.dart';
import '../db_helper.dart';
import '/models/fav_titan_model.dart'; // <-- Ganti model

class FavoriteTitanDao {
  final dbHelper = DatabaseHelper.instance;

  /// 1. Menambahkan titan ke favorit
  Future<void> addFavorite(FavoriteTitanModel favorite) async { // <-- Ganti model
    try {
      final db = await dbHelper.database;
      await db.insert(
        'favorite_titans', // <-- Ganti nama tabel
        favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error adding favorite titan: $e');
    }
  }

  /// 2. Menghapus titan dari favorit
  Future<void> removeFavorite(int userId, int titanId) async { // <-- Ganti param
    try {
      final db = await dbHelper.database;
      await db.delete(
        'favorite_titans', // <-- Ganti nama tabel
        where: 'user_id = ? AND titan_id = ?', // <-- Ganti param
        whereArgs: [userId, titanId],
      );
    } catch (e) {
      print('Error removing favorite titan: $e');
    }
  }

  /// 3. Cek apakah sebuah titan sudah difavoritkan
  Future<bool> isFavorite(int userId, int titanId) async { // <-- Ganti param
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorite_titans', // <-- Ganti nama tabel
        where: 'user_id = ? AND titan_id = ?', // <-- Ganti param
        whereArgs: [userId, titanId],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking favorite titan: $e');
      return false;
    }
  }

  /// 4. Ambil semua titan favorit
  Future<List<FavoriteTitanModel>> getAllFavorites(int userId) async { // <-- Ganti model
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorite_titans', // <-- Ganti nama tabel
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'added_at DESC',
      );
      
      return List.generate(maps.length, (i) {
        return FavoriteTitanModel.fromMap(maps[i]); // <-- Ganti model
      });
    } catch (e) {
      print('Error getting all favorite titans: $e');
      return [];
    }
  }

  /// 5. Cek semua ID favorit (helper cepat untuk UI)
  Future<Set<int>> getAllFavoriteIds(int userId) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorite_titans', // <-- Ganti nama tabel
        columns: ['titan_id'], // <-- Ganti kolom
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      return maps.map((map) => map['titan_id'] as int).toSet(); // <-- Ganti kolom
    } catch (e) {
      print('Error getting favorite titan IDs: $e');
      return {};
    }
  }
}
// lib/database/dao/user_dao.dart
import 'package:sqflite/sqflite.dart';
import '/database/db_helper.dart';
import '/models/user_model.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ============= CREATE =============
  
  // Insert user baru
  Future<int> insertUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // ============= READ =============
  
  // Get user by ID
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Get user by username
  Future<User?> getUserByUsername(String username) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  // Get all users (untuk debugging)
  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // ============= UPDATE =============
  
  // Update user
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Update profile image
  Future<int> updateProfileImage(int userId, String? imagePath) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      {
        'profile_image': imagePath,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Update password
  Future<int> updatePassword(int userId, String newPassword) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      {
        'password': newPassword,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ============= DELETE =============
  
  // Delete user
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============= VALIDATION =============
  
  // Validate login (cek email & password)
  Future<User?> validateLogin(String email, String encryptedPassword) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, encryptedPassword],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
}
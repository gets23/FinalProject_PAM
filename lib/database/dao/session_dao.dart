// lib/database/dao/session_dao.dart
import 'package:sqflite/sqflite.dart';
import '/database/db_helper.dart';
import '/models/user_model.dart';

class SessionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ============= CREATE =============
  
  // Create new session
  Future<int> createSession(Session session) async {
    final db = await _dbHelper.database;
    
    // Deactivate semua session lama user ini
    await deactivateUserSessions(session.userId);
    
    // Insert session baru
    return await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ============= READ =============
  
  // Get session by token
  Future<Session?> getSessionByToken(String token) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'token = ?',
      whereArgs: [token],
    );

    if (maps.isEmpty) return null;
    return Session.fromMap(maps.first);
  }

  // Get active session by user ID
  Future<Session?> getActiveSessionByUserId(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    
    final session = Session.fromMap(maps.first);
    
    // Check if expired
    if (!session.isValid) {
      await deactivateSession(session.id!);
      return null;
    }
    
    return session;
  }

  // Check if session is valid
  Future<bool> isSessionValid(String token) async {
    final session = await getSessionByToken(token);
    if (session == null) return false;
    
    if (!session.isValid) {
      await deactivateSession(session.id!);
      return false;
    }
    
    return true;
  }

  // Get all sessions for user (untuk debugging)
  Future<List<Session>> getUserSessions(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  // ============= UPDATE =============
  
  // Deactivate session
  Future<int> deactivateSession(int sessionId) async {
    final db = await _dbHelper.database;
    return await db.update(
      'sessions',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  // Deactivate session by token
  Future<int> deactivateSessionByToken(String token) async {
    final db = await _dbHelper.database;
    return await db.update(
      'sessions',
      {'is_active': 0},
      where: 'token = ?',
      whereArgs: [token],
    );
  }

  // Deactivate all sessions for a user
  Future<int> deactivateUserSessions(int userId) async {
    final db = await _dbHelper.database;
    return await db.update(
      'sessions',
      {'is_active': 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ============= DELETE =============
  
  // Delete session
  Future<int> deleteSession(int sessionId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  // Delete all expired sessions (cleanup)
  Future<int> deleteExpiredSessions() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    return await db.delete(
      'sessions',
      where: 'expires_at < ?',
      whereArgs: [now],
    );
  }

  // Delete all sessions for a user
  Future<int> deleteUserSessions(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
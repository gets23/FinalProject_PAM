// lib/database/dao/feedback_dao.dart
import 'package:sqflite/sqflite.dart';
import '../db_helper.dart';
import '/models/feedback_model.dart';

class FeedbackDao {
  final dbHelper = DatabaseHelper.instance;

  /// Insert feedback baru ke database
  Future<int> insertFeedback(FeedbackModel feedback) async {
    try {
      final db = await dbHelper.database;
      final id = await db.insert(
        'feedback',
        feedback.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print('Error inserting feedback: $e');
      return -1;
    }
  }

  /// Mengambil semua feedback dari user tertentu
  Future<List<FeedbackModel>> getAllFeedback(int userId) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'feedback',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC', // Tampilkan yg terbaru di atas
      );

      // Ubah List<Map> menjadi List<FeedbackModel>
      return List.generate(maps.length, (i) {
        return FeedbackModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error getting feedback: $e');
      return []; // Kembalikan list kosong jika error
    }
  }
}
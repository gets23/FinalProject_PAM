// lib/pages/profile/view_feedback_page.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/services/auth.dart';
import '/database/dao/feedback_dao.dart';
import '/models/feedback_model.dart';
import 'package:intl/intl.dart'; 
import '/database/db_helper.dart';

class ViewFeedbackPage extends StatefulWidget {
  const ViewFeedbackPage({Key? key}) : super(key: key);

  @override
  _ViewFeedbackPageState createState() => _ViewFeedbackPageState();
}

class _ViewFeedbackPageState extends State<ViewFeedbackPage> {
  final AuthService _authService = AuthService();
  final FeedbackDao _feedbackDao = FeedbackDao();
  late Future<List<FeedbackModel>> _feedbackFuture;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  void _loadFeedback() {
    final userId = _authService.currentUser?.id;
    if (userId != null) {
      setState(() {
        _feedbackFuture = _feedbackDao.getAllFeedback(userId);
      });
    } else {
      setState(() {
        _feedbackFuture = Future.value([]);
      });
    }
  }

  Future<void> _clearAllFeedback() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return; // Pastikan user ada

    // 1. Tampilkan dialog konfirmasi dulu
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        title: Text('Hapus Riwayat?', style: AppTheme.headingSmall),
        content: Text(
          'Anda yakin ingin menghapus semua riwayat feedback Anda? Tindakan ini tidak bisa dibatalkan.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            child: Text('Batal', style: AppTheme.bodyMedium),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor, // Warna merah
              foregroundColor: Colors.white,
            ),
            child: Text('Hapus'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    // 2. Jika user menekan "Hapus"
    if (confirm == true) {
      try {
        final db = await DatabaseHelper.instance.database;
        // Hapus semua data dari tabel 'feedback' yg user_id-nya cocok
        await db.delete(
          'feedback',
          where: 'user_id = ?',
          whereArgs: [userId],
        );
        // Muat ulang halaman (list akan jadi kosong)
        _loadFeedback(); 
      } catch (e) {
        print('Gagal hapus feedback: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Feedback'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined), // Icon tong sampah
            tooltip: 'Hapus Semua Riwayat',
            onPressed: _clearAllFeedback, // Panggil fungsi hapus
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: FutureBuilder<List<FeedbackModel>>(
        future: _feedbackFuture,
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // 2. Error (Sudah di-handle oleh DAO)
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: AppTheme.bodyMedium,
              ),
            );
          }

          // 3. Data Kosong
          final feedbackList = snapshot.data;
          if (feedbackList == null || feedbackList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 60, color: AppTheme.textColor),
                  const SizedBox(height: 16),
                  Text('Belum ada riwayat feedback.', style: AppTheme.bodyMedium),
                ],
              ),
            );
          }

          // 4. Sukses: Tampilkan List
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              final feedback = feedbackList[index];
              return _buildFeedbackCard(feedback);
            },
          );
        },
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackModel feedback) {
    // Format tanggal
    final DateTime date = DateTime.parse(feedback.createdAt);
    final String formattedDate = DateFormat('d MMM yyyy, HH:mm').format(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppTheme.secondaryColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Rating dan Tanggal)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⭐ ${feedback.rating}/5',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: AppTheme.caption.copyWith(color: AppTheme.textColor),
                ),
              ],
            ),
            const Divider(height: 24),

            // Kesan
            Text('Kesan:', style: AppTheme.bodySmall.copyWith(color: AppTheme.textColor)),
            const SizedBox(height: 4),
            Text(feedback.kesan, style: AppTheme.bodyMedium),
            
            const SizedBox(height: 12),

            // Saran
            Text('Saran:', style: AppTheme.bodySmall.copyWith(color: AppTheme.textColor)),
            const SizedBox(height: 4),
            Text(feedback.saran, style: AppTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
// lib/pages/profile/feedback_page.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/services/auth.dart';
import '/database/dao/feedback_dao.dart';
import '/models/feedback_model.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _kesanController = TextEditingController();
  final _saranController = TextEditingController();

  final FeedbackDao _feedbackDao = FeedbackDao();

  int _rating = 5;
  bool _isLoading = false;

  @override
  void dispose() {
    _kesanController.dispose();
    _saranController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return; // 1. Validasi form

    setState(() => _isLoading = true);

    try {
      // 2. Ambil semua data dari form & user
      final userId = _authService.currentUser?.id;

      // Cek jika user tidak ditemukan
      if (userId == null) {
        _showSnackBar('User tidak ditemukan, silakan login ulang.', isError: true);
        setState(() => _isLoading = false);
        return;
      }

      final kesan = _kesanController.text;
      final saran = _saranController.text;
      final rating = _rating;
      final createdAt = DateTime.now().toIso8601String(); // Waktu saat ini

      // 3. Bungkus data ke dalam Model
      final feedbackData = FeedbackModel(
        userId: userId,
        rating: rating,
        kesan: kesan,
        saran: saran,
        createdAt: createdAt,
      );

      // 4. Panggil fungsi insertFeedback dari DAO
      final newId = await _feedbackDao.insertFeedback(feedbackData);

      if (newId == -1) {
        throw Exception('Gagal menyimpan ke database.');
      }

      // 5. Tampilkan dialog sukses
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successColor, size: 30),
              const SizedBox(width: 10),
              Text('Terima Kasih!', style: AppTheme.headingSmall),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Feedback Anda telah berhasil disimpan!', // <-- Pesan diubah
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '⭐ $_rating/5',
                style: AppTheme.headingMedium.copyWith(color: AppTheme.secondaryColor),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman profile
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
      );

    } catch (e) {
      // 6. Tampilkan error jika gagal
      _showSnackBar('Terjadi kesalahan: $e', isError: true);
    } finally {
      // 7. Hentikan loading
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // (Fungsi ini dipanggil di _handleSubmit, tapi tidak ada di kodemu)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTheme.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor:
            isError ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saran & Kesan'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ... (SEMUA KODE UI KAMU DARI SINI KE BAWAH TETAP SAMA) ...
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.feedback, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Berapa nilai Anda untuk mata kuliah ini?',
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < _rating ? Icons.star : Icons.star_border,
                          color: AppTheme.secondaryColor,
                        ),
                        onPressed: () {
                          setState(() => _rating = i + 1);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _kesanController,
                    maxLines: 5,
                    style: AppTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText:
                          'Tuliskan kesan Anda tentang mata kuliah ini...\n\nContoh:\n- Materi mudah dipahami\n- Dosen sangat interaktif\n- Project menarik',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kesan wajib diisi';
                      }
                      if (value.trim().length < 10) {
                        return 'Kesan minimal 10 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _saranController,
                    maxLines: 5,
                    style: AppTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText:
                          'Tuliskan saran Anda untuk perbaikan...\n\nContoh:\n- Tambahkan lebih banyak studi kasus\n- Lebih banyak waktu untuk praktikum\n- Materi state management lebih detail',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Saran wajib diisi';
                      }
                      if (value.trim().length < 10) {
                        return 'Saran minimal 10 karakter';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.secondaryColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Feedback Anda akan membantu meningkatkan kualitas pembelajaran.',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(Icons.send),
                    label: const Text('Kirim Feedback'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Shinzou wo Sasageyo! 🗡️',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// lib/pages/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/services/auth.dart';
import '/models/user_model.dart';
import '/config/theme.dart';
import '/config/routes.dart';
import '/services/notif.dart'; 
import '/pages/profile/view_feedback_page.dart'; // Import halaman feedback

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    _currentUser = _authService.currentUser;
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() => _imageFile = File(image.path));
        await _updateProfileImage(image.path);
      }
    } catch (e) {
      _showSnackBar('Gagal memilih gambar: $e', isError: true);
    }
  }

  Future<void> _updateProfileImage(String imagePath) async {
    if (_currentUser == null) return;

    final result = await _authService.updateProfile(
      userId: _currentUser!.id!,
      profileImage: imagePath,
    );

    if (result['success']) {
      setState(() => _currentUser = result['user']);
      _showSnackBar('Foto profil berhasil diupdate!');
    } else {
      _showSnackBar(result['message'], isError: true);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await _showLogoutDialog();
    if (confirm == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        title: Text('Konfirmasi Logout', style: AppTheme.headingSmall),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: AppTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout', style: AppTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
              const SizedBox(height: 16),
              Text('User tidak ditemukan', style: AppTheme.headingSmall),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Kembali ke Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildMenuList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      decoration: AppTheme.primaryGradient,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppTheme.backgroundColor,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : _currentUser?.profileImage != null
                        ? FileImage(File(_currentUser!.profileImage!))
                        : null,
                child: _imageFile == null &&
                        _currentUser?.profileImage == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryColor, width: 2),
                    ),
                    child: Icon(Icons.camera_alt,
                        color: AppTheme.primaryColor, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _currentUser?.username ?? 'Scout',
            style: AppTheme.headingMedium.copyWith(color: Colors.white),
          ),
          if (_currentUser?.fullName != null) ...[
            const SizedBox(height: 4),
            Text(
              _currentUser!.fullName!,
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.secondaryColor),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.email, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  _currentUser?.email ?? '',
                  style: AppTheme.bodyMedium.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 👇 FUNGSI INI DIMODIFIKASI (DIHAPUS MENU-NYA) 👇 ---
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ratakan judul
        children: [
          
          // --- "Edit Profile" DIHAPUS DARI SINI ---

          _buildMenuItem(
            icon: Icons.feedback,
            title: 'Saran & Kesan',
            subtitle: 'Berikan feedback untuk mata kuliah',
            onTap: () => Navigator.pushNamed(context, AppRoutes.feedback),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.list_alt,
            title: 'Lihat Feedback',
            subtitle: 'Lihat riwayat feedback Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewFeedbackPage()),
              );
            },
          ),
          
          // --- "Tentang Aplikasi" DIHAPUS DARI SINI ---

          const SizedBox(height: 24), // Spacer pemisah

          Text(
            'Tes Notifikasi',
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Tombol Tes 1 (Sudah ada)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                NotificationService().scheduleNotification(
                  id: 1, // ID unik
                  title: 'Halo, Scout!',
                  body: 'Shinzou wo Sasageyo! Season 4 is coming!',
                  delay: const Duration(seconds: 3),
                );
                _showSnackBar('Notifikasi dijadwalkan 3 detik dari sekarang!');
              },
              child: const Text('Notifikasi di dalam Aplikasi'),
            ),
          ),
          const SizedBox(height: 12),
          
          // Tombol Tes 2 (Sudah ada)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                NotificationService().scheduleNotification(
                  id: 2, // ID unik
                  title: 'Halo, Scout!',
                  body: 'Shinzou wo Sasageyo! Season 4 is coming!',
                  delay: const Duration(seconds: 5),
                );
                _showSnackBar('Notifikasi dijadwalkan 5 detik lagi. Tutup aplikasi sekarang!');
              },
              child: const Text('Notifikasi di luar Aplikasi'),
            ),
          ),

          const SizedBox(height: 24), 
          
          // Ini tombol Logout yg sudah ada
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // --- 👆 BATAS FUNGSI YANG DIMODIFIKASI 👆 ---

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white), 
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.headingSmall),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTheme.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppTheme.textColor),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI INI SUDAH TIDAK DIPANGGIL LAGI, TAPI BIARKAN SAJA ---
  // --- ATAU HAPUS JIKA MAU ---
  // void _showAboutDialog() {
  //    showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: AppTheme.backgroundColor,
  //       title: Row(
  //         children: [
  //           Icon(Icons.shield, color: AppTheme.primaryColor),
  //           const SizedBox(width: 8),
  //           Text('Scout Regiment', style: AppTheme.headingSmall),
  //         ],
  //       ),
  //       content: Column(
  //         // ... (isi dialog)
  //       ),
  //       actions: [
  //         // ... (actions dialog)
  //       ],
  //     ),
  //   );
  // }
}
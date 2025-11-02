// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '/database/dao/user_dao.dart';
import '/database/dao/session_dao.dart';
import '/models/user_model.dart';
import 'encrypt.dart';
import 'dart:io'; 
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _encryptionService = EncryptionService();
  final _userDao = UserDao();
  final _sessionDao = SessionDao();

  User? _currentUser;
  User? get currentUser => _currentUser;

  /// Register user baru
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    // ... (Fungsi register kamu, biarkan saja, sudah benar)
    try {
      // Validasi email sudah terdaftar atau belum
      final existingUser = await _userDao.getUserByEmail(email);
      if (existingUser != null) {
        return {
          'success': false,
          'message': 'Email sudah terdaftar!',
        };
      }

      // Validasi username sudah ada atau belum
      final existingUsername = await _userDao.getUserByUsername(username);
      if (existingUsername != null) {
        return {
          'success': false,
          'message': 'Username sudah digunakan!',
        };
      }

    // Enkripsi password pakai bcrypt
    final hashedPassword = _encryptionService.hashPassword(password);

      // Buat user baru
      final newUser = User(
        username: username,
        email: email,
        password: hashedPassword,
        fullName: fullName ?? username,
        createdAt: DateTime.now(),
      );

      // Simpan ke database
      final userId = await _userDao.insertUser(newUser);

      if (userId > 0) {
        return {
          'success': true,
          'message': 'Registrasi berhasil! Silakan login.',
          'userId': userId,
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menyimpan data. Coba lagi.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String emailOrUsername,
    required String password,
  }) async {
    // ... (Fungsi login kamu, biarkan saja, sudah benar)
    try {
      // Cari user berdasarkan email atau username
      User? user;
      
      if (emailOrUsername.contains('@')) {
        user = await _userDao.getUserByEmail(emailOrUsername);
      } else {
        user = await _userDao.getUserByUsername(emailOrUsername);
      }

      if (user == null) {
        return {
          'success': false,
          'message': 'User tidak ditemukan!',
        };
      }

      // Verifikasi password pakai bcrypt
      final isPasswordValid = _encryptionService.checkPassword(
        password,
        user.password,
      );

      if (!isPasswordValid) {
        return {
          'success': false,
          'message': 'Password salah!',
        };
      }

      // Generate session token
      final token = _encryptionService.generateSessionToken(user.id.toString());

      // Simpan session ke database
      final newSession = Session(
        userId: user.id!,
        token: token,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 7)), // misal 7 hari
        isActive: true,
      );
      await _sessionDao.createSession(newSession);

      // Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id!);
      await prefs.setString('session_token', token);
      await prefs.setBool('is_logged_in', true);

      // Set current user
      _currentUser = user;

      return {
        'success': true,
        'message': 'Login berhasil!',
        'user': user,
        'token': token,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// Check apakah user sudah login
  Future<bool> isLoggedIn() async {
    // ... (Fungsi isLoggedIn kamu, biarkan saja, sudah benar)
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final userId = prefs.getInt('user_id');
      final token = prefs.getString('session_token');

      if (isLoggedIn && userId != null && token != null) {
        // Validasi session masih aktif
        final isValid = await _sessionDao.isSessionValid(token);
        
        if (isValid) {
          // Load current user data
          _currentUser = await _userDao.getUserById(userId);
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    // ... (Fungsi logout kamu, biarkan saja, sudah benar)
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final token = prefs.getString('session_token');

      // Hapus session dari database
      if (userId != null && token != null) {
        await _sessionDao.deactivateSessionByToken(token);
      }

      // Clear SharedPreferences
      await prefs.remove('user_id');
      await prefs.remove('session_token');
      await prefs.setBool('is_logged_in', false);

      // Clear current user
      _currentUser = null;
    } catch (e) {
      // Handle error
      print('Logout error: $e');
    }
  }

  // --- 👇 FUNGSI INI DIMODIFIKASI 👇 ---
  /// Update profile user
  Future<Map<String, dynamic>> updateProfile({
    required int userId,
    String? fullName,
    String? profileImage, // Ini adalah PATH SEMENTARA dari image_picker
  }) async {
    try {
      final user = await _userDao.getUserById(userId);
      if (user == null) {
        return {
          'success': false,
          'message': 'User tidak ditemukan!',
        };
      }

      // --- 👇 LOGIKA BARU UNTUK MENYALIN FILE 👇 ---
      String? permanentImagePath = user.profileImage; // Default: path lama

      // Cek jika user GANTI FOTO (profileImage tidak null)
      if (profileImage != null) {
        // 1. Dapatkan path file asli (sementara)
        final File tempImageFile = File(profileImage);
        
        // 2. Dapatkan folder dokumen (permanent)
        final Directory appDir = await getApplicationDocumentsDirectory();
        
        // 3. Buat nama file baru (kita pakai nama aslinya)
        final String fileName = p.basename(tempImageFile.path);
        
        // 4. Buat path tujuan (permanent)
        final String permanentPath = p.join(appDir.path, fileName);
        
        // 5. Salin file dari temporary ke permanent
        // (try-catch untuk jaga-jaga jika file lama sama)
        try {
          await tempImageFile.copy(permanentPath);
        } catch (e) {
          print("Error copying file (mungkin file sudah ada): $e");
        }
        
        // 6. Simpan path permanent ini ke database
        permanentImagePath = permanentPath;
      }
      // --- 👆 BATAS LOGIKA BARU 👆 ---

      // Buat user baru dengan data yang di-update
      final updatedUser = User(
        id: user.id,
        username: user.username,
        email: user.email,
        password: user.password,
        fullName: fullName ?? user.fullName,
        profileImage: permanentImagePath, // <-- Simpan path permanent
        createdAt: user.createdAt,
      );

      final result = await _userDao.updateUser(updatedUser);

      if (result > 0) {
        _currentUser = updatedUser; // Update user yang sedang aktif
        return {
          'success': true,
          'message': 'Profile berhasil diupdate!',
          'user': updatedUser,
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal update profile.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
  // --- 👆 BATAS FUNGSI YANG DIMODIFIKASI 👆 ---

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    // ... (Fungsi changePassword kamu, biarkan saja, sudah benar)
    try {
      final user = await _userDao.getUserById(userId);
      if (user == null) {
        return {
          'success': false,
          'message': 'User tidak ditemukan!',
        };
      }

      // Verifikasi old password pakai bcrypt
      final isValid = _encryptionService.checkPassword(
        oldPassword,
        user.password,
      );

      if (!isValid) {
        return {
          'success': false,
          'message': 'Password lama salah!',
        };
      }

      // Enkripsi password baru pakai bcrypt
      final newHashedPassword = _encryptionService.hashPassword(newPassword);

      // Update password
      final updatedUser = User(
        id: user.id,
        username: user.username,
        email: user.email,
        password: newHashedPassword,
        fullName: user.fullName,
        profileImage: user.profileImage,
        createdAt: user.createdAt,
      );

      final result = await _userDao.updateUser(updatedUser);

      if (result > 0) {
        return {
          'success': true,
          'message': 'Password berhasil diubah!',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengubah password.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
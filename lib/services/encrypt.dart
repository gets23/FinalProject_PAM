// lib/services/encryption_service.dart
import 'package:crypto/crypto.dart';
import 'package:bcrypt/bcrypt.dart';
import 'dart:convert';

class EncryptionService {
  // Singleton pattern
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();


  String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool checkPassword(String plain, String hash) {
    return BCrypt.checkpw(plain, hash);
  }

  /// Generate session token untuk user yang login
  String generateSessionToken(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = '$userId-$timestamp-scout_session';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
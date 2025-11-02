// lib/utils/constants.dart

class Constants {
  // Error Messages
  static const String errorNetwork = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
  static const String errorUnknown = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String errorTimeout = 'Request timeout. Server tidak merespon.';
  static const String errorNotFound = 'Data tidak ditemukan.';
  static const String errorServer = 'Server error. Silakan coba beberapa saat lagi.';
  
  // Auth Messages
  static const String errorInvalidCredentials = 'Email atau password salah.';
  static const String errorUserExists = 'User dengan email ini sudah terdaftar.';
  static const String errorWeakPassword = 'Password terlalu lemah. Min. 6 karakter.';
  static const String errorInvalidEmail = 'Format email tidak valid.';
  static const String errorPasswordMismatch = 'Password tidak cocok.';
  static const String errorSessionExpired = 'Sesi Anda telah berakhir. Silakan login kembali.';
  
  // Success Messages
  static const String successLogin = 'Login berhasil! Selamat datang, Scout!';
  static const String successRegister = 'Registrasi berhasil! Silakan login.';
  static const String successLogout = 'Anda telah logout.';
  static const String successProfileUpdate = 'Profile berhasil diupdate.';
  static const String successFeedbackSubmit = 'Terima kasih atas feedback Anda!';
  
  // Validation Messages
  static const String validationRequired = 'Field ini wajib diisi';
  static const String validationEmailInvalid = 'Format email tidak valid';
  static const String validationPasswordShort = 'Password minimal 6 karakter';
  static const String validationPasswordLong = 'Password maksimal 20 karakter';
  static const String validationUsernameShort = 'Username minimal 3 karakter';
  static const String validationUsernameLong = 'Username maksimal 20 karakter';
  static const String validationPasswordMismatch = 'Password tidak cocok';
  
  // Dialog Titles
  static const String dialogError = 'Error';
  static const String dialogSuccess = 'Berhasil';
  static const String dialogConfirm = 'Konfirmasi';
  static const String dialogInfo = 'Informasi';
  static const String dialogLogout = 'Logout';
  
  // Dialog Messages
  static const String dialogLogoutMessage = 'Apakah Anda yakin ingin logout?';
  static const String dialogDeleteMessage = 'Apakah Anda yakin ingin menghapus ini?';
  
  // Button Labels
  static const String btnLogin = 'Login';
  static const String btnRegister = 'Daftar';
  static const String btnLogout = 'Logout';
  static const String btnSave = 'Simpan';
  static const String btnCancel = 'Batal';
  static const String btnYes = 'Ya';
  static const String btnNo = 'Tidak';
  static const String btnOk = 'OK';
  static const String btnSubmit = 'Kirim';
  static const String btnEdit = 'Edit';
  static const String btnDelete = 'Hapus';
  static const String btnRetry = 'Coba Lagi';
  
  // Labels
  static const String labelEmail = 'Email';
  static const String labelPassword = 'Password';
  static const String labelConfirmPassword = 'Konfirmasi Password';
  static const String labelUsername = 'Username';
  static const String labelFullName = 'Nama Lengkap';
  static const String labelSearch = 'Cari...';
  static const String labelNoData = 'Tidak ada data';
  static const String labelLoading = 'Memuat...';
  
  // Bottom Nav Labels
  static const String navHome = 'Home';
  static const String navCharacters = 'Characters';
  static const String navMap = 'Map';
  static const String navProfile = 'Profile';
  
  // Character Status
  static const String statusAlive = 'Alive';
  static const String statusDeceased = 'Deceased';
  static const String statusUnknown = 'Unknown';
  
  // Placeholder Text
  static const String placeholderSearch = 'Cari karakter, species...';
  static const String placeholderNoFavorites = 'Belum ada karakter favorit';
  static const String placeholderNoEpisodes = 'Belum ada episode';
  
  // AOT Quotes (untuk splash atau loading)
  static const List<String> aotQuotes = [
    'Tatakae! Tatakae!',
    'If you win, you live. If you lose, you die.',
    'Nothing can suppress a human\'s curiosity.',
    'I want to see and understand the world outside.',
    'Are you the prey? No, we are the hunters!',
    'Those who can accomplish their goal are those who can discard for their goal.',
    'The world is cruel, but also very beautiful.',
    'I dispose of my enemies. That\'s what I do.',
  ];
  
  // Wings of Freedom motto
  static const String motto = 'Shinzou wo Sasageyo!';
  static const String mottoTranslation = 'Dedicate Your Hearts!';
  
  // Database Tables
  static const String tableUsers = 'users';
  static const String tableSessions = 'sessions';
  static const String tableFavorites = 'favorites';
  static const String tableWatchedEpisodes = 'watched_episodes';
  
  // Asset Paths (setelah assets ditambahkan)
  static const String logoPath = 'assets/images/logo.png';
  static const String wingsPath = 'assets/images/wings_of_freedom.png';
  static const String defaultAvatarPath = 'assets/images/default_avatar.png';
  static const String wallsBackgroundPath = 'assets/images/walls_background.jpg';
  
  // Notification Types
  static const String notifTypeCharacter = 'character';
  static const String notifTypeEpisode = 'episode';
  static const String notifTypeMission = 'mission';
  static const String notifTypeDaily = 'daily';
  
  // Date Formats
  static const String dateFormatFull = 'dd MMMM yyyy';
  static const String dateFormatShort = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}
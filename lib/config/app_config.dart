// lib/config/app_config.dart

class AppConfig {
  // ==================== APP INFO ====================
  static const String appName = 'Scout Regiment Companion';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Dedicate Your Heart';
  
  // ==================== API CONFIG ====================
  static const String baseUrl = 'https://api.attackontitanapi.com';
  
  // API Endpoints
  static const String charactersEndpoint = '/characters';
  static const String episodesEndpoint = '/episodes';
  static const String locationsEndpoint = '/locations';
  static const String titansEndpoint = '/titans';
  static const String organizationsEndpoint = '/organizations';
  
  // ==================== DATABASE CONFIG ====================
  static const String databaseName = 'scout_regiment.db';
  static const int databaseVersion = 7;
  
  // Table names
  static const String usersTable = 'users';
  static const String sessionsTable = 'sessions';
  static const String favoritesTable = 'favorites';
  static const String watchedEpisodesTable = 'watched_episodes';
  
  // ==================== SECURITY CONFIG ====================
  static const String encryptionSalt = 'aot_scout_regiment_2024';
  static const int sessionExpiryDays = 30;
  static const int minPasswordLength = 6;
  
  // ==================== UI CONFIG ====================
  static const int gridCrossAxisCount = 2;
  static const double defaultPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;
  
  // ==================== PAGINATION ====================
  static const int itemsPerPage = 20;
  static const int previewItemCount = 5;
  
  // ==================== ASSETS ====================
  static const String logoPath = 'assets/images/logo.png';
  static const String wingsOfFreedomPath = 'assets/images/wings_of_freedom.png';
  static const String defaultAvatarPath = 'assets/images/default_avatar.png';
  
  // ==================== CURRENCY CODES ====================
  static const List<String> supportedCurrencies = [
    'IDR', // Indonesian Rupiah
    'USD', // US Dollar
    'EUR', // Euro
    'JPY', // Japanese Yen
    'GBP', // British Pound
  ];
  
  // ==================== TIME ZONES ====================
  static const List<Map<String, String>> supportedTimeZones = [
    {'code': 'WIB', 'name': 'Western Indonesia Time', 'offset': '+07:00'},
    {'code': 'WITA', 'name': 'Central Indonesia Time', 'offset': '+08:00'},
    {'code': 'WIT', 'name': 'Eastern Indonesia Time', 'offset': '+09:00'},
    {'code': 'JST', 'name': 'Japan Standard Time', 'offset': '+09:00'},
    {'code': 'GMT', 'name': 'Greenwich Mean Time', 'offset': '+00:00'},
  ];
  
  // ==================== NOTIFICATION CONFIG ====================
  static const String notificationChannelId = 'scout_regiment_channel';
  static const String notificationChannelName = 'Scout Regiment Notifications';
  static const String notificationChannelDescription = 'Notifications for Scout Regiment Companion';
  
  // ==================== LOCATION CONFIG ====================
  // Dummy coordinates untuk AOT locations (demo purposes)
  static const Map<String, Map<String, double>> aotLocations = {
    'Wall Maria': {'lat': -6.9175, 'lng': 107.6191},
    'Wall Rose': {'lat': -6.9205, 'lng': 107.6211},
    'Wall Sina': {'lat': -6.9235, 'lng': 107.6231},
    'Shiganshina': {'lat': -6.9145, 'lng': 107.6171},
    'Trost District': {'lat': -6.9165, 'lng': 107.6201},
  };
  
  // ==================== VALIDATION ====================
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minFullNameLength = 3;
  
  // Email regex pattern
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // ==================== ERROR MESSAGES ====================
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please login again.';
  static const String dataNotFoundMessage = 'Data not found.';
  
  // ==================== SUCCESS MESSAGES ====================
  static const String loginSuccessMessage = 'Login successful!';
  static const String registerSuccessMessage = 'Registration successful!';
  static const String logoutSuccessMessage = 'Logged out successfully!';
  static const String updateSuccessMessage = 'Updated successfully!';
  static const String deleteSuccessMessage = 'Deleted successfully!';
}
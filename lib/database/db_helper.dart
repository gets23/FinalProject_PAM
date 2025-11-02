// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/config/app_config.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter untuk database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize Database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);

    return await openDatabase(
      path,
      version: AppConfig.databaseVersion, // Ini akan membaca versi baru (misal: 2)
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Ini akan terpicu!
    );
  }

  // Create Tables
  Future<void> _createDB(Database db, int version) async {
    // Fungsi ini sudah benar, untuk user yang baru install
    // Table: users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        full_name TEXT,
        profile_image TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Table: sessions
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        token TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        expires_at TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Table: favorites
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        character_id INTEGER NOT NULL,
        character_name TEXT NOT NULL,
        character_image TEXT,
        added_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        UNIQUE(user_id, character_id)
      )
    ''');

    // Table: watched_episodes
    await db.execute('''
      CREATE TABLE watched_episodes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        episode_id INTEGER NOT NULL,
        episode_name TEXT NOT NULL,
        watched_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        UNIQUE(user_id, episode_id)
      )
    ''');

    // Table: feedback (Sudah ada, bagus)
    await db.execute('''
      CREATE TABLE feedback (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        rating INTEGER NOT NULL,
        kesan TEXT NOT NULL,
        saran TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes untuk performance (Sudah ada, bagus)
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_sessions_token ON sessions(token)');
    await db.execute('CREATE INDEX idx_sessions_user_id ON sessions(user_id)');
    await db.execute('CREATE INDEX idx_favorites_user_id ON favorites(user_id)');
    await db.execute('CREATE INDEX idx_watched_user_id ON watched_episodes(user_id)');
    await db.execute('CREATE INDEX idx_feedback_user_id ON feedback(user_id)');
  }

  // Upgrade Database (untuk versi selanjutnya)
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    
    print('UPGRADING DATABASE from v$oldVersion to v$newVersion');

    // Jika user datang dari versi 1 (sebelum ada feedback)
    if (oldVersion < 2) {
      // 1. Buat tabel feedback
      await db.execute('''
        CREATE TABLE feedback (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          rating INTEGER NOT NULL,
          kesan TEXT NOT NULL,
          saran TEXT NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
      
      // 2. Buat index-nya
      await db.execute('CREATE INDEX idx_feedback_user_id ON feedback(user_id)');
      
      print('Database upgrade complete: Table feedback created.');
    }

    if (oldVersion < (AppConfig.databaseVersion)) {
      print('Membersihkan data lama dari tabel feedback...');
      await db.delete('feedback');
    }
  }


  // Close Database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Clear all data (untuk testing/reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('sessions');
    await db.delete('favorites');
    await db.delete('watched_episodes');
    await db.delete('feedback'); // Tambahkan feedback di sini
  }

  // Delete Database (untuk testing)
  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);
    await deleteDatabase(path);
    _database = null;
  }
}
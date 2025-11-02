// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/config/app_config.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);

    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // --- 👇 INI FUNGSI UNTUK INSTALL BARU (WAJIB LENGKAP) 👇 ---
  Future<void> _createDB(Database db, int version) async {
    print('--- EXECUTING _createDB (NEW INSTALL) ---');
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
    // Table: favorites (Karakter)
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
    // Table: feedback
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
    
    // --- 👇 INI DIA YANG HILANG KEMARIN 👇 ---
    // Table: favorite_titans
    await db.execute('''
      CREATE TABLE favorite_titans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        titan_id INTEGER NOT NULL,
        titan_name TEXT NOT NULL,
        titan_image TEXT,
        added_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        UNIQUE(user_id, titan_id)
      )
    ''');
    // --- 👆 BATAS TAMBAHAN 👆 ---

    // Create indexes
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_sessions_token ON sessions(token)');
    await db.execute('CREATE INDEX idx_sessions_user_id ON sessions(user_id)');
    await db.execute('CREATE INDEX idx_favorites_user_id ON favorites(user_id)');
    await db.execute('CREATE INDEX idx_watched_user_id ON watched_episodes(user_id)');
    await db.execute('CREATE INDEX idx_feedback_user_id ON feedback(user_id)');
    await db.execute('CREATE INDEX idx_favorite_titans_user_id ON favorite_titans(user_id)');
    
    print('--- _createDB FINISHED ---');
  }

  // --- 👇 INI FUNGSI UNTUK UPGRADE (JIKA USER SUDAH PUNYA V1/V2) 👇 ---
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    
    print('--- EXECUTING _upgradeDB ---');
    print('--- OldVersion: $oldVersion, NewVersion: $newVersion ---');

    // Versi 1: users, sessions, favorites, watched_episodes
    // Versi 2: Menambahkan 'feedback'
    // Versi 3: Menambahkan 'favorite_titans'

    // Jika user datang dari v1 (belum punya feedback & favorite_titans)
    if (oldVersion < 2) {
      print('Upgrading from v1: Adding feedback table...');
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
      await db.execute('CREATE INDEX idx_feedback_user_id ON feedback(user_id)');
    }

    // Jika user datang dari v1 atau v2 (belum punya favorite_titans)
    if (oldVersion < 3) {
      print('Upgrading from v2: Adding favorite_titans table...');
      await db.execute('''
        CREATE TABLE favorite_titans (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          titan_id INTEGER NOT NULL,
          titan_name TEXT NOT NULL,
          titan_image TEXT,
          added_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
          UNIQUE(user_id, titan_id)
        )
      ''');
      await db.execute('CREATE INDEX idx_favorite_titans_user_id ON favorite_titans(user_id)');
    }
  }

  // --- (Sisa file: close, clearAllData, deleteDB) ---
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
  
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('sessions');
    await db.delete('favorites');
    await db.delete('watched_episodes');
    await db.delete('feedback');
    await db.delete('favorite_titans'); // <-- Tambahkan ini
  }
  
  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);
    await deleteDatabase(path);
    _database = null;
  }
}
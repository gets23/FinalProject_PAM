// lib/pages/characters/favorites_page.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/services/auth.dart';

// --- 👇 Import kedua DAO dan Model 👇 ---
import '/database/dao/fav_dao.dart';
import '/models/fav_model.dart';
import '/database/dao/fav_titan_dao.dart';
import '/models/fav_titan_model.dart';
// --- 👆 Batas Import 👆 ---

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

// --- 👇 Tambahkan 'with SingleTickerProviderStateMixin' 👇 ---
class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final FavoriteDao _favoriteDao = FavoriteDao();
  final FavoriteTitanDao _favoriteTitanDao = FavoriteTitanDao(); // <-- Dao baru

  // (Kita tidak pakai _favoritesFuture lagi, data diambil per-tab)
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController untuk 2 tab
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser?.id;
    
    // Jika user (tiba-tiba) null, tampilkan error
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favorit Saya')),
        body: Center(child: Text('User tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        // --- 👇 Buat AppBar baru dengan TabBar 👇 ---
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: AppTheme.accentColor,
          indicatorWeight: 3.0,
          tabs: const [
            Tab(
              icon: Icon(Icons.people),
              text: 'Karakter',
            ),
            Tab(
              icon: Icon(Icons.shield),
              text: 'Titan',
            ),
          ],
        ),
        // --- 👆 Batas AppBar 👆 ---
      ),
      backgroundColor: AppTheme.backgroundColor,
      // --- 👇 Buat Body baru dengan TabBarView 👇 ---
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- Tab 1: List Favorit Karakter ---
          _buildCharacterFavoritesList(userId),
          
          // --- Tab 2: List Favorit Titan ---
          _buildTitanFavoritesList(userId),
        ],
      ),
      // --- 👆 Batas Body 👆 ---
    );
  }

  // --- WIDGET BARU: BUILDER UNTUK LIST FAVORIT KARAKTER ---
  Widget _buildCharacterFavoritesList(int userId) {
    return FutureBuilder<List<FavoriteModel>>(
      // Panggil Dao Karakter
      future: _favoriteDao.getAllFavorites(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final favorites = snapshot.data;
        if (favorites == null || favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 60, color: AppTheme.textColor),
                const SizedBox(height: 16),
                Text('Belum ada karakter favorit.', style: AppTheme.bodyMedium),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final fav = favorites[index];
            return _FavoriteCharacterCard(
              favorite: fav,
              authService: _authService,
              favoriteDao: _favoriteDao,
              onUnfavorited: () {
                setState(() {}); // Refresh halaman
              },
            );
          },
        );
      },
    );
  }

  // --- WIDGET BARU: BUILDER UNTUK LIST FAVORIT TITAN ---
  Widget _buildTitanFavoritesList(int userId) {
    return FutureBuilder<List<FavoriteTitanModel>>(
      // Panggil Dao Titan
      future: _favoriteTitanDao.getAllFavorites(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final favorites = snapshot.data;
        if (favorites == null || favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 60, color: AppTheme.textColor),
                const SizedBox(height: 16),
                Text('Belum ada titan favorit.', style: AppTheme.bodyMedium),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final fav = favorites[index];
            return _FavoriteTitanCard(
              favorite: fav,
              authService: _authService,
              favoriteDao: _favoriteTitanDao,
              onUnfavorited: () {
                setState(() {}); // Refresh halaman
              },
            );
          },
        );
      },
    );
  }
}

// --- Card untuk Karakter Favorit (Nama diganti) ---
class _FavoriteCharacterCard extends StatelessWidget {
  final FavoriteModel favorite;
  final AuthService authService;
  final FavoriteDao favoriteDao;
  final VoidCallback onUnfavorited;

  const _FavoriteCharacterCard({
    required this.favorite,
    required this.authService,
    required this.favoriteDao,
    required this.onUnfavorited,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      color: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.network(
            favorite.characterImage ?? 'https://via.placeholder.com/100',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              width: 100,
              height: 100,
              color: AppTheme.backgroundColor,
              child: Icon(Icons.person, size: 40, color: AppTheme.textColor),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                favorite.characterName,
                style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: AppTheme.accentColor),
            tooltip: 'Hapus dari favorit',
            onPressed: () async {
              final userId = authService.currentUser?.id;
              if (userId != null) {
                await favoriteDao.removeFavorite(userId, favorite.characterId);
                onUnfavorited();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${favorite.characterName} dihapus dari favorit.'),
                    backgroundColor: AppTheme.accentColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// --- WIDGET CARD BARU UNTUK TITAN FAVORIT ---
class _FavoriteTitanCard extends StatelessWidget {
  final FavoriteTitanModel favorite;
  final AuthService authService;
  final FavoriteTitanDao favoriteDao;
  final VoidCallback onUnfavorited;

  const _FavoriteTitanCard({
    required this.favorite,
    required this.authService,
    required this.favoriteDao,
    required this.onUnfavorited,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      color: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.network(
            favorite.titanImage ?? 'https://via.placeholder.com/100',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              width: 100,
              height: 100,
              color: AppTheme.backgroundColor,
              child: Icon(Icons.shield, size: 40, color: AppTheme.textColor),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                favorite.titanName,
                style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: AppTheme.accentColor),
            tooltip: 'Hapus dari favorit',
            onPressed: () async {
              final userId = authService.currentUser?.id;
              if (userId != null) {
                await favoriteDao.removeFavorite(userId, favorite.titanId);
                onUnfavorited();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${favorite.titanName} dihapus dari favorit.'),
                    backgroundColor: AppTheme.accentColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
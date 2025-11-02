// lib/pages/characters/favorites_page.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/services/auth.dart';
import '/database/dao/fav_dao.dart';
import '/models/fav_model.dart';
// Hapus import titan

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

// Hapus 'with SingleTickerProviderStateMixin'
class _FavoritesPageState extends State<FavoritesPage> {
  final AuthService _authService = AuthService();
  final FavoriteDao _favoriteDao = FavoriteDao();
  late Future<List<FavoriteModel>> _favoritesFuture; // <-- Kembalikan ini

  // Hapus TabController
  // Hapus FavoriteTitanDao

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    // Hapus init TabController
  }

  void _loadFavorites() { // <-- Kembalikan fungsi ini
    final userId = _authService.currentUser?.id;
    if (userId != null) {
      setState(() {
        _favoritesFuture = _favoriteDao.getAllFavorites(userId);
      });
    } else {
      _favoritesFuture = Future.value([]);
    }
  }

  @override
  void dispose() {
    // Hapus dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karakter Favorit'), // <-- Ganti judul
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        // Hapus 'bottom: TabBar'
      ),
      backgroundColor: AppTheme.backgroundColor,
      // Hapus TabBarView, ganti dengan FutureBuilder biasa
      body: FutureBuilder<List<FavoriteModel>>(
        future: _favoritesFuture,
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

          // Tampilkan list favorit
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index];
              return _FavoriteCharacterCard( // Ganti jadi nama ini
                favorite: fav,
                authService: _authService,
                favoriteDao: _favoriteDao,
                onUnfavorited: _loadFavorites, // <-- Panggil _loadFavorites
              );
            },
          );
        },
      ),
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
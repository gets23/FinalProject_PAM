// lib/pages/characters/titan_list_tab.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/models/titan_model.dart'; 
import '/services/api.dart'; 
import '/widgets/cards/titan_card.dart'; 
import '/pages/characters/titan_detail_page.dart';

// --- 👇 TAMBAHKAN IMPORT BARU 👇 ---
import '/services/auth.dart';
import '/database/dao/fav_titan_dao.dart';
import '/models/fav_titan_model.dart';
// --- 👆 BATAS TAMBAHAN 👆 ---

class TitanListTab extends StatefulWidget {
  const TitanListTab({Key? key}) : super(key: key);

  @override
  State<TitanListTab> createState() => _TitanListTabState();
}

class _TitanListTabState extends State<TitanListTab> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  // --- 👇 TAMBAHKAN DAO & AUTH 👇 ---
  final FavoriteTitanDao _favoriteDao = FavoriteTitanDao();
  final AuthService _authService = AuthService();
  // --- 👆 BATAS TAMBAHAN 👆 ---

  late Future<List<Titan>> _titansFuture;
  List<Titan> _allTitans = [];
  List<Titan> _filteredTitans = [];

  // --- 👇 TAMBAHKAN STATE FAVORIT BARU 👇 ---
  Set<int> _favoriteTitanIds = {};
  // --- 👆 BATAS TAMBAHAN 👆 ---

  @override
  void initState() {
    super.initState();
    _titansFuture = _loadTitans();
    _loadFavoriteTitanIds(); // <-- Panggil fungsi load favorit
    _searchController.addListener(_filterTitans);
  }

  Future<List<Titan>> _loadTitans() async {
    // ... (Fungsi ini sudah benar)
    try {
      final titans = await _apiService.getTitans(); 
      if (mounted) {
        setState(() {
          _allTitans = titans;
          _filteredTitans = titans;
        });
      }
      return titans;
    } catch (e) {
      print('Error loading titans: $e');
      throw Exception('Failed to load titans');
    }
  }

  // --- 👇 FUNGSI BARU UNTUK LOAD ID FAVORIT TITAN 👇 ---
  Future<void> _loadFavoriteTitanIds() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;
    final ids = await _favoriteDao.getAllFavoriteIds(userId);
    if (mounted) {
      setState(() {
        _favoriteTitanIds = ids;
      });
    }
  }
  // --- 👆 BATAS TAMBAHAN 👆 ---

  // --- 👇 FUNGSI BARU UNTUK HANDLE TOGGLE FAVORIT TITAN 👇 ---
  Future<void> _handleFavoriteToggle(Titan titan) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan login untuk menambah favorit.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final isCurrentlyFavorite = _favoriteTitanIds.contains(titan.id);

    if (isCurrentlyFavorite) {
      // Hapus
      await _favoriteDao.removeFavorite(userId, titan.id);
      if (mounted) {
        setState(() {
          _favoriteTitanIds.remove(titan.id);
        });
      }
    } else {
      // Tambah
      final newFavorite = FavoriteTitanModel(
        userId: userId,
        titanId: titan.id,
        titanName: titan.name,
        titanImage: titan.pictureUrl,
        addedAt: DateTime.now().toIso8601String(),
      );
      await _favoriteDao.addFavorite(newFavorite);
      if (mounted) {
        setState(() {
          _favoriteTitanIds.add(titan.id);
        });
      }
    }
  }
  // --- 👆 BATAS TAMBAHAN 👆 ---

  void _filterTitans() {
    // ... (Fungsi ini sudah benar)
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTitans = _allTitans.where((titan) {
        final name = titan.name.toLowerCase();
        final description = titan.description?.toLowerCase() ?? '';
        final height = titan.height?.toLowerCase() ?? '';
        return name.contains(query) || 
               description.contains(query) || 
               height.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            // ... (TextField sudah benar)
            controller: _searchController,
            style: TextStyle(color: AppTheme.textColor),
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan nama, deskripsi, tinggi...',
              hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.7)),
              prefixIcon: Icon(Icons.search, color: AppTheme.textColor.withOpacity(0.7)),
              filled: true,
              fillColor: AppTheme.secondaryColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        
        Expanded(
          child: FutureBuilder<List<Titan>>(
            future: _titansFuture,
            builder: (context, snapshot) {
              // ... (Loading, Error, Empty states sudah benar)
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat data Titan. Periksa koneksi internet.',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                );
              }
              if (_filteredTitans.isEmpty) {
                return Center(
                  child: Text(
                    'Titan tidak ditemukan.',
                    style: TextStyle(color: AppTheme.textColor),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredTitans.length,
                itemBuilder: (context, index) {
                  final titan = _filteredTitans[index];
                  // --- 👇 CEK STATUS FAVORIT TITAN 👇 ---
                  final isFavorite = _favoriteTitanIds.contains(titan.id);

                  return TitanCard(
                    titan: titan,
                    // --- 👇 KIRIM DATA & FUNGSI BARU KE CARD 👇 ---
                    isFavorite: isFavorite,
                    onFavoriteToggle: () => _handleFavoriteToggle(titan),
                    // --- 👆 BATAS TAMBAHAN 👆 ---
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TitanDetailPage(titan: titan),
                        ),
                      ).then((_) {
                        _loadFavoriteTitanIds(); // Refresh saat kembali
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
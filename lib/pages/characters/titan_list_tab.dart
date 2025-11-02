// lib/pages/characters/titan_list_tab.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/models/titan_model.dart'; 
import '/services/api.dart'; 
import '/widgets/cards/titan_card.dart'; 
import '/pages/characters/titan_detail_page.dart'; 

// Hapus semua import favorit
// import '/services/auth.dart';
// import '/database/dao/favorite_titan_dao.dart';
// import '/models/favorite_titan_model.dart';

class TitanListTab extends StatefulWidget {
  const TitanListTab({Key? key}) : super(key: key);

  @override
  State<TitanListTab> createState() => _TitanListTabState();
}

class _TitanListTabState extends State<TitanListTab> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  // Hapus semua state favorit
  // final FavoriteTitanDao _favoriteDao = FavoriteTitanDao();
  // final AuthService _authService = AuthService();
  // Set<int> _favoriteTitanIds = {};

  late Future<List<Titan>> _titansFuture;
  List<Titan> _allTitans = [];
  List<Titan> _filteredTitans = [];

  @override
  void initState() {
    super.initState();
    _titansFuture = _loadTitans();
    // Hapus _loadFavoriteTitanIds();
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

  // Hapus fungsi _loadFavoriteTitanIds()
  // Hapus fungsi _handleFavoriteToggle()

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
              // ...
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
                  // Hapus logic isFavorite
                  
                  return TitanCard(
                    titan: titan,
                    // Hapus properti favorit
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TitanDetailPage(titan: titan),
                        ),
                      );
                      // Hapus .then()
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
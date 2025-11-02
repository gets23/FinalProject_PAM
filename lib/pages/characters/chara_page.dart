// lib/pages/characters/chara_page.dart
import '/models/chara_model.dart';
import '/pages/characters/chara_detail_page.dart';
import '/services/api.dart';
import '/widgets/cards/chara_card.dart';
import 'package:flutter/material.dart';

import '/config/theme.dart';
import '/services/auth.dart';
import '/database/dao/fav_dao.dart';
import '/models/fav_model.dart';
import '/pages/characters/fav_page.dart'; 
import '/pages/characters/titan_page.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  final FavoriteDao _favoriteDao = FavoriteDao();
  final AuthService _authService = AuthService();

  late Future<List<Character>> _charactersFuture;
  List<Character> _allCharacters = [];
  List<Character> _filteredCharacters = [];

  Set<int> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _charactersFuture = _loadCharacters();
    _loadFavoriteIds();
    _searchController.addListener(_filterCharacters);
  }

  Future<List<Character>> _loadCharacters() async {
    try {
      final characters = await _apiService.getCharacters();
      if (mounted) {
        setState(() {
          _allCharacters = characters;
          _filteredCharacters = characters;
        });
      }
      return characters;
    } catch (e) {
      print('Error loading characters: $e');
      throw Exception('Failed to load characters');
    }
  }

  Future<void> _loadFavoriteIds() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return; 

    final ids = await _favoriteDao.getAllFavoriteIds(userId);
    if (mounted) {
      setState(() {
        _favoriteIds = ids;
      });
    }
  }

  Future<void> _handleFavoriteToggle(Character character) async {
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

    final isCurrentlyFavorite = _favoriteIds.contains(character.id);

    if (isCurrentlyFavorite) {
      // --- HAPUS DARI FAVORIT ---
      await _favoriteDao.removeFavorite(userId, character.id);
      if (mounted) {
        setState(() {
          _favoriteIds.remove(character.id);
        });
      }
    } else {
      // --- TAMBAH KE FAVORIT ---
      final newFavorite = FavoriteModel(
        userId: userId,
        characterId: character.id,
        characterName: character.name,
        
        // --- 👇 PERBAIKAN DI SINI 👇 ---
        characterImage: character.pictureUrl, // <-- Ganti dari .img ke .pictureUrl
        // --- 👆 BATAS PERBAIKAN 👆 ---
        
        addedAt: DateTime.now().toIso8601String(),
      );
      await _favoriteDao.addFavorite(newFavorite);
      if (mounted) {
        setState(() {
          _favoriteIds.add(character.id);
        });
      }
    }
  }

  void _filterCharacters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCharacters = _allCharacters.where((character) {
        final name = character.name.toLowerCase();
        final species = character.species?.join(' ').toLowerCase() ?? '';
        
        return name.contains(query) || species.contains(query);
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, 
      appBar: AppBar(
        title: const Text('Karakter Attack on Titan'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            tooltip: 'Lihat Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              ).then((_) {
                _loadFavoriteIds();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shield),
            tooltip: 'Lihat Titan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TitansPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppTheme.textColor),
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama atau spesies...',
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
          
          // List Karakter
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }
                
                // Error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat data. Periksa koneksi internet.',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  );
                }
                
                // Data Kosong
                if (_filteredCharacters.isEmpty) {
                  return Center(
                    child: Text(
                      'Karakter tidak ditemukan.',
                      style: TextStyle(color: AppTheme.textColor),
                    ),
                  );
                }

                // Sukses
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _filteredCharacters.length,
                  itemBuilder: (context, index) {
                    final character = _filteredCharacters[index];
                    final isFavorite = _favoriteIds.contains(character.id);

                    return CharacterCard(
                      character: character,
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => _handleFavoriteToggle(character),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailPage(character: character),
                          ),
                        ).then((_) {
                          _loadFavoriteIds();
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
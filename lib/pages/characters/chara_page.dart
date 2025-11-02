import '/models/chara_model.dart';
import '/pages/characters/chara_detail_page.dart';
import '/services/api.dart';
import '/widgets/cards/chara_card.dart';
import 'package:flutter/material.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Character>> _charactersFuture;
  List<Character> _allCharacters = [];
  List<Character> _filteredCharacters = [];

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman dibuka
    _charactersFuture = _loadCharacters();
    
    // Listener untuk search bar
    _searchController.addListener(_filterCharacters);
  }

  // Fungsi untuk load data dari API
  Future<List<Character>> _loadCharacters() async {
    try {
      final characters = await _apiService.getCharacters();
      setState(() {
        _allCharacters = characters;
        _filteredCharacters = characters;
      });
      return characters;
    } catch (e) {
      // Handle error
      print('Error loading characters: $e');
      throw Exception('Failed to load characters');
    }
  }

  // Fungsi untuk filter list berdasarkan input search
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Parchment
      appBar: AppBar(
        title: const Text('Database Karakter'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: theme.colorScheme.onBackground),
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama atau spesies...',
                hintStyle: TextStyle(color: theme.colorScheme.secondary),
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.secondary),
                filled: true,
                fillColor: theme.colorScheme.surface, // Parchment Card
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
                      color: theme.colorScheme.primary,
                    ),
                  );
                }
                
                // Error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat data. Periksa koneksi internet.',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  );
                }
                
                // Data Kosong (setelah filter)
                if (_filteredCharacters.isEmpty) {
                  return Center(
                    child: Text(
                      'Karakter tidak ditemukan.',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  );
                }

                // Sukses: Tampilkan GridView
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.75, // Rasio gambar (lebar/tinggi)
                  ),
                  itemCount: _filteredCharacters.length,
                  itemBuilder: (context, index) {
                    final character = _filteredCharacters[index];
                    return CharacterCard(
                      character: character,
                      onTap: () {
                        // Navigasi ke Halaman Detail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailPage(character: character),
                          ),
                        );
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
// lib/pages/characters/titans_page.dart
import 'package:flutter/material.dart';
import '/config/theme.dart';
import '/models/titan_model.dart'; 
import '/services/api.dart'; 
import '/widgets/cards/titan_card.dart'; 

// --- 👇 TAMBAHKAN IMPORT UNTUK HALAMAN DETAIL BARU 👇 ---
import '/pages/characters/titan_detail_page.dart'; 
// --- 👆 BATAS TAMBAHAN 👆 ---

class TitansPage extends StatefulWidget {
  const TitansPage({Key? key}) : super(key: key);

  @override
  State<TitansPage> createState() => _TitansPageState();
}

class _TitansPageState extends State<TitansPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Titan>> _titansFuture;
  List<Titan> _allTitans = [];
  List<Titan> _filteredTitans = [];

  @override
  void initState() {
    super.initState();
    _titansFuture = _loadTitans();
    _searchController.addListener(_filterTitans);
  }

  Future<List<Titan>> _loadTitans() async {
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

  void _filterTitans() {
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Database Titan'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
                    return TitanCard(
                      titan: titan,
                      
                      // --- 👇 GANTI ONTAP DARI SNACKBAR KE NAVIGATOR 👇 ---
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TitanDetailPage(titan: titan),
                          ),
                        );
                      },
                      // --- 👆 BATAS PERUBAHAN 👆 ---
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
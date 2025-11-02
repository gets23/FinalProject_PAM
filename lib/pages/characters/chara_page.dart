// lib/pages/characters/chara_page.dart
// INI ADALAH INDUK PEMEGANG TAB
import 'package:flutter/material.dart';
import '/config/theme.dart';

// --- 👇 IMPORT HALAMAN FAVORIT & 2 TAB BARU 👇 ---
import '/pages/characters/fav_page.dart'; 
import '/pages/characters/chara_list_tab.dart'; // Tab 1
import '/pages/characters/titan_list_tab.dart'; // Tab 2
// --- 👆 BATAS TAMBAHAN 👆 ---

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

// Kita butuh SingleTickerProviderStateMixin untuk TabController
class _CharactersPageState extends State<CharactersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Buat controller untuk 2 tab
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, 
      appBar: AppBar(
        title: const Text('Karakter dan Titan'), // Ganti judul jadi lebih umum
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Favorit (tetap di sini)
          IconButton(
            icon: Icon(Icons.favorite),
            tooltip: 'Lihat Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
              // Kita tidak perlu refresh ID di sini lagi
            },
          ),
          
          // Tombol Titan (Perisai) KITA HAPUS DARI SINI
        ],
        // --- 👇 TAMBAHKAN TAB BAR DI BAWAH APPBAR 👇 ---
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // Warna teks tab aktif
          unselectedLabelColor: Colors.white.withOpacity(0.7), // Warna teks tab non-aktif
          indicatorColor: AppTheme.accentColor, // Warna garis bawah
          indicatorWeight: 3.0,
          tabs: const [
            Tab(
              icon: Icon(Icons.people),
              text: 'Karakter',
            ),
            Tab(
              icon: Icon(Icons.shield), // Ganti ikon Titan
              text: 'Titan',
            ),
          ],
        ),
        // --- 👆 BATAS TAMBAHAN 👆 ---
      ),
      // --- 👇 GANTI BODY DENGAN TABBARVIEW 👇 ---
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Konten Tab 1
          CharacterListTab(),
          
          // Konten Tab 2
          TitanListTab(),
        ],
      ),
      // --- 👆 BATAS PERUBAHAN 👆 ---
    );
  }
}
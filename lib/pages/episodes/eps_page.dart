// lib/pages/episodes/episodes_page.dart
import 'package:flutter/material.dart';
import '/services/api.dart'; // <-- Panggil API Service kamu
import '/models/eps_model.dart';      // <-- Panggil Model Episode kamu
import '/config/theme.dart';         // <-- Panggil Theme kamu

class EpisodesPage extends StatefulWidget {
  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  // Variabel untuk menyimpan state
  bool _isLoading = true;
  List<Episode> _episodes = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEpisodes();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> _fetchEpisodes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Panggil fungsi getEpisodes dari ApiService kamu
      // Ini akan mengambil halaman 1 (default)
      final List<Episode> fetchedEpisodes = await ApiService().getEpisodes();
      
      if (mounted) { // Pastikan widget masih ada di tree
        setState(() {
          _episodes = fetchedEpisodes;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Gagal memuat episode: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // Kita tidak perlu AppBar di sini karena sudah ada di home_page.dart
      body: _buildBody(),
    );
  }

  // Helper untuk build body berdasarkan state
  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.accentColor),
          ),
        ),
      );
    }

    if (_episodes.isEmpty) {
      return Center(
        child: Text(
          "Tidak ada episode ditemukan.",
          style: AppTheme.bodyMedium,
        ),
      );
    }

    // Jika berhasil, tampilkan ListView
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _episodes.length,
      itemBuilder: (context, index) {
        final episode = _episodes[index];
        return _EpisodeListItem(episode: episode);
      },
    );
  }
}

// WIDGET CARD UNTUK TIAP ITEM EPISODE (Biar Rapi)
class _EpisodeListItem extends StatelessWidget {
  final Episode episode;

  const _EpisodeListItem({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      color: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Episode
          SizedBox(
            width: 120, // Lebar gambar
            height: 100, // Tinggi card
            child: Image.network(
              episode.img,
              fit: BoxFit.cover,
              // Loading & Error builder (copy dari merch_page)
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Container(
                        color: AppTheme.backgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.secondaryColor,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppTheme.textColor,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Teks (Judul dan Nomor Episode)
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    episode.name, // Judul Episode
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      episode.episodeCode, // Nomor Episode (cth: "S1E1")
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
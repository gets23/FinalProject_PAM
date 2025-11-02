// lib/widgets/cards/chara_card.dart
import 'package:flutter/material.dart';
import '/models/chara_model.dart';
import '/config/theme.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    Key? key,
    required this.character,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 👇 BAGIAN INI KITA UBAH SEDIKIT 👇 ---
            Stack(
              children: [
                // Gambar Karakter
                Image.network(
                  character.pictureUrl ?? 'https://via.placeholder.com/150',
                  height: 180, // Tinggi gambar tetap
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // PERBAIKAN 1: BUNGKUS ICON DENGAN CENTER
                    return Container(
                      height: 180,
                      color: AppTheme.backgroundColor,
                      child: Center( // <-- TAMBAHKAN INI
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppTheme.textColor.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
                
                // Tombol Hati (Favorit)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppTheme.accentColor : Colors.white,
                      ),
                      iconSize: 20,
                      onPressed: onFavoriteToggle,
                      tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
                    ),
                  ),
                ),
              ],
            ),
            
            // --- 👇 BAGIAN INI KITA UBAH JUGA 👇 ---
            // PERBAIKAN 2: BUNGKUS DENGAN EXPANDED & CENTER
            // Ini membuat nama karakter mengisi sisa ruang di card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center( // <-- TAMBAHKAN INI
                  child: Text(
                    character.name,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            // --- 👆 BATAS PERBAIKAN 👆 ---
          ],
        ),
      ),
    );
  }
}
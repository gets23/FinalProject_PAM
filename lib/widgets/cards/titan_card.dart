// lib/widgets/cards/titan_card.dart
import 'package:flutter/material.dart';
import '/models/titan_model.dart';
import '/config/theme.dart';

class TitanCard extends StatelessWidget {
  final Titan titan;
  final VoidCallback onTap;

  // --- 👇 TAMBAHKAN PROPERTI BARU 👇 ---
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  // --- 👆 BATAS TAMBAHAN 👆 ---

  const TitanCard({
    Key? key,
    required this.titan,
    required this.onTap,
    // --- 👇 TAMBAHKAN PROPERTI BARU KE CONSTRUCTOR 👇 ---
    required this.isFavorite,
    required this.onFavoriteToggle,
    // --- 👆 BATAS TAMBAHAN 👆 ---
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
            // --- 👇 UBAH JADI STACK (COPY DARI CHARA_CARD) 👇 ---
            Stack(
              children: [
                // Gambar Titan
                Image.network(
                  titan.pictureUrl ?? 'https://via.placeholder.com/150',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: AppTheme.backgroundColor,
                      child: Center(
                        child: Icon(
                          Icons.warning_amber,
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
                      onPressed: onFavoriteToggle, // Panggil fungsi dari page
                      tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
                    ),
                  ),
                ),
              ],
            ),
            // --- 👆 BATAS STACK 👆 ---
            
            // Nama Titan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Text(
                    titan.name,
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
          ],
        ),
      ),
    );
  }
}
// lib/widgets/cards/titan_card.dart
import 'package:flutter/material.dart';
import '/models/titan_model.dart'; // Pastikan ini sudah ada dan benar
import '/config/theme.dart';

class TitanCard extends StatelessWidget {
  final Titan titan;
  final VoidCallback onTap;

  const TitanCard({
    Key? key,
    required this.titan,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.secondaryColor, // Warna kartu
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Titan
            Image.network(
              titan.pictureUrl ?? 'https://via.placeholder.com/150', // Gunakan pictureUrl dari TitanModel
              height: 180, // Sesuaikan tinggi gambar
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: AppTheme.backgroundColor,
                  child: Center(
                    child: Icon(
                      Icons.warning_amber, // Icon alternatif jika gambar error
                      size: 60,
                      color: AppTheme.textColor.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
            
            // Nama Titan
            Expanded( // Pastikan teks nama mengisi sisa ruang
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
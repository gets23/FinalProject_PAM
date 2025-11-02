// lib/widgets/cards/titan_card.dart
import 'package:flutter/material.dart';
import '/models/titan_model.dart';
import '/config/theme.dart';

class TitanCard extends StatelessWidget {
  final Titan titan;
  final VoidCallback onTap;

  // Hapus 'isFavorite' and 'onFavoriteToggle'
  const TitanCard({
    Key? key,
    required this.titan,
    required this.onTap,
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
            // Hapus Stack, kembali ke Image.network simpel
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
            
            // Nama Titan (sudah benar)
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
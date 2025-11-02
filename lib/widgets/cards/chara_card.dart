import '/models/chara_model.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({
    Key? key,
    required this.character,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Tentukan status color
    final statusColor = character.status == "Alive" 
        ? Colors.green[700] 
        : (character.status == "Deceased" ? theme.colorScheme.error : Colors.grey[600]);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        color: theme.colorScheme.surface, // Warna parchment card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: theme.colorScheme.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Karakter
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: character.pictureUrl != null
                    ? Image.network(
                        character.pictureUrl!,
                        fit: BoxFit.cover,
                        // Loading indicator untuk gambar
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: theme.colorScheme.onPrimary,
                            ),
                          );
                        },
                        // Error handling jika gambar gagal load
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.person, size: 50, color: theme.colorScheme.secondary),
                      )
                    : Icon(Icons.person, size: 50, color: theme.colorScheme.secondary),
              ),
            ),
            
            // Info Teks
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Status (Alive/Deceased)
                  Text(
                    character.status ?? 'Unknown',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import '/models/chara_model.dart';
import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Parchment
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Gambar
            if (character.pictureUrl != null)
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  character.pictureUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.person, size: 150, color: theme.colorScheme.secondary)),
                ),
              ),
            
            // Info Utama
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (character.alias != null && character.alias!.isNotEmpty)
                    Text(
                      'Alias: ${character.alias!.join(", ")}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Info Detail dengan Kartu
                  _buildInfoCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk info di dalam kartu
  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow(context, 'Status:', character.status ?? 'Unknown'),
            _buildInfoRow(context, 'Gender:', character.gender ?? 'Unknown'),
            _buildInfoRow(context, 'Spesies:', character.species?.join(", ") ?? 'Unknown'),
            if (character.age != null)
              _buildInfoRow(context, 'Umur:', character.age.toString()),
            if (character.height != null)
              _buildInfoRow(context, 'Tinggi:', character.height.toString()),
            if (character.occupation != null)
              _buildInfoRow(context, 'Pekerjaan:', character.occupation!),
            if (character.groups != null && character.groups!.isNotEmpty)
              _buildInfoRow(context, 'Grup:', character.groups!.map((g) => g['name']).join(", ")),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk baris info (Label: Value)
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
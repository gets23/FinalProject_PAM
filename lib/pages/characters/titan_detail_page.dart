// lib/pages/characters/titan_detail_page.dart
import '/models/titan_model.dart'; // <-- Ganti ke model Titan
import 'package:flutter/material.dart';
// (Kita akan pakai AppTheme agar konsisten, tapi kita ikuti template-mu)

class TitanDetailPage extends StatelessWidget {
  final Titan titan; // <-- Ganti ke model Titan

  const TitanDetailPage({Key? key, required this.titan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Parchment
      appBar: AppBar(
        title: Text(titan.name), // <-- Ganti ke data Titan
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Gambar
            if (titan.pictureUrl != null) // <-- Ganti ke data Titan
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  titan.pictureUrl!, // <-- Ganti ke data Titan
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(
                        child: Icon(
                          Icons.warning_amber, // Ganti ikon error
                          size: 150, 
                          color: theme.colorScheme.secondary
                        )
                      ),
                ),
              ),
            
            // Info Utama
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titan.name, // <-- Ganti ke data Titan
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // (Model Titan tidak punya 'alias', jadi kita hapus)
                  const SizedBox(height: 16),
                  
                  // Info Detail (Kita panggil _buildInfoCard yang sudah dimodif)
                  _buildInfoCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 👇 WIDGET INI DIMODIFIKASI UNTUK TITAN 👇 ---
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
            // Model Titan hanya punya 'height' dan 'description'
            
            if (titan.height != null)
              _buildInfoRow(context, 'Tinggi:', titan.height!),
            
            if (titan.description != null)
              _buildInfoRow(context, 'Deskripsi:', titan.description!),

            // (Hapus sisanya: status, gender, spesies, dll.)
          ],
        ),
      ),
    );
  }
  // --- 👆 BATAS PERUBAHAN 👆 ---

  // Widget helper untuk baris info (Label: Value)
  // (Ini tidak perlu diubah, sudah bagus)
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
// lib/pages/home/dashboard_page.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '/services/auth.dart';
import '/models/merch_model.dart';
import '/pages/store/merch_page.dart';
import 'package:intl/intl.dart';

class _Article {
  final String title;
  final String subtitle;
  final String imagePath;

  _Article({required this.title, required this.subtitle, required this.imagePath});
}

final List<_Article> dummyArticles = [
  _Article(
    title: 'Final Season Part 3 Announcement',
    subtitle: 'The epic conclusion is coming. Get all the details on the final...',
    // Ganti URL mati dengan placeholder
    imagePath: 'assets/s3.jpeg', 
  ),
  _Article(
    title: 'Community Fan Art Spotlight',
    subtitle: 'This week, we\'re featuring incredible talented artists...',
    // Ganti URL mati dengan placeholder
    imagePath: 'assets/fanart.jpeg',
  ),
];
// --- 👆 BATAS PERUBAHAN 👆 ---

class DashboardPage extends StatelessWidget {
  final Function(int)? onTabSelected;
  const DashboardPage({Key? key, this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil data user
    final AuthService _authService = AuthService();
    final user = _authService.currentUser;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- WELCOME TEXT (Sudah benar) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user?.username ?? 'Scout'}!',
                  style: AppTheme.headingLarge.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here is your daily briefing from the Walls.',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
          
          // --- HERO BANNER (Kita perbaiki) ---
          _buildHeroBanner(context, onTabSelected),

          // --- SURVEY CORPS SUPPLIES (Sudah aman) ---
          _buildSuppliesSection(context),
          
          // --- DISPATCHES FROM THE WALLS (Kita perbaiki) ---
          _buildDispatchesSection(context),

          // --- FOOTER (Sudah aman) ---
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Shinzou wo Sasageyo!',
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, Function(int)? onTabSelected) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Ganti URL mati dengan placeholder
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/600x400/5B3A29/FFFFFF?text=AOT+Banner'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          // Gradient gelap di bawah
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ),
            ),
          ),
          // Teks dan Tombol
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row( // <-- Ini sumber overflow
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // FIX: Bungkus Column dengan Expanded
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Latest Episode is Here',
                        style: AppTheme.headingMedium.copyWith(color: Colors.white),
                        maxLines: 1, // Pastikan tidak wrap
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S4, E28: The Final Titan',
                        style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8), // Beri jarak
                ElevatedButton(
                  onPressed: () {
                    if (onTabSelected != null) onTabSelected!(3); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Watch Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDER UNTUK SUPPLIES (MERCH) ---
  Widget _buildSuppliesSection(BuildContext context) {
    final merchList = MerchModel.getAllMerch(); 
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(
            'Survey Corps Supplies',
            style: AppTheme.headingMedium.copyWith(color: AppTheme.primaryColor),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: merchList.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final merch = merchList[index];
              return _MerchCard(
                merch: merch,
                format: currencyFormat,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MerchPage()),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // --- WIDGET BUILDER UNTUK DISPATCHES (NEWS) ---
  Widget _buildDispatchesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(
            'Dispatches from the Walls',
            style: AppTheme.headingMedium.copyWith(color: AppTheme.primaryColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            // Kita akan passing dummyArticles yang URL-nya sudah benar
            children: dummyArticles.map((article) {
              return _NewsCard(article: article);
            }).toList(),
          ),
        ),
      ],
    );
  }
}


// ===================================================
// WIDGET CARD BARU UNTUK MERCHANDISE (Sudah Aman)
// ===================================================
class _MerchCard extends StatelessWidget {
  final MerchModel merch;
  final NumberFormat format;
  final VoidCallback onTap;

  const _MerchCard({
    required this.merch,
    required this.format,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        color: AppTheme.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                merch.imagePath, // Ini pakai URL placeholder dari merch_model
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merch.name,
                      style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      format.format(merch.priceJpy / 150),
                      style: AppTheme.bodySmall.copyWith(color: AppTheme.textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================
// WIDGET CARD BARU UNTUK NEWS/ARTIKEL (Kita Perbaiki)
// ===================================================
class _NewsCard extends StatelessWidget {
  final _Article article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.imagePath, // Ini pakai URL placeholder baru
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  // --- 👇 3. TAMBAHKAN ERROR BUILDER 👇 ---
                  // Ini untuk jaga-jaga jika URL-nya mati lagi
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  ),
                  // --- 👆 BATAS TAMBAHAN 👆 ---
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.subtitle,
                      style: AppTheme.bodySmall.copyWith(color: AppTheme.textColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
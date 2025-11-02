// lib/models/merch_model.dart

class MerchModel {
  final String name;
  final String description;
  final String imagePath;
  final double priceJpy;    
  final DateTime releaseDateUtc; 

  MerchModel({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.priceJpy,
    required this.releaseDateUtc,
  });

  // Ini adalah data dummy kita
  static List<MerchModel> getAllMerch() {
    return [
      MerchModel(
        name: "Survey Corps Jacket",
        description: "Official replica of the Survey Corps uniform jacket.",
        imagePath: "assets/merch_jacket.jpeg", 
        priceJpy: 8500, // Misal harganya 8500 Yen
        
        // Kita set tanggal rilisnya (misal Waktu Jepang/JST = UTC+9)
        // Contoh: Rilis 15 Nov 2025, 10:00 JST
        // itu sama dengan 15 Nov 2025, 01:00 UTC
        releaseDateUtc: DateTime.utc(2025, 11, 15, 1, 0, 0), 
      ),
      MerchModel(
        name: "Eren Yeager Figure (Titan)",
        description: "1/8 scale figure of Eren in his Attack Titan form.",
        imagePath: "assets/merch_figure.jpeg",
        priceJpy: 15000, // Misal 15000 Yen
        
        // Contoh: Rilis 1 Des 2025, 10:00 JST
        // itu sama dengan 1 Des 2025, 01:00 UTC
        releaseDateUtc: DateTime.utc(2025, 12, 1, 1, 0, 0),
      ),
      MerchModel(
        name: "ODM Gear Keychain",
        description: "Detailed metal keychain of the 3D Maneuver Gear.",
        imagePath: "assets/merch_keychain.jpeg",
        priceJpy: 2000, // Misal 2000 Yen
        
        // Contoh: Rilis 10 Nov 2025, 12:00 JST (siang)
        // itu sama dengan 10 Nov 2025, 03:00 UTC
        releaseDateUtc: DateTime.utc(2025, 11, 10, 3, 0, 0),
      ),
    ];
  }
}
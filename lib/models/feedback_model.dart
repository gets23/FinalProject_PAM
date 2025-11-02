// lib/models/feedback_model.dart

class FeedbackModel {
  final int? id;
  final int userId;
  final int rating;
  final String kesan;
  final String saran;
  final String createdAt;

  FeedbackModel({
    this.id,
    required this.userId,
    required this.rating,
    required this.kesan,
    required this.saran,
    required this.createdAt,
  });

  // Mengubah objek FeedbackModel menjadi Map (untuk insert ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_Id': userId,
      'rating': rating,
      'kesan': kesan,
      'saran': saran,
      'created_at': createdAt,
    };
  }

  // (Kita belum butuh fromMap, tapi ini bagus untuk nanti)
  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      userId: map['user_id'] ?? 0,
      rating: map['rating'] ?? 0,
      kesan: map['kesan'] ?? 'Data korup',
      saran: map['saran'] ?? 'Data korup',
      createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }
}
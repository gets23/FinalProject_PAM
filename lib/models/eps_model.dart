// Nama file: eps_model.dart
// Nama class: Episode

class Episode {
  final int id;
  final String name;
  final String episodeCode; // "Season 1, Episode 1"
  final String season;
  final String img;

  Episode({
    required this.id,
    required this.name,
    required this.episodeCode,
    required this.season,
    required this.img,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Episode',
      episodeCode: json['episode'] ?? 'S? E?', // 'episode' di JSON
      season: json['season'] ?? '',
      img: json['img'] ?? '',
    );
  }
}
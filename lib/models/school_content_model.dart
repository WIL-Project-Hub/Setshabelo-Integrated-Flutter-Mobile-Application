class SchoolUpdate {
  final String updateId;
  final String title;
  final String content;
  final DateTime publishedAt;

  SchoolUpdate({
    required this.updateId,
    required this.title,
    required this.content,
    required this.publishedAt,
  });

  factory SchoolUpdate.fromJson(Map<String, dynamic> json) {
    return SchoolUpdate(
      updateId: json['update_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      publishedAt: DateTime.parse(
        json['published_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Achievement {
  final String achievementId;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime publishedAt;

  Achievement({
    required this.achievementId,
    required this.title,
    this.description,
    this.imageUrl,
    required this.publishedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementId: json['achievement_id'],
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      publishedAt: DateTime.parse(
        json['published_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

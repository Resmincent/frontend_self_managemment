class JournalModel {
  final int id;
  final int userId;
  final String category;
  final String title;
  final String content;
  final DateTime createdAt;

  JournalModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category': category,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String()
    };
  }

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      category: json['category'] ?? 0,
      title: json['title'] ?? 0,
      content: json['content'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'category': category.toString(),
      'title': title.toString(),
      'content': content.toString(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SafePlaceModel {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String content;
  final String filePath;
  final DateTime createdAt;

  SafePlaceModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    required this.filePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'content': content,
      'file_path': filePath,
      'created_at': createdAt.toIso8601String()
    };
  }

  factory SafePlaceModel.fromJson(Map<String, dynamic> json) {
    return SafePlaceModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? 0,
      title: json['title'] ?? 0,
      content: json['content'] ?? 0,
      filePath: json['file_path'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'type': type.toString(),
      'title': title.toString(),
      'content': content.toString(),
      'file_path': filePath.toString(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

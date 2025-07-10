class MoodModel {
  final int? id;
  final int? userId;
  final int level;
  final DateTime createdAt;

  MoodModel({
    this.id,
    this.userId,
    required this.level,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'level': level,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      level: int.tryParse(json['level'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id?.toString() ?? '',
      'user_id': userId?.toString() ?? '',
      'level': level.toString(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

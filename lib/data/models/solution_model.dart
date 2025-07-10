class SolutionModel {
  final int id;
  final int userId;
  final String summary;
  final String problem;
  final List<String> reference;
  final String solution;
  final DateTime createdAt;

  SolutionModel({
    required this.id,
    required this.userId,
    required this.summary,
    required this.problem,
    required this.reference,
    required this.solution,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'summary': summary,
      'problem': problem,
      'reference': reference.join(', '),
      'solution': solution,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SolutionModel.fromJson(Map<String, dynamic> json) {
    return SolutionModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      summary: json['summary']?.toString() ?? '',
      problem: json['problem']?.toString() ?? '',
      reference: _parseReference(json['reference']),
      solution: json['solution']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  static List<String> _parseReference(dynamic input) {
    if (input == null) return [];
    if (input is List) {
      return input.map((e) => e.toString()).toList();
    }
    if (input is String) {
      return input.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'summary': summary,
      'problem': problem,
      'reference': reference.join(', '),
      'solution': solution,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

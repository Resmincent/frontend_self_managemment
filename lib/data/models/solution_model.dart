class SolutionModel {
  final int id;
  final int userId;
  final String summary;
  final String problem;
  final List<String> reference;
  final String solution;
  final DateTime createdAt;

  SolutionModel(
      {required this.id,
      required this.userId,
      required this.summary,
      required this.problem,
      required this.reference,
      required this.solution,
      required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'summary': summary,
      'solution': solution,
      'problem': problem,
      'reference': reference.join(', '),
      'created_at': createdAt.toIso8601String()
    };
  }

  factory SolutionModel.fromJson(Map<String, dynamic> json) {
    return SolutionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      summary: json['summary'] ?? '',
      problem: json['problem'] ?? '',
      reference: json['reference'] != null
          ? List<String>.from((json['reference'] as String).split(', '))
          : [],
      solution: json['solution'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'summary': summary.toString(),
      'solution': solution,
      'problem': problem,
      'reference': reference.join(', '),
      'created_at': createdAt.toIso8601String()
    };
  }
}

class IncomeModel {
  final int id;
  final int? userId;
  final String title;
  final String category;
  final double amount;
  final DateTime dateIncome;
  final String? description;

  IncomeModel({
    required this.id,
    this.userId,
    required this.title,
    required this.category,
    required this.amount,
    required this.dateIncome,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'category': category,
      'amount': amount,
      'date_income': dateIncome.toIso8601String(),
      'description': description,
    };
  }

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      dateIncome:
          DateTime.tryParse(json['date_income'] ?? '') ?? DateTime(2000),
      description: json['description'],
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId?.toString() ?? '',
      'title': title,
      'category': category,
      'amount': amount.toString(),
      'date_income': dateIncome.toIso8601String(),
      'description': description ?? '',
    };
  }
}

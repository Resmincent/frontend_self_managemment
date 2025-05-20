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
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      title: json['title'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      dateIncome: DateTime.parse(json['dateIncome']),
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'title': title,
      'category': category,
      'amount': amount.toString(),
      'date_income': dateIncome.toIso8601String(),
      'description': description.toString(),
    };
  }
}

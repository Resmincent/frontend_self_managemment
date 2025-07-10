class ExpenseModal {
  final int id;
  final int? userId;
  final String title;
  final String category;
  final double expense;
  final DateTime dateExpense;
  final String? description;

  ExpenseModal({
    required this.id,
    this.userId,
    required this.title,
    required this.category,
    required this.expense,
    required this.dateExpense,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'category': category,
      'expense': expense,
      'date_expense': dateExpense.toIso8601String(),
      'description': description,
    };
  }

  factory ExpenseModal.fromJson(Map<String, dynamic> json) {
    return ExpenseModal(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      expense: double.tryParse(json['expense'].toString()) ?? 0.0,
      dateExpense:
          DateTime.tryParse(json['date_expense'] ?? '') ?? DateTime(2000),
      description: json['description'],
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId?.toString() ?? '',
      'title': title,
      'category': category,
      'expense': expense.toString(),
      'date_expense': dateExpense.toIso8601String(),
      'description': description ?? '',
    };
  }
}

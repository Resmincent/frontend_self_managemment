class ExpenseModal {
  final int id;
  final int? userId;
  final String title;
  final String category;
  final double expense;
  final DateTime dateExpense;
  final String? description;

  ExpenseModal(
      {required this.id,
      this.userId,
      required this.title,
      required this.category,
      required this.expense,
      required this.dateExpense,
      this.description});

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
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      title: json['title'],
      category: json['category'],
      expense: json['expense'],
      dateExpense: DateTime.parse(json['date_expense']),
    );
  }

  Map<String, String> toJsonRequest() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'title': title,
      'category': category,
      'expense': expense.toString(),
      'date_expense': dateExpense.toIso8601String(),
      'description': description.toString(),
    };
  }
}

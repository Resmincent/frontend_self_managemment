import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/expense_remote_data_source.dart';
import 'package:self_management/data/models/expense_modal.dart';

class AllExpenseController extends GetxController {
  final _state = AllExpenseState(
    statusRequest: StatusRequest.init,
    message: '',
    expenses: [],
  ).obs;

  AllExpenseState get state => _state.value;

  set state(AllExpenseState value) => _state.value = value;

  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;

  List<ExpenseModal> get filteredExpenses {
    return state.expenses
        .where((e) =>
            e.dateExpense.month == selectedMonth.value &&
            e.dateExpense.year == selectedYear.value)
        .toList();
  }

  double get totalThisMonthExpense {
    final list = filteredExpenses;
    double total = 0;
    for (var expense in list) {
      total += expense.expense;
    }
    return total;
  }

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, expenses) =
        await ExpenseRemoteDataSource.all(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      expenses: expenses ?? [],
    );

    return state;
  }

  static delete() => Get.delete<AllExpenseController>(force: true);
}

class AllExpenseState {
  final StatusRequest statusRequest;
  final String message;
  final List<ExpenseModal> expenses;

  AllExpenseState({
    required this.statusRequest,
    required this.message,
    required this.expenses,
  });

  AllExpenseState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<ExpenseModal>? expenses,
  }) {
    return AllExpenseState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      expenses: expenses ?? this.expenses,
    );
  }
}

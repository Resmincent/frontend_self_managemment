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

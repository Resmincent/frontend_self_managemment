import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/expense_remote_data_source.dart';
import 'package:self_management/data/models/expense_modal.dart';

class ExpenseTodayController extends GetxController {
  final _state = ExpenseTodayState(
    statusRequest: StatusRequest.init,
    message: '',
    expenses: [],
  ).obs;

  ExpenseTodayState get state => _state.value;

  set state(ExpenseTodayState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, expenses) =
        await ExpenseRemoteDataSource.today(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      expenses: expenses ?? [],
    );

    return state;
  }

  static delete() => Get.delete<ExpenseTodayController>(force: true);
}

class ExpenseTodayState {
  final StatusRequest statusRequest;
  final String message;
  final List<ExpenseModal> expenses;

  ExpenseTodayState({
    required this.statusRequest,
    required this.message,
    required this.expenses,
  });

  ExpenseTodayState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<ExpenseModal>? expenses,
  }) {
    return ExpenseTodayState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      expenses: expenses ?? this.expenses,
    );
  }
}

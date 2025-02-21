import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/models/expense_modal.dart';

import '../../../data/datasources/expense_remote_data_source.dart';

class AddExpenseController extends GetxController {
  final _state = AddExpenseState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  AddExpenseState get state => _state.value;

  set state(AddExpenseState value) => _state.value = value;

  Future<AddExpenseState> executeRequest(ExpenseModal expense) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await ExpenseRemoteDataSource.add(expense);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<AddExpenseController>(force: true);
}

class AddExpenseState {
  final StatusRequest statusRequest;
  final String message;

  AddExpenseState({
    required this.statusRequest,
    required this.message,
  });

  AddExpenseState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return AddExpenseState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

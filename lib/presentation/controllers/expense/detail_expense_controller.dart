import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/expense_remote_data_source.dart';
import 'package:self_management/data/models/expense_modal.dart';

class DetailExpenseController extends GetxController {
  final _state = DetailExpenseState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailExpenseState get state => _state.value;

  set state(DetailExpenseState value) => _state.value = value;

  Future<DetailExpenseState> fetch(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message, expense) =
        await ExpenseRemoteDataSource.detail(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      expense: expense,
    );

    return state;
  }

  static delete() => Get.delete<DetailExpenseController>(force: true);
}

class DetailExpenseState {
  final StatusRequest statusRequest;
  final String message;
  final ExpenseModal? expense;

  DetailExpenseState(
      {required this.statusRequest, required this.message, this.expense});

  DetailExpenseState copyWith({
    StatusRequest? statusRequest,
    String? message,
    ExpenseModal? expense,
  }) {
    return DetailExpenseState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      expense: expense ?? this.expense,
    );
  }
}

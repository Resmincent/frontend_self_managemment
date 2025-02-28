import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/expense_remote_data_source.dart';

class DeleteExpenseController extends GetxController {
  final _state = DeleteExpenseState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DeleteExpenseState get state => _state.value;

  set state(DeleteExpenseState value) => _state.value = value;

  Future<DeleteExpenseState> executeRequest(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await ExpenseRemoteDataSource.delete(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<DeleteExpenseController>(force: true);
}

class DeleteExpenseState {
  final StatusRequest statusRequest;
  final String message;

  DeleteExpenseState({
    required this.statusRequest,
    required this.message,
  });

  DeleteExpenseState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DeleteExpenseState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

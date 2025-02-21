import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/expense_remote_data_source.dart';

class DetailEcpenseController extends GetxController {
  final _state = DetailExpenseState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailExpenseState get state => _state.value;

  set state(DetailExpenseState value) => _state.value = value;

  Future<DetailExpenseState> executeRequest(int id) async {
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

  static delete() => Get.delete<DetailEcpenseController>(force: true);
}

class DetailExpenseState {
  final StatusRequest statusRequest;
  final String message;

  DetailExpenseState({
    required this.statusRequest,
    required this.message,
  });

  DetailExpenseState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DetailExpenseState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

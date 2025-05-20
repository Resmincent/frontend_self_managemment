import 'package:get/get.dart';
import 'package:self_management/data/datasources/income_remote_date_source.dart';

import '../../../common/enums.dart';

class DeleteIncomeController extends GetxController {
  final _state = DeleteIncomeState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DeleteIncomeState get state => _state.value;

  set state(DeleteIncomeState value) => _state.value = value;

  Future<DeleteIncomeState> executeRequest(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await IncomeRemoteDateSource.delete(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<DeleteIncomeController>(force: true);
}

class DeleteIncomeState {
  final StatusRequest statusRequest;
  final String message;

  DeleteIncomeState({
    required this.statusRequest,
    required this.message,
  });

  DeleteIncomeState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DeleteIncomeState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

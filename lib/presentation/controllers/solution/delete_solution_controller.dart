import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/solution_remote_data_source.dart';

class DeleteSolutionController extends GetxController {
  final _state = DeleteSolutionState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DeleteSolutionState get state => _state.value;

  set state(DeleteSolutionState value) => _state.value = value;

  Future<DeleteSolutionState> executeRequest(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await SolutionRemoteDataSource.delete(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<DeleteSolutionController>(force: true);
}

class DeleteSolutionState {
  final StatusRequest statusRequest;
  final String message;

  DeleteSolutionState({
    required this.statusRequest,
    required this.message,
  });

  DeleteSolutionState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DeleteSolutionState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

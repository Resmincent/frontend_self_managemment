import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/solution_remote_data_source.dart';
import 'package:self_management/data/models/solution_model.dart';

class UpdateSolutionController extends GetxController {
  final _state = UpdateSolutionState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  UpdateSolutionState get state => _state.value;

  set state(UpdateSolutionState value) => _state.value = value;

  Future<UpdateSolutionState> executeRequest(SolutionModel solution) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await SolutionRemoteDataSource.update(solution);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<UpdateSolutionController>(force: true);
}

class UpdateSolutionState {
  final StatusRequest statusRequest;
  final String message;

  UpdateSolutionState({
    required this.statusRequest,
    required this.message,
  });

  UpdateSolutionState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return UpdateSolutionState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

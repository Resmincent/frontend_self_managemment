import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/solution_remote_data_source.dart';
import 'package:self_management/data/models/solution_model.dart';

class AddSolutionController extends GetxController {
  final _state = AddSolutionState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  AddSolutionState get state => _state.value;

  set state(AddSolutionState value) => _state.value = value;

  Future<AddSolutionState> executeRequest(SolutionModel solution) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await SolutionRemoteDataSource.add(solution);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<AddSolutionController>(force: true);
}

class AddSolutionState {
  final StatusRequest statusRequest;
  final String message;

  AddSolutionState({
    required this.statusRequest,
    required this.message,
  });

  AddSolutionState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return AddSolutionState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

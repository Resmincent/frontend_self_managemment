import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/solution_remote_data_source.dart';
import 'package:self_management/data/models/solution_model.dart';

class SolutionController extends GetxController {
  final _state = SolutionState(
    statusRequest: StatusRequest.init,
    message: '',
    solutions: [],
  ).obs;

  SolutionState get state => _state.value;

  set state(SolutionState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, solutions) =
        await SolutionRemoteDataSource.all(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      solutions: solutions ?? [],
    );

    return state;
  }

  Future search(int userId, String query) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, solutions) =
        await SolutionRemoteDataSource.search(userId, query);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      solutions: solutions ?? [],
    );

    return state;
  }

  static delete() => Get.delete<SolutionController>(force: true);
}

class SolutionState {
  final StatusRequest statusRequest;
  final String message;
  final List<SolutionModel> solutions;

  SolutionState({
    required this.statusRequest,
    required this.message,
    required this.solutions,
  });

  SolutionState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<SolutionModel>? solutions,
  }) {
    return SolutionState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      solutions: solutions ?? this.solutions,
    );
  }
}

import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/solution_remote_data_source.dart';
import 'package:self_management/data/models/solution_model.dart';

class DetailSolutionController extends GetxController {
  final _state = DetailSolutionState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailSolutionState get state => _state.value;

  set state(DetailSolutionState value) => _state.value = value;

  Future<DetailSolutionState> fetch(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message, solution) =
        await SolutionRemoteDataSource.detail(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      solution: solution,
    );

    return state;
  }

  static delete() => Get.delete<DetailSolutionController>(force: true);
}

class DetailSolutionState {
  final StatusRequest statusRequest;
  final String message;
  final SolutionModel? solution;

  DetailSolutionState(
      {required this.statusRequest, required this.message, this.solution});

  DetailSolutionState copyWith({
    StatusRequest? statusRequest,
    String? message,
    SolutionModel? solution,
  }) {
    return DetailSolutionState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      solution: solution ?? this.solution,
    );
  }
}

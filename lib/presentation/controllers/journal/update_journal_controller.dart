import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/journal_remote_data_source.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:self_management/presentation/controllers/solution/update_solution_controller.dart';

class UpdateJournalController extends GetxController {
  final _state = UpdateJournalState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  UpdateJournalState get state => _state.value;

  set state(UpdateJournalState value) => _state.value = value;

  Future<UpdateJournalState> executeRequest(JournalModel journal) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );
    final (success, message) = await JournalRemoteDataSource.update(journal);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );
    return state;
  }

  static delete() => Get.delete<UpdateSolutionController>(force: true);
}

class UpdateJournalState {
  final StatusRequest statusRequest;
  final String message;

  UpdateJournalState({
    required this.statusRequest,
    required this.message,
  });

  UpdateJournalState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return UpdateJournalState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

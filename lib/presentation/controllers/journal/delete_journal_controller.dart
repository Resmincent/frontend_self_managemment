import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/journal_remote_data_source.dart';

class DeleteJournalController extends GetxController {
  final _state = DeleteJournalState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DeleteJournalState get state => _state.value;

  set state(DeleteJournalState value) => _state.value = value;

  Future<DeleteJournalState> executeRequest(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await JournalRemoteDataSource.delete(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<DeleteJournalController>(force: true);
}

class DeleteJournalState {
  final StatusRequest statusRequest;
  final String message;

  DeleteJournalState({
    required this.statusRequest,
    required this.message,
  });

  DeleteJournalState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DeleteJournalState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

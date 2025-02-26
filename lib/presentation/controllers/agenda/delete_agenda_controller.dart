import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';

class DeleteAgendaController extends GetxController {
  final _state = DeleteAgendaState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DeleteAgendaState get state => _state.value;

  set state(DeleteAgendaState value) => _state.value = value;

  Future<DeleteAgendaState> executeRequest(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await AgendaRemoteDataSource.delete(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<DeleteAgendaController>(force: true);
}

class DeleteAgendaState {
  final StatusRequest statusRequest;
  final String message;

  DeleteAgendaState({
    required this.statusRequest,
    required this.message,
  });

  DeleteAgendaState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DeleteAgendaState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

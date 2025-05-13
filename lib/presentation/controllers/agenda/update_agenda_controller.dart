import 'package:get/get.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';
import 'package:self_management/data/models/agenda_model.dart';

import '../../../common/enums.dart';

class UpdateAgendaController extends GetxController {
  final _state = UpdateAgendaState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  UpdateAgendaState get state => _state.value;

  set state(UpdateAgendaState value) => _state.value = value;

  Future<UpdateAgendaState> executeRequest(AgendaModel agenda) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await AgendaRemoteDataSource.update(agenda);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );
    return state;
  }

  static delete() => Get.delete<UpdateAgendaController>(force: true);
}

class UpdateAgendaState {
  final StatusRequest statusRequest;
  final String message;

  UpdateAgendaState({
    required this.statusRequest,
    required this.message,
  });

  UpdateAgendaState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return UpdateAgendaState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

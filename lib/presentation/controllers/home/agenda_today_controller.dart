import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';
import 'package:self_management/data/models/agenda_model.dart';

class AgendaTodayController extends GetxController {
  final _state = AgendaTodayState(
    statusRequest: StatusRequest.init,
    message: '',
    agendas: [],
  ).obs;

  AgendaTodayState get state => _state.value;

  set state(AgendaTodayState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, agendas) =
        await AgendaRemoteDataSource.today(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      agendas: agendas ?? [],
    );

    return state;
  }

  static delete() => Get.delete<AgendaTodayController>(force: true);
}

class AgendaTodayState {
  final StatusRequest statusRequest;
  final String message;
  final List<AgendaModel> agendas;

  AgendaTodayState({
    required this.statusRequest,
    required this.message,
    required this.agendas,
  });

  AgendaTodayState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<AgendaModel>? agendas,
  }) {
    return AgendaTodayState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      agendas: agendas ?? this.agendas,
    );
  }
}

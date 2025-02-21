import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';

class DetailAgendaController extends GetxController {
  final _state = DetailAgendaState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailAgendaState get state => _state.value;

  set state(DetailAgendaState value) => _state.value = value;

  Future<DetailAgendaState> executeRequest(int id) async {
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

  static delete() => Get.delete<DetailAgendaController>(force: true);
}

class DetailAgendaState {
  final StatusRequest statusRequest;
  final String message;

  DetailAgendaState({
    required this.statusRequest,
    required this.message,
  });

  DetailAgendaState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DetailAgendaState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

import 'package:d_chart/d_chart.dart';
import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';

class AnalyticAgendaLastMonthController extends GetxController {
  final _state = AnalyticAgendaLastMonthState(
    statusRequest: StatusRequest.init,
    message: '',
    agendas: [],
  ).obs;

  AnalyticAgendaLastMonthState get state => _state.value;

  set state(AnalyticAgendaLastMonthState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, dataRaw) =
        await AgendaRemoteDataSource.analytic(userId);

    if (!success) {
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: message,
      );

      return;
    }

    List<TimeData> agendas = List.from(dataRaw!).map((e) {
      return TimeData(
        domain: DateTime.parse(e['date']),
        measure: e['total'],
      );
    }).toList();

    state = state.copyWith(
        statusRequest: StatusRequest.success,
        agendas: agendas,
        message: message);

    return state;
  }

  static delete() => Get.delete<AnalyticAgendaLastMonthController>(force: true);
}

class AnalyticAgendaLastMonthState {
  final StatusRequest statusRequest;
  final String message;
  final List<TimeData> agendas;

  AnalyticAgendaLastMonthState({
    required this.statusRequest,
    required this.message,
    required this.agendas,
  });

  AnalyticAgendaLastMonthState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<TimeData>? agendas,
  }) {
    return AnalyticAgendaLastMonthState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      agendas: agendas ?? this.agendas,
    );
  }
}

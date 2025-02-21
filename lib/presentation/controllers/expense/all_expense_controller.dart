import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';

class AllController extends GetxController {
  final _state = AllAgendaState(
    statusRequest: StatusRequest.init,
    message: '',
    list: [],
  ).obs;

  AllAgendaState get state => _state.value;

  set state(AllAgendaState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, data) = await AgendaRemoteDataSource.all(userId);

    if (!success) {
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: message,
      );

      return;
    }

    List<CalendarEventData> list = data!.map((value) {
      return CalendarEventData(
        title: value.title,
        date: value.startEvent,
        endDate: value.endEvent,
        startTime: value.startEvent,
        endTime: value.endEvent,
        event: value,
      );
    }).toList();

    state = state.copyWith(
        statusRequest: StatusRequest.success, list: list, message: message);

    return state;
  }

  static delete() => Get.delete<AllController>(force: true);
}

class AllAgendaState {
  final StatusRequest statusRequest;
  final String message;
  final List<CalendarEventData> list;

  AllAgendaState({
    required this.statusRequest,
    required this.message,
    required this.list,
  });

  AllAgendaState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<CalendarEventData>? list,
  }) {
    return AllAgendaState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}

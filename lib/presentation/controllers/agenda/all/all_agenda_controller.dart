import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/core/notification_helper.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';

class AllAgendaController extends GetxController {
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

    void notifyAgenda(int id, String title, DateTime startEvent) {
      final notificationTime = startEvent.subtract(const Duration(minutes: 60));
      if (notificationTime.isAfter(DateTime.now())) {
        NotificationHelper.showNotification(
          id: id,
          title: "Upcoming Agenda",
          body: "Agenda: $title akan dimulai 1 jam lagi.",
          scheduledTime: notificationTime,
        );
      }
    }

    List<CalendarEventData> list = data!.map((value) {
      notifyAgenda(value.id, value.title, value.startEvent);
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
      statusRequest: StatusRequest.success,
      list: list,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<AllAgendaController>(force: true);
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

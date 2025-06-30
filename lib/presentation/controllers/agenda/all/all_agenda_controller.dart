import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/core/notification_helper.dart';
import 'package:self_management/data/datasources/agenda_remote_data_source.dart';

import '../../../../data/models/agenda_model.dart';

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

    final agendas = data!;
    scheduleAllAgendaReminders(agendas);

    List<CalendarEventData> list = agendas.map((agenda) {
      return CalendarEventData(
        title: agenda.title,
        date: agenda.startEvent,
        startTime: agenda.startEvent,
        endTime: agenda.endEvent,
        endDate: agenda.endEvent,
        event: agenda,
      );
    }).toList();

    state = state.copyWith(
      statusRequest: StatusRequest.success,
      list: list,
      message: message,
    );
  }

  void scheduleAllAgendaReminders(List<AgendaModel> agendas) {
    final now = DateTime.now();
    const reminderBuffer = Duration(minutes: 1);

    for (var agenda in agendas) {
      final start = agenda.startEvent;
      final notifTime = start.subtract(const Duration(hours: 1));

      if (notifTime.isAfter(now.add(reminderBuffer))) {
        NotificationHelper.showNotification(
          id: agenda.id,
          title: 'Jadwal Agenda',
          body: 'Jadwal agenda "${agenda.title}" akan dimulai 1 jam lagi.',
          scheduledTime: notifTime,
        );
      } else {
        final durationUntilStart = start.difference(now);
        final reminderCount = durationUntilStart.inMinutes ~/ 15;

        for (int i = 1; i <= reminderCount; i++) {
          final reminderTime = start.subtract(Duration(minutes: 15 * i));

          if (reminderTime.isAfter(now.add(reminderBuffer))) {
            final remainingMinutes =
                (start.difference(reminderTime).inSeconds / 60).ceil();
            final notifId = agenda.id * 100 + i;

            NotificationHelper.showNotification(
              id: notifId,
              title: 'Pengingat Agenda',
              body:
                  'Agenda "${agenda.title}" akan dimulai dalam $remainingMinutes menit.',
              scheduledTime: reminderTime,
            );
          }
        }
      }
    }
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

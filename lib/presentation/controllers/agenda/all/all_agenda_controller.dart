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

    List<CalendarEventData> list = data!.map((value) {
      // Notifikasi 1 jam sebelum agenda
      final notifTime = value.startEvent.subtract(const Duration(hours: 1));
      final now = DateTime.now();
      const tolerance = Duration(minutes: 1);

      if (notifTime.difference(now) > tolerance) {
        NotificationHelper.showNotification(
          id: value.id,
          title: 'Jadwal Agenda',
          body: 'Jadwal agenda ${value.title} akan dimulai 1 jam lagi.',
          scheduledTime: notifTime,
        );
      } else {
        // Notifikasi setiap 15 menit sebelum agenda
        final now = DateTime.now();
        final start = value.startEvent;
        final durationUntilStart = start.difference(now);

        final reminders = durationUntilStart.inMinutes ~/ 15;

        for (int i = 1; i <= reminders; i++) {
          final reminderTime = now.add(Duration(minutes: 15 * i));

          if (reminderTime.isBefore(start)) {
            final remainingMinutes = start.difference(reminderTime).inMinutes;

            NotificationHelper.showNotification(
              id: value.id + i,
              title: 'Pengingat Agenda',
              body:
                  'Jadwal agenda "${value.title}" akan dimulai dalam $remainingMinutes menit.',
              scheduledTime: reminderTime,
            );
          }
        }
      }

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

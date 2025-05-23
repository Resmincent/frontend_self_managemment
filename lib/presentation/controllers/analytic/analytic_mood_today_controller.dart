import 'package:d_chart/d_chart.dart';
import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/mood_remote_data_source.dart';

class AnalyticMoodTodayController extends GetxController {
  final _state = AnalyticMoodTodayState(
    statusRequest: StatusRequest.init,
    message: '',
    moods: [],
    group: [],
  ).obs;

  AnalyticMoodTodayState get state => _state.value;

  set state(AnalyticMoodTodayState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, data) =
        await MoodRemoteDataSource.analyticToday(userId);

    if (!success) {
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: message,
      );

      return;
    }

    List<TimeData> moods = List.from(data!['moods']).map((e) {
      return TimeData(
        domain: DateTime.parse(e['created_at']),
        measure: e['level'],
      );
    }).toList();

    state = state.copyWith(
        statusRequest: StatusRequest.success,
        moods: moods,
        group: data['group'],
        message: message);

    return state;
  }

  static delete() => Get.delete<AnalyticMoodTodayController>(force: true);
}

class AnalyticMoodTodayState {
  final StatusRequest statusRequest;
  final String message;
  final List<TimeData> moods;
  final List group;

  AnalyticMoodTodayState(
      {required this.statusRequest,
      required this.message,
      required this.moods,
      required this.group});

  AnalyticMoodTodayState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<TimeData>? moods,
    List? group,
  }) {
    return AnalyticMoodTodayState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      moods: moods ?? this.moods,
      group: group ?? this.group,
    );
  }
}

import 'package:d_chart/d_chart.dart';
import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/mood_remote_data_source.dart';

class AnalyticMoodLastMonthController extends GetxController {
  final _state = AnalyticMoodLastMonthState(
    statusRequest: StatusRequest.init,
    message: '',
    moods: [],
    group: [],
  ).obs;

  AnalyticMoodLastMonthState get state => _state.value;

  set state(AnalyticMoodLastMonthState value) => _state.value = value;

  Future<AnalyticMoodLastMonthState> fetch(int userId) async {
    try {
      state = state.copyWith(statusRequest: StatusRequest.loading);

      final (success, message, data) =
          await MoodRemoteDataSource.analyticLastMonth(userId);

      if (!success || data == null) {
        state = state.copyWith(
          statusRequest: StatusRequest.failed,
          message: message,
        );
        return state;
      }

      final moodsList = data['moods'] as List?;
      if (moodsList == null) {
        state = state.copyWith(
          statusRequest: StatusRequest.failed,
          message: 'Invalid mood data format',
        );
        return state;
      }

      List<TimeData> moods = [];
      for (final mood in moodsList) {
        try {
          final createdAt = mood['created_at'];
          final level = mood['level'];

          if (createdAt != null && level != null) {
            moods.add(TimeData(
              domain: DateTime.parse(createdAt.toString()),
              measure: level is num ? level.toDouble() : 0.0,
            ));
          }
        } catch (e) {
          print('Error processing mood entry: $e');
          continue;
        }
      }

      state = state.copyWith(
        statusRequest: StatusRequest.success,
        moods: moods,
        group: data['group'] as List? ?? [],
        message: message,
      );

      return state;
    } catch (e, stackTrace) {
      print('Error in fetch: $e\n$stackTrace');
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: 'An unexpected error occurred',
      );
      return state;
    }
  }

  static void delete() =>
      Get.delete<AnalyticMoodLastMonthController>(force: true);
}

class AnalyticMoodLastMonthState {
  final StatusRequest statusRequest;
  final String message;
  final List<TimeData> moods;
  final List group;

  AnalyticMoodLastMonthState({
    required this.statusRequest,
    required this.message,
    required this.moods,
    required this.group,
  });

  AnalyticMoodLastMonthState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<TimeData>? moods,
    List? group,
  }) {
    return AnalyticMoodLastMonthState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      moods: moods ?? this.moods,
      group: group ?? this.group,
    );
  }
}

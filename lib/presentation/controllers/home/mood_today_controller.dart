import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/mood_remote_data_source.dart';
import 'package:self_management/data/models/mood_model.dart';

class MoodTodayController extends GetxController {
  final _state = MoodTodayState(
    statusRequest: StatusRequest.init,
    message: '',
    moods: [],
  ).obs;

  MoodTodayState get state => _state.value;

  set state(MoodTodayState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, moods) = await MoodRemoteDataSource.today(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      moods: moods ?? [],
    );

    return state;
  }

  static delete() => Get.delete<MoodTodayController>(force: true);
}

class MoodTodayState {
  final StatusRequest statusRequest;
  final String message;
  final List<MoodModel> moods;

  MoodTodayState({
    required this.statusRequest,
    required this.message,
    required this.moods,
  });

  MoodTodayState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<MoodModel>? moods,
  }) {
    return MoodTodayState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      moods: moods ?? this.moods,
    );
  }
}

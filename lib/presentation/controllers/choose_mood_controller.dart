import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/mood_remote_data_source.dart';
import 'package:self_management/data/models/mood_model.dart';

class ChooseMoodController extends GetxController {
  final _level = 3.obs;

  int get level => _level.value;

  set level(int n) => _level.value = n;

  final _state = ChooseMoodState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  ChooseMoodState get state => _state.value;

  set state(ChooseMoodState value) => _state.value = value;

  Future<ChooseMoodState> executeRequest(
    int userId,
  ) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    MoodModel mood = MoodModel(
      level: level,
      createdAt: DateTime.now(),
      userId: userId,
    );

    final (success, message) = await MoodRemoteDataSource.add(mood);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<ChooseMoodController>(force: true);
}

class ChooseMoodState {
  final StatusRequest statusRequest;
  final String message;

  ChooseMoodState({
    required this.statusRequest,
    required this.message,
  });

  ChooseMoodState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return ChooseMoodState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

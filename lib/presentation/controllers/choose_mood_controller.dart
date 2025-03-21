import 'dart:io';

import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/mood_remote_data_source.dart';
import 'package:self_management/data/models/mood_model.dart';

import '../../core/emotion_classifier.dart';

class ChooseMoodController extends GetxController {
  final EmotionClassifier _classifier = EmotionClassifier();
  final Rx<File?> _image = Rx<File?>(null);
  final Rx<String?> _predictedEmotion = Rx<String?>(null);
  final _level = 3.obs;

  File? get image => _image.value;
  String? get predictedEmotion => _predictedEmotion.value;
  int get level => _level.value;

  set level(int n) => _level.value = n;

  void setImage(File file) {
    _image.value = file;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeClassifier();
  }

  Future<void> _initializeClassifier() async {
    try {
      await _classifier.loadModel();
    } catch (e) {
      print('Error loading emotion classifier model: $e');
    }
  }

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

    try {
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
    } catch (e) {
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: 'Error: ${e.toString()}',
      );
    }

    return state;
  }

  static void delete() => Get.delete<ChooseMoodController>(force: true);

  Future<ChooseMoodState> classifyImageAndSave(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    try {
      if (_image.value == null) {
        throw Exception('No image selected.');
      }

// Classify image
      final emotion = await _classifier.classifyImage(_image.value!);
      _predictedEmotion.value = emotion;

// Map emotion to level
      final int moodLevel = _mapEmotionToLevel(emotion);
      level = moodLevel;

// Save to database
      final mood = MoodModel(
        level: moodLevel,
        createdAt: DateTime.now(),
        userId: userId,
      );

      final (success, message) = await MoodRemoteDataSource.add(mood);

      if (success) {
        state = state.copyWith(
          statusRequest: StatusRequest.success,
          message: 'Mood detected: $emotion. Saved successfully!',
        );
      } else {
        state = state.copyWith(
          statusRequest: StatusRequest.failed,
          message: message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: e.toString(),
      );
    }

    return state;
  }

// Map emotion to mood level
  int _mapEmotionToLevel(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return 5;
      case 'neutral':
        return 3;
      case 'sad':
        return 2;
      case 'angry':
        return 1;
      case 'disgust':
        return 4;
      default:
        return 3; // Default to neutral
    }
  }
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

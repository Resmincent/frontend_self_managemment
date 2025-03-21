import 'dart:async';

import 'package:get/get.dart';

class PomodoroTimerController extends GetxController {
  // Durasi pomodoro
  final List<int> workDurationOptions = [
    15 * 60,
    25 * 60,
    30 * 60,
    45 * 60,
    60 * 60
  ];
  RxInt selectedWorkDuration = 1.obs;

  // Durasi istirahat
  final List<int> shortBreakDurationOptions = [
    5 * 60,
    10 * 60,
    15 * 60,
  ];

  RxInt selectedShortBreakDuration = 0.obs;

  // Durasi default untuk timer
  RxInt remainingTime = (25 * 60).obs; // Default: 25 menit
  RxBool isRunning = false.obs;
  RxInt pomodoroCount = 0.obs;

  // Timer object
  late Rx<Timer> timer;

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRunning.value && remainingTime.value > 0) {
        remainingTime.value--;
      } else if (remainingTime.value == 0) {
        _handleTimerCompletion();
      }
    }).obs;
  }

  // Fungsi untuk memulai timer
  void startTimer() {
    isRunning.value = true;
  }

  // Fungsi untuk menjeda timer
  void pauseTimer() {
    isRunning.value = false;
  }

  // Fungsi untuk mereset timer
  void resetTimer() {
    isRunning.value = false;
    remainingTime.value = workDurationOptions[selectedWorkDuration.value];
    pomodoroCount.value = 0;
  }

  // Handle ketika timer selesai
  void _handleTimerCompletion() {
    isRunning.value = false;
    pomodoroCount.value++;

    if (pomodoroCount.value % 4 == 0) {
      remainingTime.value =
          longBreakDuration; // Istirahat panjang setelah 4 pomodoro
    } else {
      remainingTime.value =
          shortBreakDurationOptions[selectedShortBreakDuration.value];
    }
  }

  // Format waktu menjadi MM:SS
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  // Getter untuk durasi kerja yang dipilih
  int get workDuration => workDurationOptions[selectedWorkDuration.value];

  // Getter untuk durasi istirahat pendek yang dipilih
  int get shortBreakDuration =>
      shortBreakDurationOptions[selectedShortBreakDuration.value];

  // Getter untuk durasi istirahat panjang (tetap 15 menit)
  int get longBreakDuration => 15 * 60;

  @override
  void onClose() {
    timer.value.cancel();
  }
}

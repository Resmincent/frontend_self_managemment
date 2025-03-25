import 'dart:async';

import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:self_management/common/constans.dart';
import '../../common/enums.dart';
import '../../data/models/model_timer.dart';

class PomodoroController extends GetxController {
  final ModelTimer _timerModel = ModelTimer();

  late int _duration;
  RxInt remainingTime = 0.obs;
  RxBool isRunning = false.obs;

  Rx<TimerType> currentTimerType = TimerType.focus.obs;

  Timer? _timer;

  final AudioPlayer _audioPlayer = AudioPlayer();

  int sessionCount = 0;

  @override
  void onInit() {
    super.onInit();
    _setFocusDuration();
  }

  void startTimer() {
    if (!isRunning.value) {
      isRunning.value = true;
      _startCountdown();
    }
  }

  void pauseTimer() {
    if (isRunning.value) {
      isRunning.value = false;
      _timer?.cancel();
    }
  }

  void resetTimer() {
    isRunning.value = false;
    _timer?.cancel();
    remainingTime.value = _duration;
  }

  // Logika countdown
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0 && isRunning.value) {
        remainingTime.value--;
      } else {
        timer.cancel();
        isRunning.value = false;
        _playSound('assets/audios/end-timer.mp3');
        _handleNextInterval();
      }
    });
  }

  Future<void> _playSound(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  // Mendapatkan opsi durasi waktu
  String getFormattedTime() {
    int minutes = remainingTime.value ~/ 60;
    int seconds = remainingTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Menangani pergantian interval
  void _handleNextInterval() {
    switch (currentTimerType.value) {
      case TimerType.focus:
        sessionCount++;
        if (sessionCount % Constans.sessionsBeforeLongBreak == 0) {
          _setLongBreakDuration();
        } else {
          _setShortBreakDuration();
        }
        break;
      case TimerType.shortBreak:
        _setFocusDuration();
        break;
      case TimerType.longBreak:
        _setFocusDuration();
        break;
    }
  }

  // Reset interval
  void resetInterval() {
    sessionCount = 0;
    _setFocusDuration();
  }

  // Set durasi untuk sesi fokus
  void _setFocusDuration() {
    currentTimerType.value = TimerType.focus;
    _duration = _timerModel.getDurationInSeconds(_timerModel.focusDuration);
    remainingTime.value = _duration;
  }

  // Set durasi untuk short break
  void _setShortBreakDuration() {
    currentTimerType.value = TimerType.shortBreak;
    _duration =
        _timerModel.getDurationInSeconds(_timerModel.shortBreakDuration);
    remainingTime.value = _duration;
  }

  // Set durasi untuk long break
  void _setLongBreakDuration() {
    currentTimerType.value = TimerType.longBreak;
    _duration = _timerModel.getDurationInSeconds(_timerModel.longBreakDuration);
    remainingTime.value = _duration;
  }

  // Mendapatkan label untuk jenis timer saat ini
  String getCurrentTimerLabel() {
    switch (currentTimerType.value) {
      case TimerType.focus:
        return 'Focus Session';
      case TimerType.shortBreak:
        return 'Short Break';
      case TimerType.longBreak:
        return 'Long Break';
    }
  }
}

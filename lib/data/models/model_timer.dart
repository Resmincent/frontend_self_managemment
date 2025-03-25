class ModelTimer {
  // final List<int> timeOptions = [15, 25, 30, 45, 60];
  final int shortBreakDuration = 5;
  final int longBreakDuration = 15;
  final int focusDuration = 25;

  int getDurationInSeconds(int minutes) {
    return minutes * 60;
  }

  // List<String> getFormattedTimeOptions() {
  //   return timeOptions.map((e) => '$e menit').toList();
  // }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/common/app_color.dart';
import '../controllers/pomodoro_timer_controller.dart';

class PomodoroTimerPage extends StatefulWidget {
  const PomodoroTimerPage({super.key});

  static const routeName = '/pomodoro-timer';

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  final PomodoroTimerController controller = Get.put(PomodoroTimerController());

  // Widget untuk header
  Widget _buildHeaderPomodoro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.primary,
            ),
          ),
          const Text(
            'Pomodoro Timer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage('assets/images/add_agenda.png'),
              size: 24,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk konten timer
  Widget _buildContentTimer() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 350,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.primary, AppColor.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indikator status (Work/Break)
            Obx(() => Text(
                  controller.pomodoroCount.value % 4 == 0 &&
                          controller.remainingTime.value > 0
                      ? 'Long Break'
                      : controller.remainingTime.value > 0 &&
                              controller.remainingTime.value ==
                                  controller.shortBreakDurationOptions[
                                      controller
                                          .selectedShortBreakDuration.value]
                          ? 'Short Break'
                          : 'Work',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 10),

            // Tampilkan waktu tersisa
            Obx(() => Text(
                  controller.formatTime(controller.remainingTime.value),
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 20),

            // Dropdown untuk durasi kerja
            _buildDropdown(
              label: 'Work Duration',
              value: controller.selectedWorkDuration.value,
              options: controller.workDurationOptions,
              onChanged: (value) {
                controller.selectedWorkDuration.value = value!;
                controller.resetTimer();
              },
            ),
            const SizedBox(height: 10),

            // Dropdown untuk durasi istirahat pendek
            _buildDropdown(
              label: 'Short Break Duration',
              value: controller.selectedShortBreakDuration.value,
              options: controller.shortBreakDurationOptions,
              onChanged: (value) {
                controller.selectedShortBreakDuration.value = value!;
              },
            ),
            const SizedBox(height: 20),

            // Tombol kontrol timer
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonThird(
                  onPressed: () {
                    if (!controller.isRunning.value) {
                      controller.startTimer();
                    }
                  },
                  title: 'Start',
                ),
                const SizedBox(width: 20),
                ButtonDelete(
                  onPressed: () {
                    if (controller.isRunning.value) {
                      controller.pauseTimer();
                    } else {
                      controller.resetTimer();
                    }
                  },
                  title: controller.isRunning.value ? 'Pause' : 'Reset',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget dropdown generik
  Widget _buildDropdown({
    required String label,
    required int value,
    required List<int> options,
    required Function(int?) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<int>(
          value: value,
          items: List.generate(
            options.length,
            (index) => DropdownMenuItem<int>(
              value: index,
              child: Text(
                '${options[index] ~/ 60} minutes',
                style: const TextStyle(color: AppColor.textTitle),
              ),
            ),
          ),
          onChanged: onChanged,
          dropdownColor: AppColor.secondary,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 55,
            left: 0,
            right: 0,
            child: _buildHeaderPomodoro(context),
          ),
          // Konten Timer
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: _buildContentTimer(),
            ),
          ),
        ],
      ),
    );
  }
}

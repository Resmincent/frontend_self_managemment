import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';

import '../../../common/enums.dart';
import '../../controllers/pomodoro_controller.dart';

class PomodoroTimerPage extends StatefulWidget {
  const PomodoroTimerPage({super.key});

  static const routeName = '/pomodoro-timer';

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  final PomodoroController controller = Get.put(PomodoroController());

  Widget _buildHeaderPomodoro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
              color: AppColor.primary,
            ),
          ),
          const Text(
            'Pomodoro Timer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 28,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Obx(
      () => Column(
        children: [
          Text(
            controller.getCurrentTimerLabel(),
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _getLabelColor(controller.currentTimerType.value),
            ),
          ),
          const Gap(56),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary.withOpacity(0.2),
            ),
            child: Text(
              controller.getFormattedTime(),
              style: const TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: AppColor.colorWhite,
              ),
            ),
          ),
          const Gap(30),
          Text(
            'Session: ${controller.sessionCount} / 4',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.textTitle,
            ),
          ),
          const Gap(10),
          ElevatedButton(
            onPressed: controller.resetInterval,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 30),
            ),
            child: const Text(
              'Reset Session',
              style: TextStyle(
                fontSize: 18,
                color: AppColor.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: controller.isRunning.value
                ? controller.pauseTimer
                : controller.startTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isRunning.value
                  ? AppColor.error
                  : AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
            ),
            child: Text(
              controller.isRunning.value ? 'Pause' : 'Start',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const Gap(20),
          ElevatedButton(
            onPressed: controller.resetTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.textBody,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
            ),
            child: const Text(
              'Reset',
              style: TextStyle(
                fontSize: 18,
                color: AppColor.colorWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(16),
            _buildHeaderPomodoro(),
            const Gap(50),
            _buildTimerDisplay(),
            const Gap(50),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }
}

Color _getLabelColor(TimerType timerType) {
  switch (timerType) {
    case TimerType.focus:
      return Colors.red;
    case TimerType.shortBreak:
      return Colors.green;
    case TimerType.longBreak:
      return Colors.blue;
  }
}

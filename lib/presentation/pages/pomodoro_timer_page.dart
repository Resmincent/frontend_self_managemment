import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';

import '../../common/app_color.dart';

class PomodoroTimerPage extends StatefulWidget {
  const PomodoroTimerPage({super.key});

  static const routeName = '/pomodoro-timer';

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  Widget _buildHeaderPomodoro() {
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
              fontSize: 16,
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

  Widget _buildContentTimer() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text('Hallo'),
            const Text('ini'),
            const Text('Ifran'),
            const Gap(110),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonThird(
                  onPressed: () {},
                  title: 'Start Timer',
                ),
                const Gap(20),
                ButtonDelete(
                  onPressed: () {},
                  title: 'Stop Timer',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 55,
            left: 0,
            right: 0,
            child: _buildHeaderPomodoro(),
          ),
          Positioned(
            top: 275,
            left: 0,
            right: 0,
            child: _buildContentTimer(),
          )
        ],
      ),
    );
  }
}

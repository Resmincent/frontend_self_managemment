import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/game_controller.dart';

class TopScore extends StatelessWidget {
  const TopScore({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find<GameController>();

    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Center(
        child: Obx(() => Text(
              '${gameController.currentScore}',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }
}

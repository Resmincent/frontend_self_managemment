import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/game_controller.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find<GameController>();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER!',
                style: TextStyle(
                  color: Color(0xFFFFCA00),
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() => Text(
                    'Score: ${gameController.currentScore}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  )),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => gameController.restartGame(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'PLAY AGAIN!',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

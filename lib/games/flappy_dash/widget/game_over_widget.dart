import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';

import '../../../presentation/controllers/game_controller.dart';
import '../../../presentation/pages/choose_mood_page.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _goToMood() async {
      await Navigator.pushNamed(context, ChooseMoodPage.routeName);
    }

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
              SizedBox(
                width: 270,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ButtonThird(
                        onPressed: () => gameController.restartGame(),
                        title: 'PLAY AGAIN!!',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonPrimary(
                        onPressed: _goToMood,
                        title: 'Choose Mood!',
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

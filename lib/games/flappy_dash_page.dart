import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/controllers/game_controller.dart';
import 'flappy_dash/flappy_dash_game.dart';
import 'flappy_dash/tap_to_play.dart';
import 'flappy_dash/top_score.dart';
import 'widget/game_over_widget.dart';

class FlappyDashPage extends StatefulWidget {
  const FlappyDashPage({super.key});

  static const routeName = '/flappy-dash';

  @override
  State createState() => _FlappyDashPageState();
}

class _FlappyDashPageState extends State {
  late FlappyDashGame _flappyDashGame;
  final GameController gameController = Get.find();
  PlayingState? _latestState;

  @override
  void initState() {
    _flappyDashGame = FlappyDashGame();
    super.initState();

    ever(gameController.playingStateObs, (state) {
      PlayingState playingState = state;

      if (playingState == PlayingState.idle &&
          _latestState == PlayingState.gameOver) {
        setState(() {
          _flappyDashGame = FlappyDashGame();
        });
      }
      _latestState = playingState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _flappyDashGame),
          Obx(() {
            return gameController.playingStateObs.value.isGameOver
                ? const GameOverWidget()
                : const SizedBox.shrink();
          }),
          Obx(() {
            return gameController.playingStateObs.value.isIdle
                ? const Align(
                    alignment: Alignment(0, 0.2),
                    child: TapToPlay(),
                  )
                : const SizedBox.shrink();
          }),
          Obx(() {
            return gameController.playingStateObs.value.isNotGameOver
                ? const TopScore()
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

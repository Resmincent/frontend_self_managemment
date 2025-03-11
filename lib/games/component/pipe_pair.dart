import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:self_management/games/component/hidden_coin.dart';
import 'package:self_management/games/component/pipe.dart';

import '../../presentation/controllers/game_controller.dart';

class PipePair extends PositionComponent {
  PipePair({
    required super.position,
    this.gap = 200.0,
    this.speed = 200.0,
  });

  // Get the controller
  final GameController gameController = Get.find<GameController>();

  final double gap;
  final double speed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      Pipe(
        isFlipped: false,
        position: Vector2(0, gap / 2),
      ),
      Pipe(
        isFlipped: true,
        position: Vector2(0, -(gap / 2)),
      ),
      HiddenCoin(
        position: Vector2(30, 0),
      ),
    ]);
  }

  @override
  void update(double dt) {
    switch (gameController.currentPlayingState) {
      case PlayingState.paused:
      case PlayingState.gameOver:
      case PlayingState.idle:
        break;
      case PlayingState.playing:
        position.x -= speed * dt;
        break;
    }
    super.update(dt);
  }
}

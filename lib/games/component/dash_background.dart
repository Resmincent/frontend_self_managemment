import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/game_controller.dart';
import '../flappy_dash/flappy_dash_game.dart';

class DashBackground extends ParallaxComponent<FlappyDashGame> {
  final GameController gameController = Get.find<GameController>();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/layer1-sky.png'),
        ParallaxImageData('background/layer2-clouds.png'),
        ParallaxImageData('background/layer3-clouds.png'),
        ParallaxImageData('background/layer4-clouds.png'),
        ParallaxImageData('background/layer5-huge-clouds.png'),
        ParallaxImageData('background/layer6-bushes.png'),
        ParallaxImageData('background/layer7-bushes.png'),
      ],
      baseVelocity: Vector2(1, 0),
      velocityMultiplierDelta: Vector2(1.7, 0),
    );
  }

  @override
  void update(double dt) {
    switch (gameController.currentPlayingState) {
      case PlayingState.idle:
      case PlayingState.playing:
        super.update(dt);
        break;
      case PlayingState.paused:
      case PlayingState.gameOver:
        break;
    }
  }
}

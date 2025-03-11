import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:self_management/games/flappy_dash/component/hidden_coin.dart';
import 'package:self_management/games/flappy_dash/component/pipe.dart';

import '../../../presentation/controllers/game_controller.dart';
import '../flappy_dash_game.dart';

class Dash extends PositionComponent
    with CollisionCallbacks, HasGameRef<FlappyDashGame> {
  Dash()
      : super(
          position: Vector2(0, 0),
          size: Vector2.all(80.0),
          anchor: Anchor.center,
          priority: 10,
        );

  // Get the controller
  final GameController gameController = Get.find<GameController>();

  late Sprite _dashSprite;
  final Vector2 _gravity = Vector2(0, 1400.0);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 _jumpForce = Vector2(0, -500);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _dashSprite = await Sprite.load('dash.png');
    final radius = size.x / 2;
    final center = size / 2;
    add(CircleHitbox(
      radius: radius * 0.75,
      position: center * 1.1,
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameController.currentPlayingState.isNotPlaying) {
      return;
    }
    // Fixed the "*velocity" syntax which appears to be a typo
    _velocity += _gravity * dt;
    position += _velocity * dt;
  }

  void jump() {
    if (gameController.currentPlayingState.isNotPlaying) {
      return;
    }
    // Fixed the "*velocity" and "*jumpForce" syntax
    _velocity = _jumpForce.clone();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(
      canvas,
      size: size,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (gameController.currentPlayingState.isNotPlaying) {
      return;
    }
    if (other is HiddenCoin) {
      gameController.increaseScore();
      other.removeFromParent();
    } else if (other is Pipe) {
      gameController.gameOver();
    }
  }
}

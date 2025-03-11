import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:get/get.dart';
import 'package:self_management/games/flappy_dash/component/dash.dart';
import 'package:self_management/games/flappy_dash/component/pipe_pair.dart';

import '../../../presentation/controllers/game_controller.dart';
import '../flappy_dash_game.dart';
import 'dash_background.dart';

class FlappyDashRootComponent extends Component
    with HasGameRef<FlappyDashGame> {
  late Dash _dash;
  late PipePair _lastPipe;
  static const _pipesDistance = 400.0;

  // Get the controller
  final GameController gameController = Get.find<GameController>();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(DashBackground());
    add(_dash = Dash());
    _generatePipes(
      fromX: 350,
    );
  }

  void _generatePipes({
    int count = 5,
    double fromX = 0.0,
  }) {
    for (int i = 0; i < count; i++) {
      const area = 600;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe = PipePair(
        position: Vector2(fromX + (i * _pipesDistance), y),
      ));
    }
  }

  void _removeLastPipes() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onSpaceDown() {
    _checkToStart();
    _dash.jump();
  }

  void onTapDown(TapDownEvent event) {
    _checkToStart();
    _dash.jump();
  }

  void _checkToStart() {
    if (gameController.currentPlayingState.isIdle) {
      gameController.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_dash.x >= _lastPipe.x) {
      _generatePipes(
        fromX: _pipesDistance,
      );
      _removeLastPipes();
    }
    game.camera.viewfinder.zoom = 1.0;
  }
}

import 'package:get/get.dart';
import '../../games/audio_helper.dart';

enum PlayingState {
  idle,
  playing,
  paused,
  gameOver;

  bool get isPlaying => this == PlayingState.playing;
  bool get isNotPlaying => !isPlaying;
  bool get isGameOver => this == PlayingState.gameOver;
  bool get isNotGameOver => !isGameOver;
  bool get isIdle => this == PlayingState.idle;
  bool get isPaused => this == PlayingState.paused;
}

class GameController extends GetxController {
  GameController(this._audioHelper);

  final AudioHelper _audioHelper;

  final Rx<PlayingState> _currentPlayingState = PlayingState.idle.obs;
  final RxInt _currentScore = 0.obs;

  PlayingState get currentPlayingState => _currentPlayingState.value;
  int get currentScore => _currentScore.value;

  Rx<PlayingState> get playingStateObs => _currentPlayingState;
  RxInt get scoreObs => _currentScore;

  void startPlaying() {
    _audioHelper.playBackgroundAudio();
    _currentPlayingState.value = PlayingState.playing;
    _currentScore.value = 0;
  }

  void increaseScore() {
    _audioHelper.playScoreCollectSound();
    _currentScore.value++;
  }

  void gameOver() {
    _audioHelper.stopBackgroundAudio();
    _currentPlayingState.value = PlayingState.gameOver;
  }

  void restartGame() {
    _currentPlayingState.value = PlayingState.idle;
    _currentScore.value = 0;
  }
}

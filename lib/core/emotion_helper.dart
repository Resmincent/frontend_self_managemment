import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class EmotionResult {
  final int level;
  final String label;
  final double confidence;

  EmotionResult({
    required this.level,
    required this.label,
    required this.confidence,
  });
}

class EmotionClassifier {
  Interpreter? _interpreter;

  static const List<String> emotionLabels = [
    '', // 0 - dummy entry
    'angry', // 1
    'disgusted', // 2
    'fearful', // 3
    'happy', // 4
    'neutral', // 5
    'sad', // 6
    'surprised' // 7
  ];

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/model_v2_final.tflite');
    } catch (e) {
      throw Exception("Failed to load TFLite model: $e");
    }
  }

  EmotionResult classify(img.Image imageInput) {
    if (_interpreter == null) {
      throw Exception("Model not loaded. Please call loadModel() first.");
    }

    final imageResized = img.copyResize(imageInput, width: 48, height: 48);
    final grayscale = img.grayscale(imageResized);

    var input = List.generate(
        1,
        (_) => List.generate(
            48,
            (y) =>
                List.generate(48, (x) => [grayscale.getPixel(x, y) & 0xFF])));

    var output = List.generate(1, (_) => List.filled(7, 0.0));
    _interpreter!.run(input, output);

    final predictions = output[0];
    final maxValue = predictions.reduce((a, b) => a > b ? a : b);
    final rawIndex = predictions.indexOf(maxValue);
    final index = rawIndex + 1; // geser agar mulai dari 1
    final label = emotionLabels[index];

    debugPrint("=== Emotion Probabilities ===");
    for (int i = 0; i < predictions.length; i++) {
      debugPrint(
          "${emotionLabels[i + 1]}: ${(predictions[i] * 100).toStringAsFixed(2)}%");
    }

    return EmotionResult(
      level: index,
      label: label,
      confidence: maxValue,
    );
  }

  Future<EmotionResult?> predictFromBytes(Uint8List bytes) async {
    if (_interpreter == null) {
      debugPrint("Model belum dimuat. Jalankan loadModel() terlebih dahulu.");
      return null;
    }

    final image = img.decodeImage(bytes);
    if (image == null) return null;
    return classify(image);
  }
}

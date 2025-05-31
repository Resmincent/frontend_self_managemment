import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class DetectionResult {
  final String label;
  final double confidence;
  final Rect boundingBox;

  DetectionResult({
    required this.label,
    required this.confidence,
    required this.boundingBox,
  });
}

class YoloObjectDetector {
  late Interpreter _interpreter;
  final labels = ['angry', 'happy', 'neutral'];

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/yolov11_v2.tflite');
      print("Model loaded successfully");
    } catch (e) {
      print("Gagal load model: $e");
    }
  }

  Future<List<DetectionResult>> detect(img.Image image) async {
    final resized = img.copyResize(image, width: 416, height: 416);

    final input = Float32List(416 * 416 * 3);
    int index = 0;
    for (int y = 0; y < 416; y++) {
      for (int x = 0; x < 416; x++) {
        final pixel = resized.getPixel(x, y);
        input[index++] = img.getRed(pixel) / 255.0;
        input[index++] = img.getGreen(pixel) / 255.0;
        input[index++] = img.getBlue(pixel) / 255.0;
      }
    }

    final inputTensor = input.reshape([1, 416, 416, 3]);
    final outputTensor = List.generate(
        1, (_) => List.generate(7, (_) => List.filled(3549, 0.0)));

    _interpreter.run(inputTensor, outputTensor);

    final predictions = outputTensor[0]; // shape: [7][3549]
    final List<DetectionResult> results = [];

    for (int i = 0; i < 3549; i++) {
      final x = predictions[0][i];
      final y = predictions[1][i];
      final w = predictions[2][i];
      final h = predictions[3][i];
      final objConf = predictions[4][i];

      if (objConf < 0.00001) continue; // sementara untuk debug

      final classScores = [
        predictions[5][i], // angry
        predictions[6][i], // happy
      ];

      final scoreMultiplied = classScores.map((s) => s * objConf).toList();
      final maxIndex = scoreMultiplied.indexWhere(
        (s) => s == scoreMultiplied.reduce((a, b) => a > b ? a : b),
      );

      final label = labels[maxIndex];
      final confidence = scoreMultiplied[maxIndex];

      if (confidence < 0.01) continue; // sementara untuk debug

      final left = (x - w / 2).clamp(0.0, 1.0);
      final top = (y - h / 2).clamp(0.0, 1.0);
      final right = (x + w / 2).clamp(0.0, 1.0);
      final bottom = (y + h / 2).clamp(0.0, 1.0);

      results.add(DetectionResult(
        label: label,
        confidence: confidence,
        boundingBox: Rect.fromLTRB(left, top, right, bottom),
      ));

      print(
          "Box $i → objConf: $objConf, angry: ${classScores[0]}, happy: ${classScores[1]}, label: $label, conf: $confidence");
    }

    return results;
  }
}

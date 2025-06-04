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
    '',
    'angry',
    'happy',
    'neutral',
  ];

  /// Memuat model TFLite dari folder assets
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/model_v3_mobilenet_final.tflite',
        options: InterpreterOptions()..threads = 1,
      );
      debugPrint("Model berhasil dimuat");
    } catch (e) {
      throw Exception("Gagal memuat model TFLite: $e");
    }
  }

  /// Melakukan prediksi dari gambar yang telah di-decode menjadi img.Image
  EmotionResult classify(img.Image imageInput) {
    if (_interpreter == null) {
      throw Exception(
          "Model belum dimuat. Jalankan loadModel() terlebih dahulu.");
    }

    // Resize ke 224x224
    final resizedImage = img.copyResize(imageInput, width: 224, height: 224);

    // Konversi ke input RGB normalized [0-1]
    final input = List.generate(
        1,
        (_) => List.generate(
            224,
            (y) => List.generate(224, (x) {
                  final pixel = resizedImage.getPixel(x, y);
                  final r = img.getRed(pixel) / 255.0;
                  final g = img.getGreen(pixel) / 255.0;
                  final b = img.getBlue(pixel) / 255.0;
                  return [r, g, b];
                })));

    // Siapkan output [1, 3] untuk 3 kelas emosi
    final output = List.generate(1, (_) => List.filled(3, 0.0));

    // Jalankan inferensi
    _interpreter!.run(input, output);

    final predictions = output[0];
    final maxValue = predictions.reduce((a, b) => a > b ? a : b);
    final index = predictions.indexOf(maxValue);
    final label = emotionLabels[index];

    // Debug info (opsional)
    debugPrint("=== Hasil Prediksi ===");
    for (int i = 0; i < predictions.length; i++) {
      debugPrint(
          "${emotionLabels[i]}: ${(predictions[i] * 100).toStringAsFixed(2)}%");
    }

    return EmotionResult(
      level: index,
      label: label,
      confidence: maxValue,
    );
  }

  /// Melakukan prediksi langsung dari Uint8List (misal dari kamera/file picker)
  Future<EmotionResult?> predictFromBytes(Uint8List bytes) async {
    if (_interpreter == null) {
      debugPrint("Model belum dimuat. Jalankan loadModel() terlebih dahulu.");
      return null;
    }

    final image = img.decodeImage(bytes);
    if (image == null) return null;

    return classify(image);
  }

  /// Opsional: untuk dispose interpreter
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}

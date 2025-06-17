import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class EmotionResult {
  final int level; // index untuk kebutuhan UI (mulai dari 1)
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

  /// Label kelas model (harus sesuai urutan output model)
  static const List<String> _modelEmotionLabels = [
    'angry',
    'happy',
    'neutral',
  ];

  /// Label untuk keperluan UI, dengan indeks mulai dari 1
  static const List<String> uiEmotionLabels = [
    '', // Kosong di index 0 (dummy, agar level = index UI)
    'angry',
    'happy',
    'neutral',
  ];

  /// Memuat model TFLite dari assets
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/model_v5_mobilenet_final.tflite',
        options: InterpreterOptions()..threads = 1,
      );
      debugPrint("Model berhasil dimuat");
    } catch (e) {
      throw Exception("Gagal memuat model TFLite: $e");
    }
  }

  /// Mengklasifikasikan gambar input (dalam format img.Image)
  EmotionResult classify(img.Image imageInput) {
    if (_interpreter == null) {
      throw Exception(
          "Model belum dimuat. Jalankan loadModel() terlebih dahulu.");
    }

    // Resize gambar ke 224x224
    final resizedImage = img.copyResize(imageInput, width: 224, height: 224);

    // Konversi ke input normalisasi [0-1]
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
              })),
    );

    // Output model: [1, 3] untuk 3 kelas
    final output = List.generate(1, (_) => List.filled(3, 0.0));

    _interpreter!.run(input, output);
    final predictions = output[0];

    final maxValue = predictions.reduce((a, b) => a > b ? a : b);
    final index = predictions.indexOf(maxValue);
    final label = _modelEmotionLabels[index];

    // Debug info
    debugPrint("=== Hasil Prediksi ===");
    for (int i = 0; i < predictions.length; i++) {
      debugPrint(
          "${_modelEmotionLabels[i]}: ${(predictions[i] * 100).toStringAsFixed(2)}%");
    }

    // level disesuaikan dengan indeks untuk kebutuhan UI → index + 1
    return EmotionResult(
      level: index + 1,
      label: label,
      confidence: maxValue,
    );
  }

  /// Prediksi dari gambar dalam bentuk bytes (misalnya dari kamera atau file picker)
  Future<EmotionResult?> predictFromBytes(Uint8List bytes) async {
    if (_interpreter == null) {
      debugPrint("Model belum dimuat. Jalankan loadModel() terlebih dahulu.");
      return null;
    }

    final image = img.decodeImage(bytes);
    if (image == null) return null;

    return classify(image);
  }

  /// Opsional: Menutup interpreter setelah tidak digunakan
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}

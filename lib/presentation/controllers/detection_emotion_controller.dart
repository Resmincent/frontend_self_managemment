import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:self_management/data/models/mood_model.dart';
import '../../data/datasources/mood_remote_data_source.dart';

class DetectEmotionController extends GetxController {
  final interpreter = Rxn<Interpreter>();
  final isLoading = false.obs;
  final boundingBoxes = <Rect>[].obs;
  final labels = <String>[].obs;

  final inputSize = 416;
  final labelNames = ['angry', 'happy', 'neutral'];

  final cameraController = Rxn<CameraController>();
  final isCameraInitialized = false.obs;

  DateTime? _lastInferenceTime;

  @override
  void onInit() {
    super.onInit();
    loadModel();
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }

  Future<void> loadModel() async {
    try {
      interpreter.value =
          await Interpreter.fromAsset('assets/models/yolov11_v2.tflite');
    } catch (e) {
      debugPrint("Failed to load model: $e");
    }
  }

  Future<void> initializeCamera() async {
    if (cameraController.value != null &&
        cameraController.value!.value.isInitialized) return;

    try {
      isLoading.value = true;

      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      cameraController.value?.dispose();
      cameraController.value = controller;

      isCameraInitialized.value = true;
      startImageStream();
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
      isCameraInitialized.value = false;
      Get.snackbar("Kamera", "Gagal menginisialisasi kamera.");
    } finally {
      isLoading.value = false;
    }
  }

  void startImageStream() {
    cameraController.value!.startImageStream((CameraImage image) async {
      if (isLoading.value) return;

      if (_lastInferenceTime != null &&
          DateTime.now().difference(_lastInferenceTime!) <
              const Duration(seconds: 1)) {
        return;
      }

      isLoading.value = true;
      _lastInferenceTime = DateTime.now();

      final imgInput = convertCameraImage(image);
      if (imgInput == null) {
        isLoading.value = false;
        return;
      }

      final resized =
          img.copyResize(imgInput, width: inputSize, height: inputSize);

      final input = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(
            inputSize,
            (x) => List.generate(
              3,
              (c) => resized.getPixel(x, y).getChannel(c) / 255.0,
            ),
          ),
        ),
      );

      var output = List.filled(1 * 7 * 3549, 0.0).reshape([1, 7, 3549]);
      interpreter.value?.run(input, output);

      boundingBoxes.clear();
      labels.clear();

      final results = output[0];
      const confThreshold = 0.4;

      for (int i = 0; i < results[0].length; i++) {
        final x = results[0][i];
        final y = results[1][i];
        final w = results[2][i];
        final h = results[3][i];
        final conf = results[4][i];

        if (conf < confThreshold) continue;

        final classProbs = results.sublist(5).map((r) => r[i]).toList();
        final classIndex =
            classProbs.indexWhere((e) => e == classProbs.reduce(max));
        if (classIndex < 0 || classIndex >= labelNames.length) continue;

        final dx = x - w / 2;
        final dy = y - h / 2;

        final box = Rect.fromLTWH(
          dx * image.width / inputSize,
          dy * image.height / inputSize,
          w * image.width / inputSize,
          h * image.height / inputSize,
        );

        boundingBoxes.add(box);
        labels.add(labelNames[classIndex]);
      }

      isLoading.value = false;
    });
  }

  Future<(bool success, String message)> submitMood(int userId) async {
    if (labels.isEmpty) return (false, "Tidak ada deteksi emosi.");

    final latestLabel = labels.last;
    final classIndex = labelNames.indexOf(latestLabel);
    if (classIndex == -1) return (false, "Label emosi tidak valid.");

    final (success, message) = await MoodRemoteDataSource.add(
      MoodModel(
        userId: userId,
        level: classIndex,
        createdAt: DateTime.now(),
      ),
    );

    return (success, message);
  }

  void resetDetection() {
    boundingBoxes.clear();
    labels.clear();
  }

  img.Image? convertCameraImage(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;
      final imgBytes = List<int>.filled(width * height * 3, 0);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
          final int index = y * width + x;
          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          final r = (yp + 1.402 * (vp - 128)).clamp(0, 255).toInt();
          final g = (yp - 0.344136 * (up - 128) - 0.714136 * (vp - 128))
              .clamp(0, 255)
              .toInt();
          final b = (yp + 1.772 * (up - 128)).clamp(0, 255).toInt();
          imgBytes[index * 3] = r;
          imgBytes[index * 3 + 1] = g;
          imgBytes[index * 3 + 2] = b;
        }
      }

      return img.Image.fromBytes(width, height, imgBytes);
    } catch (_) {
      return null;
    }
  }
}

extension IntColorChannel on int {
  double getChannel(int channel) =>
      ((this >> (16 - 8 * channel)) & 0xFF).toDouble();
}

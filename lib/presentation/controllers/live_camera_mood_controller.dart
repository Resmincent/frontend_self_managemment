import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../core/emotion_helper.dart';
import '../../data/datasources/mood_remote_data_source.dart';
import '../../data/models/mood_model.dart';

class LiveCameraMoodController extends GetxController {
  final EmotionClassifier _classifier = EmotionClassifier();
  final Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  final Rx<Rect?> faceBoundingBox = Rx<Rect?>(null);

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableLandmarks: false,
      enableClassification: false,
    ),
  );

  var detectedEmotion = ''.obs;
  var detectedConfidence = 0.0.obs;
  var predictedLevel = 0;
  var isDetecting = false.obs;

  Timer? _detectionTimer;

  Future<void> initializeCamera(List<CameraDescription> cameras) async {
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    final controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller.initialize();
    cameraController.value = controller;

    await _classifier.loadModel();
    startImageStream();
  }

  void startImageStream() {
    cameraController.value?.startImageStream((CameraImage image) async {
      if (isDetecting.value ||
          (cameraController.value?.value.isStreamingImages != true)) return;
      if (_detectionTimer?.isActive ?? false) return;

      _detectionTimer = Timer(const Duration(seconds: 2), () {});
      isDetecting.value = true;

      try {
        final rgbImage = _convertYUV420ToImage(image);
        final jpegBytes = Uint8List.fromList(img.encodeJpg(rgbImage));
        final inputImage =
            InputImage.fromFilePath(await _writeTempJpeg(jpegBytes));

        final faces = await _faceDetector.processImage(inputImage);
        if (faces.isEmpty) {
          faceBoundingBox.value = null;
          isDetecting.value = false;
          return;
        }

        final face = faces.first;

        //Perbesar bounding box agar lebih natural
        const paddingXFactor = 0.3;
        const paddingYFactor = 0.15;

        final extraWidth = face.boundingBox.width * paddingXFactor;
        final extraHeight = face.boundingBox.height * paddingYFactor;

        final newLeft = face.boundingBox.left - extraWidth / 2;
        final newTop = face.boundingBox.top - extraHeight / 2;
        final newWidth = face.boundingBox.width + extraWidth;
        final newHeight = face.boundingBox.height + extraHeight;

        final adjustedBox = Rect.fromLTWH(
          newLeft.clamp(0.0, double.infinity),
          newTop.clamp(0.0, double.infinity),
          newWidth.clamp(0.0, double.infinity),
          newHeight.clamp(0.0, double.infinity),
        );

        faceBoundingBox.value = adjustedBox;

        // 🔄 Crop wajah untuk klasifikasi emosi
        final faceBytes = _cropFace(rgbImage, adjustedBox);
        if (faceBytes != null) {
          final result = await _classifier.predictFromBytes(faceBytes);
          if (result != null) {
            detectedEmotion.value = result.label;
            detectedConfidence.value = result.confidence;
            predictedLevel = result.level;
            debugPrint(
                "Prediksi: ${result.label}, Confidence: ${result.confidence}");
          } else {
            debugPrint("Gagal klasifikasi emosi");
          }
        } else {
          debugPrint("Gagal crop wajah");
        }
      } catch (e) {
        debugPrint("Error deteksi wajah atau prediksi: $e");
      } finally {
        isDetecting.value = false;
      }
    });
  }

  /// Konversi CameraImage YUV420 ke img.Image
  img.Image _convertYUV420ToImage(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final img.Image rgbImage = img.Image(width, height);

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvIndex = (uvRowStride * (y ~/ 2)) + (uvPixelStride * (x ~/ 2));
        final yIndex = y * yPlane.bytesPerRow + x;

        final Y = yPlane.bytes[yIndex];
        final U = uPlane.bytes[uvIndex];
        final V = vPlane.bytes[uvIndex];

        final r = (Y + 1.370705 * (V - 128)).clamp(0, 255).toInt();
        final g = (Y - 0.337633 * (U - 128) - 0.698001 * (V - 128))
            .clamp(0, 255)
            .toInt();
        final b = (Y + 1.732446 * (U - 128)).clamp(0, 255).toInt();

        rgbImage.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return rgbImage;
  }

  /// Crop wajah dari img.Image
  Uint8List? _cropFace(img.Image fullImage, Rect boundingBox) {
    try {
      int left = boundingBox.left.toInt().clamp(0, fullImage.width - 1);
      int top = boundingBox.top.toInt().clamp(0, fullImage.height - 1);
      int width = boundingBox.width.toInt().clamp(1, fullImage.width - left);
      int height = boundingBox.height.toInt().clamp(1, fullImage.height - top);

      final cropped = img.copyCrop(fullImage, left, top, width, height);
      final flipped = img.flipHorizontal(cropped); // flip untuk kamera depan
      return Uint8List.fromList(img.encodeJpg(flipped, quality: 90));
    } catch (e) {
      debugPrint("Gagal crop wajah: $e");
      return null;
    }
  }

  /// Simpan file JPG sementara untuk ML Kit
  Future<String> _writeTempJpeg(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/frame.jpg';
    final file = await File(path).writeAsBytes(bytes, flush: true);
    return file.path;
  }

  /// Simpan mood ke backend
  Future<(bool, String)> submitMood(int userId) async {
    final mood = MoodModel(
      userId: userId,
      level: predictedLevel,
      createdAt: DateTime.now(),
    );
    return await MoodRemoteDataSource.add(mood);
  }

  @override
  void dispose() {
    try {
      cameraController.value?.stopImageStream();
    } catch (e) {
      debugPrint("Stop image stream error: $e");
    }
    _detectionTimer?.cancel();
    cameraController.value?.dispose();
    _classifier.dispose();
    _faceDetector.close();
    if (Get.isRegistered<LiveCameraMoodController>()) {
      Get.delete<LiveCameraMoodController>();
    }
    super.dispose();
  }
}

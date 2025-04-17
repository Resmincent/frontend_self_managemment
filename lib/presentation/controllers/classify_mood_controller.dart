import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:self_management/data/models/mood_model.dart';

import '../../core/emotion_helper.dart';
import '../../data/datasources/mood_remote_data_source.dart';

class ClassifyMood extends GetxController {
  final EmotionClassifier _classifier = EmotionClassifier();

  var isModelLoaded = false.obs;
  var predictedEmotion = ''.obs;
  var predictedConfidence = 0.0.obs;
  int predictedLevel = 0;

  Future<void> loadModel() async {
    try {
      await _classifier.loadModel();
      isModelLoaded.value = true;
    } catch (e) {
      isModelLoaded.value = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.overlayContext != null) {
          Get.snackbar("Error", "Gagal memuat model: $e");
        } else {
          debugPrint("Gagal memuat model, overlayContext belum siap.");
        }
      });
    }
  }

  Future<void> classifyImageBytes(Uint8List bytes) async {
    final result = await _classifier.predictFromBytes(bytes);

    if (result != null) {
      predictedEmotion.value = result.label;
      predictedLevel = result.level;
      predictedConfidence.value = result.confidence;
    } else {
      predictedEmotion.value = '';
      predictedConfidence.value = 0.0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.overlayContext != null) {
          Get.snackbar("Error", "Gagal mendeteksi emosi dari gambar.");
        }
      });
    }
  }

  Future<(bool, String)> submitMood(int userId) async {
    final mood = MoodModel(
      userId: userId,
      level: predictedLevel,
      createdAt: DateTime.now(),
    );

    return await MoodRemoteDataSource.add(mood);
  }

  static void delete() {
    if (Get.isRegistered<ClassifyMood>()) {
      Get.delete<ClassifyMood>();
    }
  }
}

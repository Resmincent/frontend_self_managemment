import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import 'package:self_management/common/info.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/controllers/live_camera_mood_controller.dart';
import 'package:self_management/presentation/pages/recomedation_page.dart';

class LiveCameraPage extends StatefulWidget {
  const LiveCameraPage({super.key});
  static const routeName = '/live-camera';

  @override
  State<LiveCameraPage> createState() => _LiveCameraPageState();
}

class _LiveCameraPageState extends State<LiveCameraPage> {
  final LiveCameraMoodController _controller =
      Get.put(LiveCameraMoodController());
  final MoodTodayController _moodTodayController =
      Get.put(MoodTodayController());

  UserModel? user;

  @override
  void initState() {
    super.initState();
    Session.getUser().then((value) => setState(() => user = value));
    availableCameras().then((cameras) => _controller.initializeCamera(cameras));
  }

  @override
  void dispose() {
    if (Get.isRegistered<LiveCameraMoodController>()) {
      _controller.cameraController.value?.stopImageStream();
      _controller.cameraController.value?.dispose();
      _controller.dispose();
      Get.delete<LiveCameraMoodController>();
    }
    super.dispose();
  }

  Future<void> _saveMood() async {
    if (user == null) return;

    final result = await _controller.submitMood(user!.id);
    if (result.$1) {
      Info.success(result.$2);
      _moodTodayController.fetch(user!.id);
      if (mounted) {
        await Navigator.pushNamed(
          context,
          RecomedationPage.routeName,
          arguments: _controller.detectedEmotion.value,
        );
      }
    } else {
      Info.failed(result.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Emotion Detection'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final cameraCtrl = _controller.cameraController.value;
        if (cameraCtrl == null || !cameraCtrl.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final isFrontCamera =
            cameraCtrl.description.lensDirection == CameraLensDirection.front;
        final previewSize = cameraCtrl.value.previewSize!;
        final screenSize = MediaQuery.of(context).size;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Camera Preview
            Transform(
              alignment: Alignment.center,
              transform: isFrontCamera
                  ? Matrix4.rotationY(3.1415926535897932)
                  : Matrix4.identity(),
              child: CameraPreview(cameraCtrl),
            ),

            // Bounding box
            Obx(() {
              final rect = _controller.faceBoundingBox.value;
              if (rect == null) return const SizedBox();

              // Ukuran asli dari preview kamera
              final previewWidth = previewSize.width;
              final previewHeight = previewSize.height;

              // Ukuran layar pengguna
              final screenWidth = screenSize.width;
              final screenHeight = screenSize.height;

              // Scaling untuk orientasi portrait
              final scaleX = screenWidth / previewWidth;
              final scaleY = screenHeight / previewHeight;

              // Koordinat bounding box hasil deteksi wajah
              double left = rect.left * scaleX;
              double top = rect.top * scaleY;
              double width = rect.width * scaleX;
              double height = rect.height * scaleY;

              // Koreksi mirror untuk kamera depan
              if (isFrontCamera) {
                left = screenWidth - left - width;
              }

              return Positioned(
                left: left,
                top: top,
                width: width,
                height: height,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.lightGreenAccent, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),

            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Emotion info + save button
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Obx(() {
                final emotion = _controller.detectedEmotion.value;
                final confidence = _controller.detectedConfidence.value;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: emotion.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Emotion: $emotion',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: emotion.isNotEmpty ? _saveMood : null,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Mood'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

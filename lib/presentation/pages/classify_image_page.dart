import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/pages/recomedation_page.dart';
import '../controllers/detection_emotion_controller.dart';

class ClassifyImagePage extends StatefulWidget {
  const ClassifyImagePage({super.key});
  static const routeName = '/classify-image';

  @override
  State<ClassifyImagePage> createState() => _ClassifyImagePageState();
}

class _ClassifyImagePageState extends State<ClassifyImagePage> {
  final DetectEmotionController _controller =
      Get.put(DetectEmotionController());
  final MoodTodayController _moodTodayController =
      Get.put(MoodTodayController());

  UserModel? user;

  @override
  void initState() {
    super.initState();
    Session.getUser().then((value) {
      setState(() => user = value);
    });
    _controller.loadModel();
  }

  Future<void> _submitMood() async {
    if (_controller.labels.isNotEmpty && user != null) {
      final result = await _controller.submitMood(user!.id);
      if (result.$1) {
        Info.success(result.$2);
        _moodTodayController.fetch(user!.id);
        if (mounted) {
          await Navigator.pushNamed(
            context,
            RecomedationPage.routeName,
            arguments: _controller.labels.last,
          );
        }
      } else {
        Info.failed(result.$2);
      }
    } else {
      Get.snackbar("Error", "Belum ada emosi terdeteksi.");
    }
  }

  void _resetDetection() {
    _controller.resetDetection();
  }

  @override
  void dispose() {
    _controller.cameraController.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Emosi Real-Time'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Obx(() => IconButton(
                onPressed: _controller.labels.isNotEmpty ? _submitMood : null,
                icon: const Icon(Icons.save),
                tooltip: 'Simpan Mood',
              )),
          IconButton(
            onPressed: _resetDetection,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Deteksi',
          ),
        ],
      ),
      backgroundColor: AppColor.secondary,
      body: Obx(() {
        if (!_controller.isCameraInitialized.value ||
            _controller.cameraController.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            CameraPreview(_controller.cameraController.value!),

            // Bounding Box dan Label
            Obx(() => Stack(
                  children:
                      _controller.boundingBoxes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final box = entry.value;
                    final label = _controller.labels[index];

                    return Positioned(
                      left: box.left,
                      top: box.top,
                      width: box.width,
                      height: box.height,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 2,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.greenAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),

            // Label terakhir di atas layar
            Positioned(
              top: 16,
              left: 16,
              child: Obx(() => _controller.labels.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Terakhir: ${_controller.labels.last}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
            ),

            // Loading indikator
            if (_controller.isLoading.value)
              const Positioned(
                top: 16,
                right: 16,
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                ),
              ),
          ],
        );
      }),
    );
  }
}

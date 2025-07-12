import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/classify_mood_controller.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/pages/choose_mood_page.dart';
import 'package:self_management/presentation/pages/recomedation_page.dart';
import '../widgets/custom_button.dart';
import 'live_camera_mood_page.dart';

class ClassifyImagePage extends StatefulWidget {
  const ClassifyImagePage({super.key});
  static const routeName = '/classify-image';

  @override
  State<ClassifyImagePage> createState() => _ClassifyImagePageState();
}

class _ClassifyImagePageState extends State<ClassifyImagePage> {
  final ClassifyMood _classifyMoodController = Get.put(ClassifyMood());
  final MoodTodayController _moodTodayController =
      Get.put(MoodTodayController());

  File? _selectedImage;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    Session.getUser().then((value) {
      setState(() {
        user = value;
      });
    });

    _classifyMoodController.loadModel();
  }

  @override
  void dispose() {
    ClassifyMood.delete();
    super.dispose();
  }

  Future<void> _goToChooseMood() async {
    await Navigator.pushNamed(context, ChooseMoodPage.routeName);
  }

  Future<void> _goToLiveCamera() async {
    await Navigator.pushNamed(context, LiveCameraPage.routeName);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      final bytes = await pickedFile.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        await _classifyMoodController.classifyImageBytes(bytes);
      }
    }
  }

  Future<void> _classifyAndSaveMood() async {
    if (_selectedImage != null && user != null) {
      final result = await _classifyMoodController.submitMood(user!.id);
      if (result.$1) {
        Info.success(result.$2);
        _moodTodayController.fetch(user!.id);

        if (mounted) {
          await Navigator.pushNamed(
            context,
            RecomedationPage.routeName,
            arguments: _classifyMoodController.predictedEmotion.value,
          );
        }
      } else {
        Info.failed(result.$2);
      }
    } else {
      Get.snackbar("Error", "Please select an image first.");
    }
  }

  Widget _buildHeaderClassify() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          const Gap(16),
          const Text(
            'Detection Image',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.textTitle,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Take a picture of your face to analyze your mood',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.textTitle,
            ),
          ),
          const Gap(20),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: AppColor.colorWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '1. Pastikan kamera berada pada posisi yang stabil dan mengarah ke wajah dengan jarak yang wajar (sekitar 30–60 cm)',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '2. Gunakan pencahayaan alami atau lampu terang, dan hindari cahaya dari belakang (backlight)',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageButton(
                onTap: () => _pickImage(ImageSource.camera),
                icon: Icons.camera_alt,
                label: 'Camera',
              ),
              const Gap(20),
              _buildImageButton(
                onTap: () => _pickImage(ImageSource.gallery),
                icon: Icons.photo_library,
                label: 'Gallery',
              ),
              const Gap(20),
              _buildImageButton(
                onTap: _goToChooseMood,
                icon: Icons.mood,
                label: 'Choose Mood',
              ),
              const Gap(20),
              _buildImageButton(
                onTap: _goToLiveCamera,
                icon: Icons.videocam,
                label: 'LIVE Camera',
              ),
            ],
          ),
          const Gap(30),
          Obx(() {
            final emotion = _classifyMoodController.predictedEmotion.value;
            final confidence =
                _classifyMoodController.predictedConfidence.value;
            return emotion.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Detected Emotion: $emotion',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textTitle,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Confidence: ${(confidence * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink();
          }),
          const Gap(20),
          Obx(
            () => ButtonPrimary(
              onPressed: _classifyMoodController.isModelLoaded.value
                  ? _classifyAndSaveMood
                  : null,
              title: 'Analyze Mood',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColor.colorWhite,
              size: 28,
            ),
          ),
          const Gap(8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.textTitle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.secondary,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(20),
              _buildHeaderClassify(),
              const Gap(30),
              _buildImageSection(),
            ],
          ),
        ),
      ),
    );
  }
}

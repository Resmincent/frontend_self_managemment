import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/presentation/controllers/choose_mood_controller.dart';
import '../../common/app_color.dart';
import '../../common/info.dart';
import '../../core/session.dart';
import '../../data/models/user_model.dart';
import '../controllers/home/mood_today_controller.dart';
import '../widgets/custom_button.dart';

class ClassifyImagePage extends StatefulWidget {
  const ClassifyImagePage({super.key});

  static const routeName = '/classify-image';

  @override
  State<ClassifyImagePage> createState() => _ClassifyImagePageState();
}

class _ClassifyImagePageState extends State<ClassifyImagePage> {
  final ChooseMoodController _chooseMoodController =
      Get.put(ChooseMoodController());
  final moodTodayController = Get.put(MoodTodayController());

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
  }

  @override
  void dispose() {
    ChooseMoodController.delete();
    super.dispose();
  }

  Future<void> _goToDashboard() async {
    await Navigator.pushNamed(context, '/dashboard');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Set the image in the controller
      _chooseMoodController.setImage(_selectedImage!);
    }
  }

  Future<void> _classifyAndSaveMood() async {
    if (_selectedImage != null && user != null) {
      final result = await _chooseMoodController.classifyImageAndSave(user!.id);

      if (result.statusRequest == StatusRequest.success) {
        Info.success(result.message);
        moodTodayController.fetch(user!.id);

        await _goToDashboard();
        Get.back();
      } else {
        Info.failed(result.message);
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
            'Classify Image',
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
                  : const Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(color: Colors.grey),
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
            ],
          ),
          const Gap(40),
          Obx(
            () => ButtonPrimary(
              onPressed: () {
                _chooseMoodController.state.statusRequest ==
                        StatusRequest.loading
                    ? null
                    : _classifyAndSaveMood();
              },
              title: _chooseMoodController.state.statusRequest ==
                      StatusRequest.loading
                  ? 'Processing...'
                  : 'Analyze Mood',
            ),
          ),
          // Display detected emotion if available
          // Obx(
          //   () => _chooseMoodController.predictedEmotion != null
          //       ? Padding(
          //           padding: const EdgeInsets.only(top: 20),
          //           child: Text(
          //             'Detected emotion: ${_chooseMoodController.predictedEmotion}',
          //             style: const TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold,
          //               color: AppColor.textTitle,
          //             ),
          //           ),
          //         )
          //       : const SizedBox.shrink(),
          // ),
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
              fontSize: 14,
              color: AppColor.textTitle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

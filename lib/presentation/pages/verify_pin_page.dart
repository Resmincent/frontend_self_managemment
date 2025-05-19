import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';
import 'package:self_management/presentation/widgets/input_pin.dart';

import '../../common/app_color.dart';
import '../../common/info.dart';
import '../widgets/custom_button.dart';
import '../widgets/top_clip_pointer.dart';

class VerifyPinPage extends StatefulWidget {
  const VerifyPinPage({super.key});

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  final pinController = TextEditingController();
  final isLoading = false.obs;

  Future<void> _verifyPin() async {
    final inputPin = pinController.text.trim();

    if (inputPin.isEmpty) {
      Info.failed('PIN is required');
      return;
    }

    isLoading.value = true;
    final isValid = await Session.verifyPin(inputPin);
    isLoading.value = false;

    if (isValid) {
      Info.success('PIN verified successfully');
      Get.offAll(() => const DashboardPage());
    } else {
      Info.failed('Invalid PIN');
    }
  }

  Widget _buildHeaderVerifyPin() {
    return Stack(
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: TopClipPointer(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(MediaQuery.paddingOf(context).top),
            Image.asset(
              'assets/images/logo_auth.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const Gap(45),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify PIN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Please enter your PIN to verify',
                    style: TextStyle(
                      color: AppColor.textBody,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildVerifyForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          InputPin(
            controller: pinController,
            hintText: "Enter PIN",
            icon: 'assets/images/password.png',
          ),
          const Gap(32),
          Obx(() {
            return isLoading.value
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ButtonPrimary(
                      onPressed: _verifyPin,
                      title: 'Verify',
                    ),
                  );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _buildHeaderVerifyPin(),
                      const Gap(40),
                      _buildVerifyForm(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

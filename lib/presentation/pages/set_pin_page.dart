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

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  Future<void> _savePin() async {
    String pin = pinController.text;
    String confirmPin = confirmPinController.text;

    if (pin.isEmpty) {
      Info.failed('PIN is required');
      return;
    }

    if (confirmPin.isEmpty) {
      Info.failed('Confirm PIN is required');
      return;
    }

    if (pin.length < 6) {
      Info.failed('PIN must be at least 6 digits');
      return;
    }

    if (pin != confirmPin) {
      Info.failed('PIN do not match');
      return;
    }
    await Session.saveUserPin(pin);
    Info.success('PIN saved successfully');
    Get.offAll(() => const DashboardPage());
  }

  Widget _buildHeaderSetPin() {
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
                    'Set PIN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Please enter your PIN',
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

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          InputPin(
            controller: pinController,
            hintText: "Input Pin",
            icon: 'assets/images/password.png',
          ),
          const Gap(24),
          InputPin(
            controller: confirmPinController,
            hintText: "Confirm Pin",
            icon: 'assets/images/password.png',
          ),
          const Gap(32),
          Obx(() {
            final isLoading = false.obs;

            return isLoading.value
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ButtonPrimary(
                      onPressed: _savePin,
                      title: 'Set PIN',
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
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _buildHeaderSetPin(),
                      const Gap(40),
                      _buildRegisterForm(),
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

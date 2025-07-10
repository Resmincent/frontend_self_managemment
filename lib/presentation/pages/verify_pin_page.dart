import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:number_pad_keyboard/number_pad_keyboard.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';

import '../../common/app_color.dart';
import '../../common/info.dart';
import '../widgets/top_clip_pointer.dart';

class VerifyPinPage extends StatefulWidget {
  const VerifyPinPage({super.key});

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  final pinControllers = List.generate(6, (_) => TextEditingController());
  final isLoading = false.obs;

  void _addDigit(int digit) {
    for (int i = 0; i < pinControllers.length; i++) {
      if (pinControllers[i].text.isEmpty) {
        setState(() {
          pinControllers[i].text = digit.toString();
        });
        break;
      }
    }
  }

  void _backSpace() {
    for (int i = pinControllers.length - 1; i >= 0; i--) {
      if (pinControllers[i].text.isNotEmpty) {
        setState(() {
          pinControllers[i].text = '';
        });
        break;
      }
    }
  }

  Future<void> _verifyPin() async {
    final inputPin = pinControllers.map((controller) => controller.text).join();

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
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: pinControllers[index],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.transparent,
                    counterText: "",
                  ),
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28),
                  obscureText: true,
                  obscuringCharacter: '*',
                ),
              );
            }),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: NumberPadKeyboard(
              backgroundColor: Colors.transparent,
              addDigit: _addDigit,
              backspace: _backSpace,
              enterButtonText: 'ENTER',
              enterButtonTextStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
              onEnter: () {
                _verifyPin();
              },
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Gap(20),
                SafeArea(child: _buildHeaderVerifyPin()),
                const Gap(20),
                _buildVerifyForm(),
              ],
            );
          },
        ),
      ),
    );
  }
}

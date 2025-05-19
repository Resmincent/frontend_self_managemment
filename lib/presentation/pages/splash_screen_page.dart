import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/pages/login_page.dart';

import 'set_pin_page.dart';
import 'verify_pin_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateFromSplash();
  }

  Future<void> _navigateFromSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = await Session.getUser();
    final isExpired = await Session.isSessionExpired();

    if (user == null || isExpired) {
      // Belum login atau session habis → LoginPage
      Get.offAll(() => const LoginPage());
      return;
    }

    final storedPin = await Session.getUserPin();

    if (storedPin == null || storedPin.isEmpty) {
      // Sudah login tapi belum set PIN → SetPinPage
      Get.offAll(() => const SetPinPage());
    } else {
      // Sudah login dan sudah ada PIN → Verifikasi PIN
      Get.offAll(() => const VerifyPinPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

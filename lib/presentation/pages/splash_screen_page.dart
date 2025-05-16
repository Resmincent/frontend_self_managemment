import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';
import 'package:self_management/presentation/pages/login_page.dart';

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

    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else if (isExpired) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const DashboardPage());
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

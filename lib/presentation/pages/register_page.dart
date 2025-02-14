import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/presentation/controllers/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerController = Get.put(RegisterController());

  @override
  void dispose() {
    RegisterController.delete();
    super.dispose();
  }

  Widget _buildRegisterForm() {
    return SizedBox();
  }

  Widget _buildHeaderRegister() {
    return SizedBox();
  }

  Widget _buildRegisterNavigation() {
    return SizedBox();
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
                      _buildHeaderRegister(),
                      const Gap(40),
                      _buildRegisterForm(),
                    ],
                  ),
                  _buildRegisterNavigation(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

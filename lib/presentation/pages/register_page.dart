import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/presentation/controllers/register_controller.dart';
import 'package:self_management/presentation/pages/login_page.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/input_auth.dart';
import 'package:self_management/presentation/widgets/top_clip_pointer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerController = Get.put(RegisterController());
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    if (name == '') {
      Info.failed('Name is be filled');
      return;
    }

    if (email == '') {
      Info.failed('Email is be filled');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Info.failed('Email is not valid');
      return;
    }

    if (password == '') {
      Info.failed('Password is be filled');
      return;
    }

    if (password.length < 6) {
      Info.failed('Password must be at least 6 characters');
      return;
    }

    final state = await registerController.executeRequest(
      name,
      email,
      password,
    );

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      Info.success(state.message);
      return;
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  @override
  void dispose() {
    RegisterController.delete();
    super.dispose();
  }

  Widget _buildHeaderRegister() {
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
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Please enter your data to register',
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
          InputAuth(
            controller: nameController,
            hintText: 'Full Name',
            icon: "assets/images/user.png",
          ),
          const Gap(24),
          InputAuth(
            controller: emailController,
            hintText: 'Email',
            icon: "assets/images/email.png",
          ),
          const Gap(24),
          InputAuth(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
            icon: "assets/images/password.png",
          ),
          const Gap(32),
          Obx(() {
            if (registerController.state.statusRequest ==
                StatusRequest.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              width: double.infinity,
              child: ButtonPrimary(
                onPressed: register,
                title: 'Register',
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoginNavigation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColor.textBody,
                ),
              ),
              const Gap(4),
              InkWell(
                onTap: _goToLogin,
                child: const Text(
                  'Login Here',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                      _buildHeaderRegister(),
                      const Gap(40),
                      _buildRegisterForm(),
                    ],
                  ),
                  _buildLoginNavigation(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

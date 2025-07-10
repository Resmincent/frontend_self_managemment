import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/presentation/controllers/login_controller.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';
import 'package:self_management/presentation/pages/register_page.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/input_auth.dart';
import 'package:self_management/presentation/widgets/top_clip_pointer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = Get.put(LoginController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

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

    final state = await loginController.executeRequest(
      email,
      password,
    );

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      Info.success(state.message);
      if (mounted) {
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
      return;
    }
  }

  @override
  void dispose() {
    LoginController.delete();
    super.dispose();
  }

  void _goToRegister() async {
    await Navigator.pushReplacementNamed(context, RegisterPage.routeName);
  }

  Widget _buildHeaderLogin() {
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
                    'Log In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Please enter your account to login',
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

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
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
            if (loginController.state.statusRequest == StatusRequest.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              width: double.infinity,
              child: ButtonPrimary(
                onPressed: login,
                title: 'Login',
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRegisterNavigation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don’t have an account?',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColor.textBody,
                ),
              ),
              const Gap(4),
              InkWell(
                onTap: _goToRegister,
                child: const Text(
                  'Register Here',
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
    return SafeArea(
      child: Scaffold(
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
                        _buildHeaderLogin(),
                        const Gap(40),
                        _buildLoginForm(),
                        _buildRegisterNavigation(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

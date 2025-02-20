import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:d_info/d_info.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/widgets/bottom_clip_pointer.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/top_clip_pointer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> logout() async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Logout',
      'Yes to confir',
    );
    if (yes ?? false) {
      Session.removeUser();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => route.settings.name == '/dashboard',
        );
      }
    }
  }

  Widget _buildProfile() {
    return FutureBuilder(
      future: Session.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        String name = user?.name ?? '';
        String email = user?.email ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/profile.png'),
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primary,
                  width: 4,
                ),
              ),
            ),
            const Gap(16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textTitle,
              ),
            ),
            const Gap(4),
            Text(
              email,
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textBody,
              ),
            ),
            const Gap(40),
            SizedBox(
              width: 140,
              child: ButtonThird(
                onPressed: logout,
                title: 'Logout',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Material(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () async {
              await Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const ImageIcon(
                AssetImage('assets/images/arrow_left.png'),
                size: 24,
                color: AppColor.colorWhite,
              ),
            ),
          ),
        ),
        const Gap(16),
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.textTitle,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: TopClipPointer(),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: BottomClipPointer(),
          ),
          Positioned(
            top: 210,
            left: 0,
            right: 0,
            child: _buildProfile(),
          ),
          Positioned(
            top: 58,
            left: 20,
            right: 0,
            child: _buildHeader(),
          ),
        ],
      ),
    );
  }
}

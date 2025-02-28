import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/choose_mood_controller.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';

class ChooseMoodPage extends StatefulWidget {
  const ChooseMoodPage({super.key});

  static const routeName = '/choose-mood';

  @override
  State<ChooseMoodPage> createState() => _ChooseMoodPageState();
}

class _ChooseMoodPageState extends State<ChooseMoodPage> {
  final chooseMood = Get.put(ChooseMoodController());
  final moodTodayController = Get.put(MoodTodayController());

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

  Future<void> choose() async {
    if (user == null) return;

    int userId = user!.id;
    final state = await chooseMood.executeRequest(userId);

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      Info.success(state.message);
      moodTodayController.fetch(userId);

      await _goToDashboard();
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: _goToDashboard,
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
          const Gap(60),
          Align(
            alignment: Alignment.center,
            child: Text(
              '${user?.name ?? ''}, what is your mood now?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: AppColor.textTitle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChooseMood() {
    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: PageController(initialPage: 2, viewportFraction: 0.65),
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        onPageChanged: (index) {
          setState(() {
            chooseMood.level = index + 1;
          });
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String moodAssets = 'assets/images/mood_big_${index + 1}.png';

          return Center(
            child: Transform.rotate(
              angle: pi / 3,
              child: Container(
                width: 212,
                height: 212,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.colorWhite,
                ),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: pi / -3,
                  child: Image.asset(
                    moodAssets,
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChoosenButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ButtonPrimary(
        onPressed: choose,
        title: 'Choose',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(60),
          _buildHeader(),
          const Gap(40),
          _buildChooseMood(),
          const Gap(90),
          _buildChoosenButton(),
        ],
      ),
    );
  }
}

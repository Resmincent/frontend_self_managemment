import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/mood_model.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/home/agenda_today_controller.dart';
import 'package:self_management/presentation/controllers/home/expense_today_controller.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final moodTodayController = Get.put(MoodTodayController());
  final agendaTodayController = Get.put(AgendaTodayController());
  final expenseTodayController = Get.put(ExpenseTodayController());

  referesh() async {
    final user = await Session.getUser();
    int userId = user!.id;
    Future.wait([
      moodTodayController.fetch(userId),
      agendaTodayController.fetch(userId),
      expenseTodayController.fetch(userId),
    ]);
  }

  @override
  void initState() {
    referesh();
    super.initState();
  }

  @override
  void dispose() {
    MoodTodayController.delete();
    AgendaTodayController.delete();
    ExpenseTodayController.delete();
    super.dispose();
  }

  void _goToChatAI() {
    Get.toNamed('/chat-ai');
  }

  void _goToProfile() {
    Get.toNamed('/profile');
  }

  void _goToMood() {
    Get.toNamed('/mood');
  }

  Widget _buildHeaderHome() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: AppColor.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(52),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProfile(),
              IconButton.filled(
                constraints: BoxConstraints.tight(const Size(48, 48)),
                color: AppColor.textWhite,
                style: const ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(AppColor.secondary),
                ),
                onPressed: _goToChatAI,
                icon: const ImageIcon(
                  AssetImage('assets/images/chat-ai.png'),
                  size: 24,
                ),
              ),
            ],
          ),
          const Gap(26),
          _buildTitle(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Mood',
          style: TextStyle(
            fontWeight: FontWeight.w200,
            color: AppColor.textBody,
          ),
        ),
        const Gap(6),
        SizedBox(
          width: 252,
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'How do you feel about your ',
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.w300,
                    color: AppColor.textTitle,
                  ),
                ),
                TextSpan(
                  text: 'current mood?',
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
        _buildButtonMood(),
        const Gap(24),
      ],
    );
  }

  Widget _buildButtonMood() {
    return InkWell(
      onTap: _goToMood,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: 50,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Mood..',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textTitle,
                ),
              ),
              ImageIcon(
                AssetImage('assets/images/arrow_right.png'),
                color: AppColor.textTitle,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        GestureDetector(
          onTap: _goToProfile,
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.png',
              width: 48,
              height: 48,
            ),
          ),
        ),
        const Gap(16),
        FutureBuilder(
          future: Session.getUser(),
          builder: (context, snapshot) {
            UserModel? user = snapshot.data;
            String name = user?.name ?? '';
            return Text(
              'Hi, $name',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: AppColor.textTitle,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoodToday() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Mood Today',
            style: TextStyle(
              color: AppColor.textTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(24),
          Obx(() {
            final state = moodTodayController.state;
            final statusRequest = state.statusRequest;

            if (statusRequest == StatusRequest.init) {
              return const SizedBox();
            }

            if (statusRequest == StatusRequest.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (statusRequest == StatusRequest.failed) {
              return ResponseFailed(
                message: state.message,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              );
            }

            final list = state.moods;

            if (list.isEmpty) {
              return const ResponseFailed(
                message: 'No Mood Yet',
                margin: EdgeInsets.symmetric(horizontal: 20),
              );
            }
            return SizedBox(
              height: 90,
              child: ListView.builder(
                itemCount: list.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  MoodModel mood = list[index];
                  return _buildMoodItem(mood);
                },
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _buildMoodItem(MoodModel mood) {
    String moodAssets = 'assets/images/mood_big_${mood.level}.png';
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColor.textWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        moodAssets,
        height: 60,
        width: 60,
      ),
    );
  }

  Widget _buildAgendaToday() {
    return const SizedBox();
  }

  Widget _buildExpenseToday() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => referesh(),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          _buildHeaderHome(),
          const Gap(36),
          _buildMoodToday(),
          const Gap(36),
          _buildAgendaToday(),
          const Gap(36),
          _buildExpenseToday(),
          const Gap(140),
        ],
      ),
    );
  }
}

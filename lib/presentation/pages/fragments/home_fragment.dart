import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/data/models/expense_modal.dart';
import 'package:self_management/data/models/mood_model.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/home/agenda_today_controller.dart';
import 'package:self_management/presentation/controllers/home/expense_today_controller.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/chat_ai_page.dart';
import 'package:self_management/presentation/pages/choose_mood_page.dart';
import 'package:self_management/presentation/pages/profile_page.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

import '../expenses/all_expense_page.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final moodTodayController = Get.put(MoodTodayController());
  final agendaTodayController = Get.put(AgendaTodayController());
  final expenseTodayController = Get.put(ExpenseTodayController());

  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

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

  Future<void> _goToChatAI() async {
    await Navigator.pushReplacementNamed(context, ChatAiPage.routeName);
  }

  Future<void> _goToProfile() async {
    await Navigator.pushReplacementNamed(context, ProfilePage.routeName);
  }

  Future<void> _goToMood() async {
    await Navigator.pushReplacementNamed(context, ChooseMoodPage.routeName);
  }

  Future<void> _goToAgendaAll() async {
    await Navigator.pushReplacementNamed(context, AllAgendaPage.routeName);
  }

  Future<void> _goToExpenseAll() async {
    await Navigator.pushReplacementNamed(context, AllExpensePage.routeName);
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

  Widget _buildTitleMood() {
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

  Widget _cardAgendaToday(AgendaModel agenda) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.textWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agenda.title,
                    style: const TextStyle(
                      color: AppColor.textTitle,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.primary,
                        ),
                        child: Text(
                          DateFormat('HH:mm').format(agenda.startEvent),
                          style: const TextStyle(
                            color: AppColor.textTitle,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          agenda.category,
                          style: const TextStyle(
                            color: AppColor.textTitle,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const ImageIcon(
              AssetImage('assets/images/arrow_right.png'),
              color: AppColor.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardExpenseToday(ExpenseModal expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.textWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      color: AppColor.textTitle,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.secondary),
                        ),
                        child: Text(
                          formatRupiah(expense.expense),
                          style: const TextStyle(color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.primary,
                        ),
                        child: Text(
                          DateFormat.yMd().add_jm().format(expense.dateExpense),
                          style: const TextStyle(color: AppColor.textTitle),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          expense.category,
                          style: const TextStyle(
                            color: AppColor.textTitle,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            const ImageIcon(
              AssetImage('assets/images/arrow_right.png'),
              color: AppColor.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
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
          _buildTitleMood(),
        ],
      ),
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

  Widget _buildAgendaToday() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Agenda Today',
                style: TextStyle(
                  color: AppColor.textTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _goToAgendaAll,
                child: const Text(
                  'All Agenda',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const Gap(24),
          Obx(() {
            final state = agendaTodayController.state;
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

            final list = state.agendas;

            if (list.isEmpty) {
              return const ResponseFailed(
                message: 'No Agenda Yet',
                margin: EdgeInsets.symmetric(horizontal: 20),
              );
            }
            return SizedBox(
              height: list.length * 125.0,
              child: ListView.builder(
                itemCount: list.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  AgendaModel agenda = list[index];
                  return _cardAgendaToday(agenda);
                },
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _buildExpenseToday() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Expense Today',
                style: TextStyle(
                  color: AppColor.textTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _goToExpenseAll,
                child: const Text(
                  'All Expense',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const Gap(24),
          Obx(() {
            final state = expenseTodayController.state;
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

            final list = state.expenses;

            if (list.isEmpty) {
              return const ResponseFailed(
                message: 'No Expense Yet',
                margin: EdgeInsets.symmetric(horizontal: 20),
              );
            }
            return SizedBox(
              height: list.length * 160.0,
              child: ListView.builder(
                itemCount: list.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  ExpenseModal expense = list[index];
                  return _cardExpenseToday(expense);
                },
              ),
            );
          })
        ],
      ),
    );
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

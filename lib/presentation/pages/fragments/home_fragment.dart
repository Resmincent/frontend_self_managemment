import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/data/models/expense_modal.dart';
import 'package:self_management/data/models/income_model.dart';
import 'package:self_management/data/models/mood_model.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:self_management/presentation/controllers/home/agenda_today_controller.dart';
import 'package:self_management/presentation/controllers/home/expense_today_controller.dart';
import 'package:self_management/presentation/controllers/home/mood_today_controller.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/detail_agenda_page.dart';
import 'package:self_management/presentation/pages/chat_ai_page.dart';
import 'package:self_management/presentation/pages/choose_mood_page.dart';
import 'package:self_management/presentation/pages/incomes/all_income_page.dart';
import 'package:self_management/presentation/pages/pomodoro/pomodoro_timer_page.dart';
import 'package:self_management/presentation/pages/profile_page.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

import '../../controllers/home/income_today_controller.dart';
import '../expenses/all_expense_page.dart';
import '../expenses/detail_expense_page.dart';
import '../incomes/detail_income_page.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final moodTodayController = Get.put(MoodTodayController());
  final agendaTodayController = Get.put(AgendaTodayController());
  final expenseTodayController = Get.put(ExpenseTodayController());
  final incomeTodayController = Get.put(IncomeTodayController());

  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  refresh() async {
    final user = await Session.getUser();
    int userId = user!.id;
    moodTodayController.fetch(userId);
    agendaTodayController.fetch(userId);
    expenseTodayController.fetch(userId);
    incomeTodayController.fetch(userId);
  }

  refreshAgenda() {
    Session.getUser().then((user) {
      int userId = user!.id;
      agendaTodayController.fetch(userId);
    });
  }

  refreshExpense() {
    Session.getUser().then((user) {
      int userId = user!.id;
      expenseTodayController.fetch(userId);
    });
  }

  refreshIncome() {
    Session.getUser().then((user) {
      int userId = user!.id;
      incomeTodayController.fetch(userId);
    });
  }

  @override
  void initState() {
    refresh();
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
    await Navigator.pushNamed(context, ChatAiPage.routeName);
  }

  Future<void> _goToPomodoroTimer() async {
    await Navigator.pushNamed(context, PomodoroTimerPage.routeName);
  }

  Future<void> _goToProfile() async {
    await Navigator.pushNamed(context, ProfilePage.routeName);
  }

  Future<void> _goToMood() async {
    await Navigator.pushNamed(context, ChooseMoodPage.routeName);
  }

  Future<void> _goToAgendaAll() async {
    await Navigator.pushNamed(context, AllAgendaPage.routeName);
  }

  Future<void> _goToExpenseAll() async {
    await Navigator.pushNamed(context, AllExpensePage.routeName);
  }

  Future<void> _goToIncomeAll() async {
    await Navigator.pushNamed(context, AllIncomePage.routeName);
  }

  Future<void> _goToDetailAgenda(int id) async {
    await Navigator.popAndPushNamed(
      context,
      DetailAgendaPage.routeName,
      arguments: id,
    ).then((value) {
      if (value == null) return;
      if (value == 'refresh_agenda') {
        refreshAgenda();
      }
    });
  }

  Future<void> _goToDetailExpense(int id) async {
    await Navigator.popAndPushNamed(
      context,
      DetailExpensePage.routeName,
      arguments: id,
    ).then((value) {
      if (value == null) return;
      if (value == 'refresh_expense') {
        refreshExpense();
      }
    });
  }

  Future<void> _goToDetailIncome(int id) async {
    await Navigator.popAndPushNamed(
      context,
      DetailIncomePage.routeName,
      arguments: id,
    ).then((value) {
      if (value == null) return;
      if (value == 'refresh_income') {
        refreshIncome();
      }
    });
  }

  Widget _buildProfile() {
    return Row(
      children: [
        GestureDetector(
          onTap: _goToProfile,
          child: FutureBuilder(
            future: Session.getUser(),
            builder: (context, snapshot) {
              UserModel? user = snapshot.data;
              String name = user?.name ?? '';
              return Text(
                'Hi, $name',
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textTitle,
                ),
              );
            },
          ),
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
        color: AppColor.colorWhite,
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
                  color: AppColor.primary,
                ),
              ),
              ImageIcon(
                AssetImage('assets/images/arrow_right.png'),
                color: AppColor.primary,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardExpenseToday(ExpenseModal expense) {
    return GestureDetector(
      onTap: () => _goToDetailExpense(expense.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.colorWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    expense.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textTitle,
                    ),
                  ),
                ),
                const Gap(10),
                Chip(
                  label: Text(formatRupiah(expense.expense)),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.colorWhite,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                Chip(
                  label: Text(
                    DateFormat('MM/d/y').format(expense.dateExpense),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                const Gap(10),
                Chip(
                  label: Text(
                    expense.category,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                const Spacer(),
                const ImageIcon(
                  AssetImage('assets/images/arrow_right.png'),
                  color: AppColor.primary,
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _cardIncomeToday(IncomeModel income) {
    return GestureDetector(
      onTap: () => _goToDetailIncome(income.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.colorWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    income.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textTitle,
                    ),
                  ),
                ),
                const Gap(10),
                Chip(
                  label: Text(formatRupiah(income.amount)),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.colorWhite,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                Chip(
                  label: Text(
                    DateFormat('MM/d/y').format(income.dateIncome),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                const Gap(10),
                Chip(
                  label: Text(
                    income.category,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                const Spacer(),
                const ImageIcon(
                  AssetImage('assets/images/arrow_right.png'),
                  color: AppColor.primary,
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _cardAgendaToday(AgendaModel agenda) {
    return GestureDetector(
      onTap: () => _goToDetailAgenda(agenda.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.colorWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agenda.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.textTitle,
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Chip(
                  label: Text(
                    DateFormat('H:mm').format(agenda.startEvent),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                const Gap(10),
                Chip(
                  label: Text(
                    agenda.category,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                const Spacer(),
                const ImageIcon(
                  AssetImage('assets/images/arrow_right.png'),
                  color: AppColor.primary,
                  size: 20,
                ),
              ],
            )
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    color: AppColor.secondary,
                    onPressed: _goToPomodoroTimer,
                    icon: const ImageIcon(
                      AssetImage('assets/images/tomato.png'),
                    ),
                  ),
                  IconButton.filled(
                    constraints: BoxConstraints.tight(const Size(48, 48)),
                    color: AppColor.secondary,
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(AppColor.colorWhite),
                    ),
                    onPressed: _goToChatAI,
                    icon: const ImageIcon(
                      AssetImage('assets/images/chat-ai.png'),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
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

            return Column(
              children: list.map((agenda) => _cardAgendaToday(agenda)).toList(),
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

            return Column(
              children:
                  list.map((expense) => _cardExpenseToday(expense)).toList(),
            );
          })
        ],
      ),
    );
  }

  Widget _buildIncomeToday() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Income Today',
                style: TextStyle(
                  color: AppColor.textTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _goToIncomeAll,
                child: const Text(
                  'All Income',
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
            final state = incomeTodayController.state;
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

            final list = state.incomes;

            if (list.isEmpty) {
              return const ResponseFailed(
                message: 'No Income Yet',
                margin: EdgeInsets.symmetric(horizontal: 20),
              );
            }

            return Column(
              children: list.map((income) => _cardIncomeToday(income)).toList(),
            );
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              _buildHeaderHome(),
              const Gap(10),
              _buildMoodToday(),
              const Gap(10),
              _buildAgendaToday(),
              const Gap(10),
              _buildExpenseToday(),
              const Gap(10),
              _buildIncomeToday(),
              const Gap(120),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:self_management/data/models/solution_model.dart';
import 'package:self_management/presentation/pages/agendas/add_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/detail_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/update_agenda_page.dart';
import 'package:self_management/presentation/pages/chat_ai_page.dart';
import 'package:self_management/presentation/pages/choose_mood_page.dart';
import 'package:self_management/presentation/pages/classify_image_page.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';
import 'package:self_management/presentation/pages/expenses/add_expense_page.dart';
import 'package:self_management/presentation/pages/expenses/all_expense_page.dart';
import 'package:self_management/presentation/pages/expenses/detail_expense_page.dart';
import 'package:self_management/games/flappy_dash/flappy_dash_page.dart';
import 'package:self_management/presentation/pages/incomes/add_income_page.dart';
import 'package:self_management/presentation/pages/login_page.dart';
import 'package:self_management/presentation/pages/profile_page.dart';
import 'package:self_management/presentation/pages/recomedation_page.dart';
import 'package:self_management/presentation/pages/register_page.dart';
import 'package:self_management/presentation/pages/journals/add_journal_page.dart';
import 'package:self_management/presentation/pages/journals/detail_journal_page.dart';
import 'package:self_management/presentation/pages/solutions/add_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/detail_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/update_solution_page.dart';
import 'package:self_management/presentation/pages/splash_screen_page.dart';

import 'games/service_locator.dart';
import 'games/snake/snake_game_page.dart';
import 'presentation/pages/fragments/solution_fragment.dart';
import 'presentation/pages/incomes/all_income_page.dart';
import 'presentation/pages/incomes/detail_income_page.dart';
import 'presentation/pages/journals/update_journal_page.dart';
import 'presentation/pages/pomodoro/pomodoro_timer_page.dart';

void main() async {
  await setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.surface,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          surface: AppColor.surface,
          surfaceContainer: AppColor.surfaceContainer,
          error: AppColor.error,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        shadowColor: AppColor.primary.withOpacity(0.3),
      ),
      home: const SplashScreen(),
      routes: {
        //Dashboard
        DashboardPage.routeName: (context) => const DashboardPage(),

        //Auth
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),

        //Agenda
        AllAgendaPage.routeName: (context) => const AllAgendaPage(),
        AddAgendaPage.routeName: (context) => const AddAgendaPage(),
        DetailAgendaPage.routeName: (context) {
          int agendaId = ModalRoute.settingsOf(context)?.arguments as int;
          return DetailAgendaPage(agendaId: agendaId);
        },
        UpdateAgendaPage.routeName: (context) {
          AgendaModel agenda =
              ModalRoute.settingsOf(context)?.arguments as AgendaModel;
          return UpdateAgendaPage(agenda: agenda);
        },

        //Expense
        AllExpensePage.routeName: (context) => const AllExpensePage(),
        AddExpensePage.routeName: (context) => const AddExpensePage(),
        DetailExpensePage.routeName: (context) {
          int expenseId = ModalRoute.settingsOf(context)?.arguments as int;
          return DetailExpensePage(expenseId: expenseId);
        },
        //Solution
        AddSolutionPage.routeName: (context) => const AddSolutionPage(),
        DetailSolutionPage.routeName: (context) {
          int solutionId = ModalRoute.settingsOf(context)?.arguments as int;
          return DetailSolutionPage(solutionId: solutionId);
        },
        UpdateSolutionPage.routeName: (context) {
          SolutionModel solution =
              ModalRoute.settingsOf(context)?.arguments as SolutionModel;
          return UpdateSolutionPage(solution: solution);
        },
        SolutionFragment.routeName: (context) => const SolutionFragment(),

        //Choose mood
        ChooseMoodPage.routeName: (context) => const ChooseMoodPage(),
        ClassifyImagePage.routeName: (context) => const ClassifyImagePage(),

        //chat ai
        ChatAiPage.routeName: (context) => const ChatAiPage(),

        //Pomodoro Timer
        PomodoroTimerPage.routeName: (context) => const PomodoroTimerPage(),

        //Profile
        ProfilePage.routeName: (context) => const ProfilePage(),

        //Games
        FlappyDashPage.routeName: (context) => const FlappyDashPage(),
        SnakeGamePage.routeName: (context) => const SnakeGamePage(),

        //Journal
        AddJournalPage.routeName: (context) => const AddJournalPage(),
        DetailJournalPage.routeName: (context) {
          int journalId = ModalRoute.settingsOf(context)?.arguments as int;
          return DetailJournalPage(journalId: journalId);
        },
        UpdateJournalPage.routeName: (context) {
          JournalModel journal =
              ModalRoute.settingsOf(context)?.arguments as JournalModel;
          return UpdateJournalPage(journal: journal);
        },

        RecomedationPage.routeName: (context) {
          final emotion = ModalRoute.of(context)?.settings.arguments as String;
          return RecomedationPage(emotion: emotion);
        },

        //Income
        AllIncomePage.routeName: (context) => const AllIncomePage(),
        AddIncomePage.routeName: (context) => const AddIncomePage(),
        DetailIncomePage.routeName: (context) {
          int incomeId = ModalRoute.settingsOf(context)?.arguments as int;
          return DetailIncomePage(incomeId: incomeId);
        },
      },
    );
  }
}

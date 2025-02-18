import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/pages/agendas/add_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/detail_agenda_page.dart';
import 'package:self_management/presentation/pages/chat_ai_page.dart';
import 'package:self_management/presentation/pages/choose_mood_page.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';
import 'package:self_management/presentation/pages/expenses/add_expense_page.dart';
import 'package:self_management/presentation/pages/expenses/all_expense_page.dart';
import 'package:self_management/presentation/pages/expenses/detail_expense_page.dart';
import 'package:self_management/presentation/pages/login_page.dart';
import 'package:self_management/presentation/pages/profile_page.dart';
import 'package:self_management/presentation/pages/register_page.dart';
import 'package:self_management/presentation/pages/solutions/add_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/detail_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/self_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/update_solution_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: FutureBuilder(
        future: Session.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data == null) {
            return const LoginPage();
          }
          return const DashboardPage();
        },
      ),
      routes: {
        //Dashboard
        DashboardPage.routeName: (context) => const DashboardPage(),

        //Auth
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),

        //Agenda
        AllAgendaPage.routeName: (context) => const AllAgendaPage(),
        AddAgendaPage.routeName: (context) => const AddAgendaPage(),
        DetailAgendaPage.routeName: (context) => const DetailAgendaPage(),

        //Expense
        AllExpensePage.routeName: (context) => const AllExpensePage(),
        AddExpensePage.routeName: (context) => const AddExpensePage(),
        DetailExpensePage.routeName: (context) => const DetailExpensePage(),

        //Solution
        SelfSolutionPage.routeName: (context) => const SelfSolutionPage(),
        AddSolutionPage.routeName: (context) => const AddSolutionPage(),
        DetailSolutionPage.routeName: (context) => const DetailSolutionPage(),
        UpdateSolutionPage.routeName: (context) => const UpdateSolutionPage(),

        //Choose mood
        ChooseMoodPage.routeName: (context) => const ChooseMoodPage(),

        //chat ai
        ChatAiPage.routeName: (context) => const ChatAiPage(),

        //Profile
        ProfilePage.routeName: (context) => const ProfilePage(),
      },
    );
  }
}

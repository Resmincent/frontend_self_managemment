import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/chat_ai_page.dart';
import 'package:self_management/presentation/pages/choose_mood_page.dart';
import 'package:self_management/presentation/pages/dashboard_page.dart';
import 'package:self_management/presentation/pages/expenses/all_expense_page.dart';
import 'package:self_management/presentation/pages/login_page.dart';
import 'package:self_management/presentation/pages/profile_page.dart';
import 'package:self_management/presentation/pages/register_page.dart';

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
        LoginPage.routeName: (context) => const LoginPage(),
        DashboardPage.routeName: (context) => const DashboardPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        AllAgendaPage.routeName: (context) => const AllAgendaPage(),
        AllExpensePage.routeName: (context) => const AllExpensePage(),
        ChooseMoodPage.routeName: (context) => const ChooseMoodPage(),
        ChatAiPage.routeName: (context) => const ChatAiPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
      },
    );
  }
}

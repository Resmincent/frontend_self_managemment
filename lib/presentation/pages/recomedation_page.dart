import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/fragments/solution_fragment.dart';
import 'package:self_management/presentation/pages/incomes/all_income_page.dart';
import 'chat_ai_page.dart';
import 'dashboard_page.dart';
import 'expenses/all_expense_page.dart';
import 'journals/add_journal_page.dart';

class RecomedationPage extends StatefulWidget {
  const RecomedationPage({super.key, required this.emotion});
  static const routeName = '/recomendation';

  final String emotion;

  @override
  State<RecomedationPage> createState() => _RecomedationPageState();
}

class _RecomedationPageState extends State<RecomedationPage> {
  List<String> getRecommendations(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'angry':
        return [
          'Chatbot AI Gemini',
          'Self-Solution',
          'Jurnal Pribadi',
        ];
      case 'happy':
        return [
          'Mengelola Pengeluaran',
          'Mengelola Pemasukan',
          'Jurnal Pribadi',
          'Mengelola Agenda',
        ];
      case 'neutral':
        return [
          'Jurnal Pribadi',
          'Chatbot AI Gemini',
          'Self-Solution',
          'Mengelola Agenda',
          'Mengelola Pengeluaran',
          'Mengelola Pemasukan',
        ];
      default:
        return ['Tidak ada rekomendasi tersedia'];
    }
  }

  Widget _buildModuleButton(BuildContext context, String moduleName) {
    String? route;
    switch (moduleName.toLowerCase()) {
      case 'mengelola agenda':
        route = AllAgendaPage.routeName;
        break;
      case 'jurnal pribadi':
        route = AddJournalPage.routeName;
        break;
      case 'chatbot ai gemini':
        route = ChatAiPage.routeName;
        break;
      case 'mengelola pengeluaran':
        route = AllExpensePage.routeName;
        break;
      case 'mengelola pemasukan':
        route = AllIncomePage.routeName;
        break;
      case 'self-solution':
        route = SolutionFragment.routeName;
        break;
      case 'semua modul (bebas akses)':
      case 'eksplorasi diri':
        route = DashboardPage.routeName;
        break;
    }

    return route != null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, route!),
            child: Text(
              moduleName,
              style: const TextStyle(fontSize: 16),
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _goToDashboard() async {
    await Navigator.pushNamed(context, DashboardPage.routeName);
  }

  Widget _buildHeader() {
    return Row(
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
              child: const Icon(Icons.arrow_back, color: AppColor.colorWhite),
            ),
          ),
        ),
        const Gap(16),
        const Expanded(
          child: Text(
            'Rekomendasi Modul',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.textTitle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final emotion = widget.emotion;
    final recommendations = getRecommendations(emotion);

    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Gap(30),
                Text(
                  'Emosi Terdeteksi: ${emotion[0].toUpperCase()}${emotion.substring(1)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textTitle,
                  ),
                ),
                const Gap(24),
                const Text(
                  'Modul yang Disarankan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColor.textTitle,
                  ),
                ),
                const Gap(12),
                ...recommendations.map(
                  (modul) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _buildModuleButton(context, modul),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

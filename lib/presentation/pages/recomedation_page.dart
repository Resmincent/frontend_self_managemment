import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/presentation/pages/agendas/all_agenda_page.dart';
import 'package:self_management/presentation/pages/fragments/solution_fragment.dart';
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
        return ['Manajemen Waktu', 'Self-Solution', 'Jurnal Pribadi'];
      case 'sad':
        return ['Jurnal Pribadi', 'Chatbot AI Gemini', 'Self-Solution'];
      case 'disgust':
      case 'disgusted':
        return ['Jurnal Pribadi', 'Chatbot AI Gemini'];
      case 'happy':
        return ['Manajemen Keuangan', 'Jurnal Pribadi', 'Manajemen Waktu'];
      case 'neutral':
        return ['Jurnal Pribadi', 'Eksplorasi Diri'];
      case 'fear':
      case 'fearful':
        return ['Self-Solution', 'Chatbot AI Gemini', 'Manajemen Waktu'];
      case 'surprise':
      case 'surprised':
        return ['Jurnal Pribadi', 'Chatbot AI Gemini'];
      default:
        return ['Tidak ada rekomendasi tersedia'];
    }
  }

  String getModuleGoal(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'angry':
        return 'Mengurangi tekanan akibat jadwal padat, membantu refleksi sumber kemarahan, dan mencari solusi mandiri.';
      case 'sad':
        return 'Menyalurkan emosi, memperoleh dukungan percakapan, serta meningkatkan motivasi dan pemahaman diri.';
      case 'disgust':
      case 'disgusted':
        return 'Membantu mengekspresikan kejengkelan atau kekecewaan dalam bentuk tulisan atau dialog reflektif.';
      case 'happy':
        return 'Mendorong produktivitas dan mencatat momen positif untuk menjaga keseimbangan emosional.';
      case 'neutral':
        return 'Meningkatkan kesadaran diri dan membentuk rutinitas pengelolaan diri yang stabil.';
      case 'fear':
      case 'fearful':
        return 'Memberikan strategi mengatasi kekhawatiran dan kecemasan melalui solusi dan pendampingan.';
      case 'surprise':
      case 'surprised':
        return 'Mengelola reaksi terhadap perubahan mendadak dan mencatat respon untuk analisis diri.';
      default:
        return 'Tujuan modul tidak tersedia.';
    }
  }

  Widget _buildModuleButton(BuildContext context, String moduleName) {
    String? route;
    switch (moduleName.toLowerCase()) {
      case 'manajemen waktu':
        route = AllAgendaPage.routeName;
        break;
      case 'jurnal pribadi':
        route = AddJournalPage.routeName;
        break;
      case 'chatbot ai gemini':
        route = ChatAiPage.routeName;
        break;
      case 'manajemen keuangan':
        route = AllExpensePage.routeName;
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
    final goal = getModuleGoal(emotion);

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
                const Gap(12),
                const Text(
                  'Tujuan Modul:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColor.textTitle,
                  ),
                ),
                const Gap(4),
                Text(
                  goal,
                  style:
                      const TextStyle(fontSize: 14, color: AppColor.textBody),
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

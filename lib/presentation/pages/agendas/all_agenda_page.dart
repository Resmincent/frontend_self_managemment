import 'package:flutter/material.dart';
import 'package:self_management/common/app_color.dart';

class AllAgendaPage extends StatefulWidget {
  const AllAgendaPage({super.key});

  static const routeName = '/all-agenda';

  @override
  State<AllAgendaPage> createState() => _AllAgendaPageState();
}

class _AllAgendaPageState extends State<AllAgendaPage> {
  Future<void> _goToAddAgenda() async {}

  AppBar _headerAgenda() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'All Agenda',
        style: TextStyle(
          fontSize: 16,
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton.filled(
          constraints: BoxConstraints.tight(const Size(48, 48)),
          style: const ButtonStyle(
            overlayColor: WidgetStatePropertyAll(AppColor.secondary),
          ),
          onPressed: _goToAddAgenda,
          icon: const ImageIcon(
            AssetImage('assets/images/add_agenda.png'),
            size: 24,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerAgenda(),
    );
  }
}

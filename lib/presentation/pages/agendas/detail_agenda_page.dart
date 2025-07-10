import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/presentation/controllers/agenda/delete_agenda_controller.dart';
import 'package:self_management/presentation/pages/agendas/update_agenda_page.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

import '../../../common/enums.dart';
import '../../controllers/agenda/detail_agenda_controller.dart';

class DetailAgendaPage extends StatefulWidget {
  const DetailAgendaPage({super.key, required this.agendaId});

  final int agendaId;

  static const routeName = '/detail-agenda';

  @override
  State<DetailAgendaPage> createState() => _DetailAgendaPageState();
}

class _DetailAgendaPageState extends State<DetailAgendaPage> {
  final detailAgendaController = Get.put(DetailAgendaController());
  final deleteAgendaController = Get.put(DeleteAgendaController());

  @override
  void initState() {
    detailAgendaController.fetch(widget.agendaId);
    super.initState();
  }

  @override
  void dispose() {
    DetailAgendaController.delete();
    DeleteAgendaController.delete();
    super.dispose();
  }

  Future<void> _goToUpdateAgenda(AgendaModel agenda) async {
    await Navigator.pushNamed(context, UpdateAgendaPage.routeName,
        arguments: agenda);
  }

  void deleteAgenda() async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'Click yes to confirm delete',
    );
    if (yes ?? false) {
      final state =
          await deleteAgendaController.executeRequest(widget.agendaId);

      if (state.statusRequest == StatusRequest.failed) {
        Info.failed(state.message);
        return;
      }

      if (state.statusRequest == StatusRequest.success) {
        Info.success(state.message);
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/all-agenda',
            (route) => route.settings.name == '/dashboard',
            arguments: 'refresh_agenda',
          );
        }
        return;
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => route.settings.name == '/dashboard',
        );
      }
    }
  }

  Widget _buildHeaderTitle(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.colorWhite,
            ),
          ),
          const Gap(13),
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.colorWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textTitle,
          ),
        ),
      ),
    );
  }

  Widget _buildCardDate(DateTime startEvent, DateTime endTime) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ImageIcon(
                  AssetImage('assets/images/calendar.png'),
                  color: AppColor.primary,
                  size: 20,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, dd/MM/yyyy, HH:mm').format(startEvent),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textBody,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            Row(
              children: [
                const ImageIcon(
                  AssetImage('assets/images/calendar.png'),
                  color: AppColor.primary,
                  size: 20,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, dd/MM/yyyy, HH:mm').format(endTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textBody,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDescription(String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.textTitle,
              ),
            ),
            const Gap(12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColor.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonDelete(int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ButtonDelete(
        onPressed: deleteAgenda,
        title: 'Delete',
      ),
    );
  }

  Widget _buildButtonUpdate(AgendaModel agenda) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ButtonPrimary(
        onPressed: () => _goToUpdateAgenda(agenda),
        title: 'Update Agenda',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 170,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
            Obx(
              () {
                final state = detailAgendaController.state;
                final statusRequest = state.statusRequest;

                if (statusRequest == StatusRequest.init) {
                  return const Center(
                    child: BackButton(),
                  );
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

                AgendaModel agenda = state.agenda!;
                return ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    const Gap(20),
                    _buildHeaderTitle(agenda.category),
                    const Gap(60),
                    _buildCardTitle(agenda.title),
                    const Gap(30),
                    _buildCardDate(agenda.startEvent, agenda.endEvent),
                    const Gap(30),
                    _buildCardDescription(agenda.description ?? '-'),
                    const Gap(30),
                    _buildButtonDelete(agenda.id),
                    const Gap(20),
                    _buildButtonUpdate(agenda),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

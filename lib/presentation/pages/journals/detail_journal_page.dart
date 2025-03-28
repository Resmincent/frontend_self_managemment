import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:self_management/presentation/controllers/journal/delete_journal_controller.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../controllers/journal/detail_journal_controller.dart';
import '../../widgets/response_failed.dart';

class DetailJournalPage extends StatefulWidget {
  const DetailJournalPage({super.key, required this.journalId});

  static const routeName = "/detail-journal";

  final int journalId;

  @override
  State<DetailJournalPage> createState() => _DetailJournalPageState();
}

class _DetailJournalPageState extends State<DetailJournalPage> {
  final detailJournal = Get.put(DetailJournalController());
  final deleteJournal = Get.put(DeleteJournalController());

  @override
  void initState() {
    detailJournal.fetch(widget.journalId);
    super.initState();
  }

  @override
  void dispose() {
    DetailJournalController.delete();
    DeleteJournalController.delete();
    super.dispose();
  }

  void deleteExpense() async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'Click yes to confirm delete',
    );
    if (yes ?? false) {
      final state = await deleteJournal.executeRequest(widget.journalId);

      if (state.statusRequest == StatusRequest.failed) {
        Info.failed(state.message);
        return;
      }

      if (state.statusRequest == StatusRequest.success) {
        Info.success(state.message);
        if (mounted) {
          Navigator.of(context).pop();
        }
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
              Navigator.of(context).pop();
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

  Widget _buildCardDate(
    DateTime createdAt,
  ) {
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
                    DateFormat('EEEE, dd/MM/yyyy').format(createdAt),
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

  Widget _buildCardDescription(String content) {
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
              'Content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.textTitle,
              ),
            ),
            const Gap(12),
            Text(
              content,
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
        onPressed: deleteExpense,
        title: 'Delete',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              final state = detailJournal.state;
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

              JournalModel journal = state.journal!;
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Gap(50),
                  _buildHeaderTitle(journal.category),
                  const Gap(30),
                  _buildCardTitle(journal.title),
                  const Gap(30),
                  _buildCardDate(journal.createdAt),
                  const Gap(30),
                  _buildCardDescription(journal.content),
                  const Gap(30),
                  _buildButtonDelete(journal.id),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

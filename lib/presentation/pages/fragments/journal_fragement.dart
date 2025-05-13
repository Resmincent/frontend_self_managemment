import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:self_management/presentation/controllers/journal/all_journal_controller.dart';
import 'package:self_management/presentation/pages/journals/add_journal_page.dart';
import 'package:self_management/presentation/pages/journals/detail_journal_page.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../core/session.dart';
import '../../widgets/response_failed.dart';

class JournalFragement extends StatefulWidget {
  const JournalFragement({super.key});

  static const routeName = '/journal';

  @override
  State<JournalFragement> createState() => _JournalFragementState();
}

class _JournalFragementState extends State<JournalFragement> {
  final journalController = Get.put(AllJournalController());
  final searchController = TextEditingController();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void search() {
    final query = searchController.text;

    if (query == '') return;

    Session.getUser().then((user) {
      int userId = user!.id;
      journalController.search(userId, query);
    });
  }

  @override
  void dispose() {
    AllJournalController.delete();
    super.dispose();
  }

  refresh() {
    Session.getUser().then((user) {
      int userId = user!.id;
      journalController.fetch(userId);
    });
  }

  Future<void> _goToAddJournal() async {
    await Navigator.pushNamed(context, AddJournalPage.routeName);
    refresh();
  }

  Future<void> _goToDetailJournal(int id) async {
    await Navigator.pushNamed(context, DetailJournalPage.routeName,
        arguments: id);
  }

  Widget _buildHeaderJournal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            Gap(10),
            Text(
              'Write your journal here',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColor.textBody,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filled(
              constraints: BoxConstraints.tight(const Size(48, 48)),
              color: AppColor.colorWhite,
              style: const ButtonStyle(
                overlayColor: WidgetStatePropertyAll(AppColor.secondary),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.task_alt_outlined,
                size: 24,
              ),
            ),
            const Gap(12),
            IconButton.filled(
              constraints: BoxConstraints.tight(const Size(48, 48)),
              color: AppColor.colorWhite,
              style: const ButtonStyle(
                overlayColor: WidgetStatePropertyAll(AppColor.secondary),
              ),
              onPressed: _goToAddJournal,
              icon: const ImageIcon(
                AssetImage('assets/images/add_solution.png'),
                size: 24,
                color: AppColor.colorWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonSearch() {
    return TextFormField(
      controller: searchController,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.colorWhite,
      ),
      cursorColor: AppColor.secondary,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: search,
          child: const UnconstrainedBox(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: ImageIcon(
                AssetImage('assets/images/search.png'),
                color: AppColor.colorWhite,
                size: 24,
              ),
            ),
          ),
        ),
        fillColor: AppColor.primary,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        hintText: 'Search your journal..',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColor.colorWhite,
        ),
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      final state = journalController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.init) {
        return const SizedBox();
      }

      if (statusRequest == StatusRequest.loading) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (statusRequest == StatusRequest.failed) {
        return SizedBox(
          height: 200,
          child: ResponseFailed(
            message: state.message,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      }

      final list = state.journals;

      if (list.isEmpty) {
        return const SizedBox(
          height: 200,
          child: ResponseFailed(
            message: 'No Solution Yet',
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      }

      return Expanded(
        child: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          itemBuilder: (context, index) {
            JournalModel journalModel = list[index];
            return _buildCardJournal(journalModel);
          },
        ),
      );
    });
  }

  Widget _buildCardJournal(JournalModel journalModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _goToDetailJournal(journalModel.id),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.colorWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 55),
                    child: Text(
                      journalModel.title.isNotEmpty
                          ? journalModel.title
                          : 'Content',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textTitle,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    journalModel.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              width: 70,
              height: 36,
              child: Text(
                textAlign: TextAlign.right,
                journalModel.category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Gap(55),
            _buildHeaderJournal(),
            const Gap(30),
            _buildButtonSearch(),
            const Gap(16),
            _buildList(),
            const Gap(140)
          ],
        ),
      ),
    );
  }
}

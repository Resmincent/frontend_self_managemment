import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:self_management/presentation/controllers/journal/all_journal_controller.dart';
import 'package:self_management/presentation/controllers/journal/update_journal_controller.dart';
import 'package:self_management/presentation/widgets/custom_input.dart';

import '../../../common/constans.dart';
import '../../../common/info.dart';
import '../../widgets/custom_button.dart';

class UpdateJournalPage extends StatefulWidget {
  const UpdateJournalPage({super.key, required this.journal});

  final JournalModel journal;

  static const routeName = "/update-journal";

  @override
  State<UpdateJournalPage> createState() => _UpdateJournalPageState();
}

class _UpdateJournalPageState extends State<UpdateJournalPage> {
  final allJournalController = Get.put(AllJournalController());
  final updateJournalController = Get.put(UpdateJournalController());

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final categoryController =
      TextEditingController(text: Constans.typeJournal.first);

  @override
  void initState() {
    titleController.text = widget.journal.title;
    descController.text = widget.journal.content;
    categoryController.text = widget.journal.category;

    super.initState();
  }

  @override
  dispose() {
    UpdateJournalController.delete();
    super.dispose();
  }

  Future<void> updateJournal() async {
    final title = titleController.text;
    final category = categoryController.text;
    final content = descController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
      return;
    }

    if (category.isEmpty) {
      Info.failed('Category must be filled');
    }

    if (content.isEmpty) {
      Info.failed('Content must be filled');
      return;
    }

    int userId = (await Session.getUser())!.id;

    final journal = JournalModel(
      id: widget.journal.id,
      userId: userId,
      category: category,
      title: title,
      content: content,
      createdAt: widget.journal.createdAt,
    );

    final state = await updateJournalController.executeRequest(journal);
    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      allJournalController.fetch(userId);
      Info.success(state.message);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.primary,
            ),
          ),
          const Text(
            'Add Journal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage('assets/images/add_agenda.png'),
              size: 24,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Title',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: titleController,
          hintText: 'Title ... ',
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildTypeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        DropdownButtonFormField<String>(
          value: categoryController.text,
          items: Constans.typeJournal.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textBody,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            categoryController.text = value;
          },
          icon: const ImageIcon(
            AssetImage('assets/images/category.png'),
            size: 24,
            color: AppColor.primary,
          ),
          decoration: InputDecoration(
            fillColor: AppColor.colorWhite,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.all(20),
            hintStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: AppColor.textBody,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColor.secondary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Content',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: descController,
          hintText: 'Write your journal details...',
          maxLines: 10,
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final state = updateJournalController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: updateJournal,
        title: 'Update Changes',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(50),
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Gap(10),
                _buildTitleInput(),
                const Gap(10),
                _buildTypeInput(),
                const Gap(10),
                _buildContentInput(),
                const Gap(40),
                _buildAddButton(),
                const Gap(60),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:self_management/presentation/controllers/journal/all_safe_place_controller.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../common/info.dart';
import '../../../core/session.dart';
import '../../controllers/journal/add_journal_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  static const routeName = "/add-safe-place";

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final addJournalController = Get.put(AddJournalController());
  final allJournalController = Get.put(AllJournalController());

  final titleController = TextEditingController();
  String selectedType = 'journal'; // Default type
  final descController = TextEditingController();

  Future<void> addJournal() async {
    final title = titleController.text;
    final type = selectedType; // Use the selected type
    final content = descController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
      return;
    }

    if (content.isEmpty) {
      Info.failed('Content must be filled');
      return;
    }

    int userId = (await Session.getUser())!.id;

    final journal = JournalModel(
      id: 0,
      userId: userId,
      title: title,
      type: type, // Use the selected type
      content: content,
      createdAt: DateTime.now(),
    );

    final state = await addJournalController.executeRequest(journal);

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

  @override
  void dispose() {
    AddJournalController.delete();
    super.dispose();
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
            'Add Safe Place',
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
          value: selectedType,
          items: ['journal', 'audio'].map((e) {
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
            setState(() {
              selectedType = value;
            });
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
          'Content ...',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: descController,
          hintText: 'Write your safe place details...',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final state = addJournalController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: addJournal,
        title: 'Add now',
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

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/constans.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/presentation/controllers/agenda/add_agenda_controller.dart';
import 'package:self_management/presentation/controllers/agenda/all/all_agenda_controller.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/custom_input.dart';

class AddAgendaPage extends StatefulWidget {
  const AddAgendaPage({super.key});

  static const routeName = '/add-agenda';

  @override
  State<AddAgendaPage> createState() => _AddAgendaPageState();
}

class _AddAgendaPageState extends State<AddAgendaPage> {
  final addAgendaController = Get.put(AddAgendaController());
  final allAgendaController = Get.put(AllAgendaController());

  final titleController = TextEditingController();
  final categoryController =
      TextEditingController(text: Constans.categories.first);

  final startEventController = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  );
  final endEventController = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  );
  final descController = TextEditingController();

  Future<void> chooseDateTime(TextEditingController controller) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year),
      lastDate: DateTime(now.year + 1, now.month),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    controller.text =
        DateFormat('yyyy-MM-dd HH:mm', 'id_ID').format(selectedDateTime);
  }

  Future<void> addNow() async {
    final title = titleController.text;
    final category = categoryController.text;
    final startEvent = startEventController.text;
    final endEvent = endEventController.text;
    final description = descController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
      return;
    }

    if (category.isEmpty) {
      Info.failed('Category must be filled');
      return;
    }

    if (startEvent.isEmpty) {
      Info.failed('Start Event must be filled');
      return;
    }

    if (DateTime.tryParse(startEvent) == null) {
      Info.failed('Start Event not valid');
      return;
    }

    if (endEvent.isEmpty) {
      Info.failed('End Event must be filled');
      return;
    }

    if (DateTime.tryParse(endEvent) == null) {
      Info.failed('Start Event not valid');
      return;
    }

    if (description.isEmpty) {
      Info.failed('Description must be filled');
      return;
    }

    final startEventDate = DateTime.parse(startEvent);
    final endEventDate = DateTime.parse(endEvent);

    if (startEventDate.isAfter(endEventDate)) {
      Info.failed("End Event must be after start event");
      return;
    }

    if (endEventDate.difference(startEventDate).inMinutes < 30) {
      Info.failed('Minimum range event is 30 minutes');
      return;
    }

    int userId = (await Session.getUser())!.id;

    final agenda = AgendaModel(
      id: 0,
      title: title,
      category: category,
      startEvent: startEventDate,
      endEvent: endEventDate,
      description: description,
      userId: userId,
    );

    final state = await addAgendaController.executeRequest(agenda);

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      allAgendaController.fetch(userId);
      Info.success(state.message);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
      return;
    }
  }

  @override
  void dispose() {
    AddAgendaController.delete();
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
            'Add Agenda',
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
          hintText: 'Belanja Kebutuhan',
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildCategoryInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        DropdownButtonFormField(
          value: categoryController.text,
          items: Constans.categories.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
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

  Widget _buildStartEventInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start Event',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          suffixOnTap: () => chooseDateTime(startEventController),
          controller: startEventController,
          hintText: '2025-01-01 00:00',
          maxLines: 1,
          suffixIcon: 'assets/images/calendar.png',
        ),
      ],
    );
  }

  Widget _buildEndEventInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'End Event',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          suffixOnTap: () => chooseDateTime(endEventController),
          controller: endEventController,
          hintText: '2025-01-01 00:00',
          maxLines: 1,
          suffixIcon: 'assets/images/calendar.png',
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: descController,
          hintText: 'Saya ingin membeli kebutuhan',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final state = addAgendaController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: addNow,
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
                _buildCategoryInput(),
                const Gap(10),
                _buildStartEventInput(),
                const Gap(10),
                _buildEndEventInput(),
                const Gap(10),
                _buildDescriptionInput(),
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

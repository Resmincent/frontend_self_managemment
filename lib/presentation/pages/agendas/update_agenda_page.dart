import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/presentation/controllers/agenda/update_agenda_controller.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/custom_input.dart';

import '../../../common/app_color.dart';
import '../../../common/constans.dart';
import '../../../common/enums.dart';
import '../../../common/info.dart';
import '../../../core/session.dart';
import '../../controllers/agenda/all/all_agenda_controller.dart';

class UpdateAgendaPage extends StatefulWidget {
  const UpdateAgendaPage({super.key, required this.agenda});

  final AgendaModel agenda;
  static const routeName = '/update-agenda';

  @override
  State<UpdateAgendaPage> createState() => _UpdateAgendaPageState();
}

class _UpdateAgendaPageState extends State<UpdateAgendaPage> {
  final allAgendaController = Get.put(AllAgendaController());
  final updateAgendaController = Get.put(UpdateAgendaController());

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

  @override
  void initState() {
    titleController.text = widget.agenda.title;
    categoryController.text = widget.agenda.category;
    startEventController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.agenda.startEvent);
    endEventController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.agenda.endEvent);
    descController.text = widget.agenda.description!;
    super.initState();
  }

  Future<void> chooseDateTime(TextEditingController controller) async {
    final now = DateTime.now();
    final pickedData = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year),
      lastDate: DateTime(now.year + 1, now.month),
    );

    if (pickedData == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (pickedTime == null) {
      return;
    }

    controller.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime(
      pickedData.year,
      pickedData.month,
      pickedData.day,
      pickedTime.hour,
      pickedTime.minute,
    ));
  }

  @override
  void dispose() {
    UpdateAgendaController.delete();
    super.dispose();
  }

  Future<void> updateAgenda() async {
    final title = titleController.text;
    final category = categoryController.text;
    final startEvent = startEventController.text;
    final endEvent = endEventController.text;
    final description = descController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
    }

    if (category.isEmpty) {
      Info.failed('Category must be filled');
    }

    if (startEvent.isEmpty) {
      Info.failed('Start Event must be filled');
    }

    if (DateTime.tryParse(startEvent) == null) {
      Info.failed('Start Event not valid');
    }

    if (endEvent.isEmpty) {
      Info.failed('End Event must be filled');
    }

    if (DateTime.tryParse(endEvent) == null) {
      Info.failed('Start Event not valid');
    }

    if (description.isEmpty) {
      Info.failed('Description must be filled');
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
      id: widget.agenda.id,
      userId: userId,
      category: category,
      title: title,
      startEvent: startEventDate,
      endEvent: endEventDate,
      description: description,
    );

    final state = await updateAgendaController.executeRequest(agenda);
    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }
    if (state.statusRequest == StatusRequest.success) {
      allAgendaController.fetch(userId);
      Info.success(state.message);
      if (!mounted) return;
      Navigator.pop(context);
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
            'Update Agenda',
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

  Widget _buildUpdateButton() {
    return Obx(() {
      final state = updateAgendaController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: updateAgenda,
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
                _buildCategoryInput(),
                const Gap(10),
                _buildStartEventInput(),
                const Gap(10),
                _buildEndEventInput(),
                const Gap(10),
                _buildDescriptionInput(),
                const Gap(40),
                _buildUpdateButton(),
                const Gap(60),
              ],
            ),
          )
        ],
      ),
    );
  }
}

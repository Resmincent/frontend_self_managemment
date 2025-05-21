import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/constans.dart';
import 'package:self_management/data/models/income_model.dart';
import 'package:self_management/presentation/controllers/income/add_income_controller.dart';
import 'package:self_management/presentation/controllers/income/all_income_controller.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../common/info.dart';
import '../../../core/session.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  static const String routeName = 'add-income';
  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final addIncomeController = Get.put(AddIncomeController());
  final allIncomeController = Get.put(AllIncomeController());

  final titleController = TextEditingController();
  final categoryController = TextEditingController(
    text: Constans.typeIncome.first,
  );
  final amountController = TextEditingController();
  final descController = TextEditingController();
  final dateIncomeController = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  );

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

  Future<void> addIncome() async {
    final title = titleController.text;
    final category = categoryController.text;
    final incomeValue = amountController.text;
    final dateIncome = dateIncomeController.text;
    final description = descController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
      return;
    }

    if (incomeValue.isEmpty) {
      Info.failed('Expense must be filled');
      return;
    }

    if (category.isEmpty) {
      Info.failed('Category must be filled');
      return;
    }

    if (dateIncome.isEmpty) {
      Info.failed('Date must be filled');
      return;
    }

    if (DateTime.tryParse(dateIncome) == null) {
      Info.failed('Date not valid');
      return;
    }

    final startDate = DateTime.parse(dateIncome);
    final incomeAmount = double.tryParse(incomeValue);

    int userId = (await Session.getUser())!.id;

    final income = IncomeModel(
      id: 0,
      userId: userId,
      title: title,
      category: category,
      amount: incomeAmount!,
      dateIncome: startDate,
      description: description,
    );

    final state = await addIncomeController.executeRequest(income);

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      allIncomeController.fetch(userId);
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
    AddIncomeController.delete();
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
            'Add Income',
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
          hintText: 'Enter title',
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
          items: Constans.typeIncome.map((e) {
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

  Widget _buildDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date & Time',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          suffixOnTap: () => chooseDateTime(dateIncomeController),
          controller: dateIncomeController,
          hintText: '2025-01-01 00:00',
          maxLines: 1,
          suffixIcon: 'assets/images/calendar.png',
        ),
      ],
    );
  }

  Widget _buildIncomeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: amountController,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColor.textBody,
          ),
          maxLines: 1,
          decoration: InputDecoration(
            fillColor: AppColor.colorWhite,
            filled: true,
            hintText: '30000',
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
          hintText: 'Enter description',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final state = addIncomeController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: addIncome,
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
                _buildDateInput(),
                const Gap(10),
                _buildIncomeInput(),
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

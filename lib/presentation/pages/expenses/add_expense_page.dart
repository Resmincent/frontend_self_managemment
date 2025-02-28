import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/data/models/expense_modal.dart';
import 'package:self_management/presentation/controllers/expense/add_expense_controller.dart';
import 'package:self_management/presentation/controllers/expense/all_expense_controller.dart';

import '../../../common/app_color.dart';
import '../../../common/constans.dart';
import '../../../common/enums.dart';
import '../../../common/info.dart';
import '../../../core/session.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  static const routeName = "add-expense";

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final addExpenseController = Get.put(AddExpenseController());
  final allExpenseController = Get.put(AllExpenseController());

  final titleController = TextEditingController();
  final expenseController = TextEditingController();

  final descController = TextEditingController();
  final categoryController =
      TextEditingController(text: Constans.categories.first);
  final dateExpenseController = TextEditingController(
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

  Future<void> addExpense() async {
    final title = titleController.text;
    final category = categoryController.text;
    final expenseValue = expenseController.text;
    final dateExpense = dateExpenseController.text;
    final description = descController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
    }

    if (expenseValue.isEmpty) {
      Info.failed('Expense must be filled');
    }

    if (category.isEmpty) {
      Info.failed('Category must be filled');
    }

    if (dateExpense.isEmpty) {
      Info.failed('Date must be filled');
    }

    if (DateTime.tryParse(dateExpense) == null) {
      Info.failed('Date not valid');
    }

    if (description.isEmpty) {
      Info.failed('Description must be filled');
    }

    final startDate = DateTime.parse(dateExpense);
    final expenseAmount = double.tryParse(expenseValue);

    int userId = (await Session.getUser())!.id;

    final expense = ExpenseModal(
      id: 0,
      userId: userId,
      title: title,
      category: category,
      expense: expenseAmount!,
      dateExpense: startDate,
      description: description,
    );

    final state = await addExpenseController.executeRequest(expense);

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      allExpenseController.fetch(userId);
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
    AddExpenseController.delete();
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
            'Add Expense',
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

  Widget _buildDateInput() {
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
          suffixOnTap: () => chooseDateTime(dateExpenseController),
          controller: dateExpenseController,
          hintText: '2025-01-01 00:00',
          maxLines: 1,
          suffixIcon: 'assets/images/calendar.png',
        ),
      ],
    );
  }

  Widget _buildExpenseInput() {
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
          controller: expenseController,
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
          hintText: 'Saya ingin membeli kebutuhan',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final state = addExpenseController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: addExpense,
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
                _buildExpenseInput(),
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

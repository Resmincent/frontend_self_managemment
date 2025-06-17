import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/data/models/expense_modal.dart';
import 'package:self_management/presentation/controllers/expense/all_expense_controller.dart';
import 'package:self_management/presentation/pages/expenses/add_expense_page.dart';
import 'package:self_management/presentation/pages/expenses/detail_expense_page.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../core/session.dart';
import '../../widgets/response_failed.dart';

class AllExpensePage extends StatefulWidget {
  const AllExpensePage({super.key});

  static const routeName = "/all-expense";
  @override
  State<AllExpensePage> createState() => _AllExpensePageState();
}

class _AllExpensePageState extends State<AllExpensePage> {
  final allExpenseController = Get.put(AllExpenseController());

  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  refresh() {
    Session.getUser().then((user) {
      int userId = user!.id;
      allExpenseController.fetch(userId);
    });
  }

  Future<void> _goToAddExpense() async {
    await Navigator.pushNamed(context, AddExpensePage.routeName);
    refresh();
  }

  Future<void> _goToDetailExpense(int id) async {
    await Navigator.popAndPushNamed(
      context,
      DetailExpensePage.routeName,
      arguments: id,
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    AllExpenseController.delete();
    super.dispose();
  }

  Widget _buildHeaderExpenses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () async {
            await Navigator.pushReplacementNamed(context, '/dashboard');
          },
          icon: const ImageIcon(
            AssetImage('assets/images/arrow_left.png'),
            size: 24,
            color: AppColor.primary,
          ),
        ),
        const Text(
          'All Expense',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        IconButton(
          onPressed: _goToAddExpense,
          icon: const ImageIcon(
            AssetImage('assets/images/add_agenda.png'),
            size: 24,
            color: AppColor.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Obx(() {
      final state = allExpenseController.state;
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

      final list = allExpenseController.filteredExpenses;

      if (list.isEmpty) {
        return const SizedBox(
          height: 200,
          child: ResponseFailed(
            message: 'No Expenses Yet',
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      }

      return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        itemBuilder: (context, index) {
          ExpenseModal expense = list[index];
          return _cardExpenseToday(expense);
        },
      );
    });
  }

  Widget _cardExpenseToday(ExpenseModal expense) {
    return GestureDetector(
      onTap: () => _goToDetailExpense(expense.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.colorWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    expense.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textTitle,
                    ),
                  ),
                ),
                const Gap(20),
                Chip(
                  label: Text(formatRupiah(expense.expense)),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.colorWhite,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    expense.category,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    DateFormat('MM/dd/yy').format(expense.dateExpense),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardExpenseMonth() {
    return Obx(() {
      final selectedMonth = allExpenseController.selectedMonth.value;
      final selectedYear = allExpenseController.selectedYear.value;

      final list = allExpenseController.filteredExpenses;

      double totalMonthExpense = 0;
      for (var expense in list) {
        totalMonthExpense += expense.expense;
      }

      final monthName = DateFormat.MMMM('id_ID')
          .format(DateTime(selectedYear, selectedMonth));

      return Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$monthName $selectedYear',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.colorWhite,
                ),
              ),
              Text(
                formatRupiah(totalMonthExpense),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.colorWhite,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCardExpenseDay() {
    final now = DateTime.now();

    return Obx(() {
      final state = allExpenseController.state;
      final list = state.expenses;

      double totalDayExpense = 0;
      for (var expense in list) {
        if (expense.dateExpense.day == now.day &&
            expense.dateExpense.month == now.month &&
            expense.dateExpense.year == now.year) {
          totalDayExpense += expense.expense;
        }
      }

      return Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ImageIcon(
                AssetImage('assets/images/dollar.png'),
                size: 44,
                color: AppColor.primary,
              ),
              Text(
                formatRupiah(totalDayExpense),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilterMonthYear() {
    return Obx(() {
      return Row(
        children: [
          // Dropdown Bulan
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: allExpenseController.selectedMonth.value,
              items: List.generate(12, (i) {
                final month = i + 1;
                final monthName =
                    DateFormat.MMMM('id_ID').format(DateTime(0, month));
                return DropdownMenuItem(
                  value: month,
                  child: Text(
                    monthName,
                    style: const TextStyle(
                      color: AppColor.primary,
                    ),
                  ),
                );
              }),
              onChanged: (val) {
                if (val != null) {
                  allExpenseController.selectedMonth.value = val;
                }
              },
            ),
          ),
          const Gap(16),
          // Dropdown Tahun
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: allExpenseController.selectedYear.value,
              items: List.generate(5, (i) {
                final year = DateTime.now().year - i;
                return DropdownMenuItem(
                  value: year,
                  child: Text(
                    '$year',
                    style: const TextStyle(
                      color: AppColor.primary,
                    ),
                  ),
                );
              }),
              onChanged: (val) {
                if (val != null) {
                  allExpenseController.selectedYear.value = val;
                }
              },
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(16),
                _buildHeaderExpenses(),
                const Gap(16),
                _buildFilterMonthYear(),
                const Gap(16),
                _buildCardExpenseMonth(),
                const Gap(10),
                _buildCardExpenseDay(),
                const Gap(16),
                _buildList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

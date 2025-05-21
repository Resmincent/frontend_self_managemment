import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/data/models/income_model.dart';
import 'package:self_management/presentation/controllers/income/all_income_controller.dart';
import 'package:self_management/presentation/pages/incomes/add_income_page.dart';
import 'package:self_management/presentation/pages/incomes/detail_income_page.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../core/session.dart';
import '../../controllers/expense/all_expense_controller.dart';
import '../../widgets/response_failed.dart';

class AllIncomePage extends StatefulWidget {
  const AllIncomePage({super.key});

  static const String routeName = 'all-income';
  @override
  State<AllIncomePage> createState() => _AllIncomePageState();
}

class _AllIncomePageState extends State<AllIncomePage> {
  final allIncomeController = Get.put(AllIncomeController());
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
      allIncomeController.fetch(userId);
      allExpenseController.fetch(userId);
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    AllIncomeController.delete();
    AllExpenseController.delete();
    super.dispose();
  }

  Future<void> _goToAddIncome() async {
    await Navigator.pushNamed(context, AddIncomePage.routeName);
    refresh();
  }

  Future<void> _goToDetailIncome(int id) async {
    await Navigator.popAndPushNamed(
      context,
      DetailIncomePage.routeName,
      arguments: id,
    );
  }

  Widget _buildHeaderIncomes() {
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
          'All Incomes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        IconButton(
          onPressed: _goToAddIncome,
          icon: const ImageIcon(
            AssetImage('assets/images/add_agenda.png'),
            size: 24,
            color: AppColor.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterMonthYear() {
    return Obx(() {
      return Row(
        children: [
          // Dropdown Bulan
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: allIncomeController.selectedMonth.value,
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
                  allIncomeController.selectedMonth.value = val;
                }
              },
            ),
          ),
          const Gap(16),
          // Dropdown Tahun
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: allIncomeController.selectedYear.value,
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
                  allIncomeController.selectedYear.value = val;
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCardIncomeMonth() {
    return Obx(() {
      final selectedMonth = allIncomeController.selectedMonth.value;
      final selectedYear = allIncomeController.selectedYear.value;

      final list = allIncomeController.filteredIncomes;

      double totalMonthIncome = 0;
      for (var incomes in list) {
        totalMonthIncome += incomes.amount;
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
                formatRupiah(totalMonthIncome),
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

  Widget _buildCardBalance() {
    return Obx(() {
      final totalIncome = allIncomeController.totalThisMonthIncome;
      final totalExpense = allExpenseController.totalThisMonthExpense;
      final balance = totalIncome - totalExpense;

      return Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: balance >= 0 ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.colorWhite,
                ),
              ),
              Text(
                formatRupiah(balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildList() {
    return Obx(() {
      final state = allIncomeController.state;
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

      final list = allIncomeController.filteredIncomes;

      if (list.isEmpty) {
        return const SizedBox(
          height: 200,
          child: ResponseFailed(
            message: 'No Incomes Yet',
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
          IncomeModel income = list[index];
          return _cardIncomeToday(income);
        },
      );
    });
  }

  Widget _cardIncomeToday(IncomeModel income) {
    return GestureDetector(
      onTap: () => _goToDetailIncome(income.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
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
                    income.title,
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
                  label: Text(formatRupiah(income.amount)),
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
                    income.category,
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
                    DateFormat('MM/dd/yy').format(income.dateIncome),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const Gap(16),
                _buildHeaderIncomes(),
                const Gap(16),
                _buildFilterMonthYear(),
                const Gap(16),
                _buildCardIncomeMonth(),
                const Gap(10),
                _buildCardBalance(),
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

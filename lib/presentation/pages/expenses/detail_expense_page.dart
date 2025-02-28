import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/data/models/expense_modal.dart';
import 'package:self_management/presentation/controllers/expense/detail_expense_controller.dart';
import 'package:self_management/presentation/widgets/custom_button.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

import '../../../common/enums.dart';
import '../../controllers/expense/delete_expense_controller.dart';

class DetailExpensePage extends StatefulWidget {
  const DetailExpensePage({super.key, required this.expenseId});

  final int expenseId;

  static const routeName = '/detail-expense';

  @override
  State<DetailExpensePage> createState() => _DetailExpensePageState();
}

class _DetailExpensePageState extends State<DetailExpensePage> {
  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  final detailExpenseController = Get.put(DetailExpenseController());
  final deleteExpenseController = Get.put(DeleteExpenseController());

  @override
  void initState() {
    detailExpenseController.fetch(widget.expenseId);
    super.initState();
  }

  @override
  void dispose() {
    DetailExpenseController.delete();
    DeleteExpenseController.delete();
    super.dispose();
  }

  void deleteExpense() async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'Click yes to confirm delete',
    );
    if (yes ?? false) {
      final state =
          await deleteExpenseController.executeRequest(widget.expenseId);

      if (state.statusRequest == StatusRequest.failed) {
        Info.failed(state.message);
        return;
      }

      if (state.statusRequest == StatusRequest.success) {
        Info.success(state.message);
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/all-expense',
            (route) => route.settings.name == '/dashboard',
            arguments: 'refresh_expense',
          );
        }
        return;
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => route.settings.name == '/dashboard',
        );
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

  Widget _buildCardDate(DateTime dateExpense, double expense) {
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
                    DateFormat('EEEE, dd/MM/yyyy').format(dateExpense),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textBody,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            Row(
              children: [
                const ImageIcon(
                  AssetImage('assets/images/dollar.png'),
                  color: AppColor.primary,
                  size: 20,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    formatRupiah(expense),
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

  Widget _buildCardDescription(String description) {
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
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.textTitle,
              ),
            ),
            const Gap(12),
            Text(
              description,
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
              final state = detailExpenseController.state;
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

              ExpenseModal expense = state.expense!;
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Gap(50),
                  _buildHeaderTitle(expense.category),
                  const Gap(30),
                  _buildCardTitle(expense.title),
                  const Gap(30),
                  _buildCardDate(expense.dateExpense, expense.expense),
                  const Gap(30),
                  _buildCardDescription(expense.description ?? '-'),
                  const Gap(30),
                  _buildButtonDelete(expense.id),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

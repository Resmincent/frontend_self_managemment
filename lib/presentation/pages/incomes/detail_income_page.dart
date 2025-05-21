import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/data/models/income_model.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../common/info.dart';
import '../../controllers/income/delete_income_controller.dart';
import '../../controllers/income/detail_income_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/response_failed.dart';

class DetailIncomePage extends StatefulWidget {
  const DetailIncomePage({super.key, required this.incomeId});
  final int incomeId;

  static const routeName = '/detail-income';
  @override
  State<DetailIncomePage> createState() => _DetailIncomePageState();
}

class _DetailIncomePageState extends State<DetailIncomePage> {
  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  final detailIncomeController = Get.put(DetailIncomeController());
  final deleteIncomeController = Get.put(DeleteIncomeController());

  @override
  void initState() {
    detailIncomeController.fetch(widget.incomeId);
    super.initState();
  }

  @override
  void dispose() {
    DetailIncomeController.delete();
    DeleteIncomeController.delete();
    super.dispose();
  }

  void deleteIncome() async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'Click yes to confirm delete',
    );
    if (yes ?? false) {
      final state =
          await deleteIncomeController.executeRequest(widget.incomeId);

      if (state.statusRequest == StatusRequest.failed) {
        Info.failed(state.message);
        return;
      }

      if (state.statusRequest == StatusRequest.success) {
        Info.success(state.message);
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/all-income',
            (route) => route.settings.name == '/dashboard',
            arguments: 'refresh_income',
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

  Widget _buildCardDate(DateTime dateIncome, double amount) {
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
                    DateFormat('EEEE, dd/MM/yyyy').format(dateIncome),
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
                    formatRupiah(amount),
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
        onPressed: deleteIncome,
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
              final state = detailIncomeController.state;
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

              IncomeModel income = state.income!;
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Gap(50),
                  _buildHeaderTitle(income.category),
                  const Gap(30),
                  _buildCardTitle(income.title),
                  const Gap(30),
                  _buildCardDate(income.dateIncome, income.amount),
                  const Gap(30),
                  _buildCardDescription(income.description ?? '-'),
                  const Gap(30),
                  _buildButtonDelete(income.id),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

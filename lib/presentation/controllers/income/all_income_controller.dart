import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/income_remote_date_source.dart';
import 'package:self_management/data/models/income_model.dart';

class AllIncomeController extends GetxController {
  final _state = AllIncomeState(
    statusRequest: StatusRequest.init,
    message: '',
    incomes: [],
  ).obs;

  AllIncomeState get state => _state.value;

  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;

  List<IncomeModel> get filteredIncomes {
    return state.incomes
        .where((e) =>
            e.dateIncome.month == selectedMonth.value &&
            e.dateIncome.year == selectedYear.value)
        .toList();
  }

  double get totalThisMonthIncome {
    final list = filteredIncomes;
    double total = 0;
    for (var income in list) {
      total += income.amount;
    }

    return total;
  }

  set state(AllIncomeState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, incomes) =
        await IncomeRemoteDateSource.all(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      incomes: incomes ?? [],
    );

    return state;
  }

  static delete() => Get.delete<AllIncomeController>(force: true);
}

class AllIncomeState {
  final StatusRequest statusRequest;
  final String message;
  final List<IncomeModel> incomes;

  AllIncomeState({
    required this.statusRequest,
    required this.message,
    required this.incomes,
  });

  AllIncomeState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<IncomeModel>? incomes,
  }) {
    return AllIncomeState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      incomes: incomes ?? this.incomes,
    );
  }
}

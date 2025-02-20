import 'package:d_chart/d_chart.dart';
import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/expense_remote_data_source.dart';

class AnalyticExpenseLastMonthController extends GetxController {
  final _state = AnalyticExpenseLastMonthState(
    statusRequest: StatusRequest.init,
    message: '',
    expenses: [],
  ).obs;

  AnalyticExpenseLastMonthState get state => _state.value;

  set state(AnalyticExpenseLastMonthState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, dataRaw) =
        await ExpenseRemoteDataSource.analytic(userId);

    if (!success) {
      state = state.copyWith(
        statusRequest: StatusRequest.failed,
        message: message,
      );

      return;
    }

    List<TimeData> expenses = List.from(dataRaw!).map((e) {
      return TimeData(
        domain: DateTime.parse(e['date']),
        measure: e['total'],
      );
    }).toList();

    state = state.copyWith(
        statusRequest: StatusRequest.success,
        expenses: expenses,
        message: message);

    return state;
  }

  static delete() =>
      Get.delete<AnalyticExpenseLastMonthController>(force: true);
}

class AnalyticExpenseLastMonthState {
  final StatusRequest statusRequest;
  final String message;
  final List<TimeData> expenses;

  AnalyticExpenseLastMonthState({
    required this.statusRequest,
    required this.message,
    required this.expenses,
  });

  AnalyticExpenseLastMonthState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<TimeData>? expenses,
  }) {
    return AnalyticExpenseLastMonthState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      expenses: expenses ?? this.expenses,
    );
  }
}

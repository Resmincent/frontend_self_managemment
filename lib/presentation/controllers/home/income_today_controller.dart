import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/income_remote_date_source.dart';
import 'package:self_management/data/models/income_model.dart';

class IncomeTodayController extends GetxController {
  final _state = IncomeTodayState(
    statusRequest: StatusRequest.init,
    message: '',
    incomes: [],
  ).obs;

  IncomeTodayState get state => _state.value;

  set state(IncomeTodayState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, incomes) =
        await IncomeRemoteDateSource.today(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      incomes: incomes ?? [],
    );

    return state;
  }

  static delete() => Get.delete<IncomeTodayController>();
}

class IncomeTodayState {
  final StatusRequest statusRequest;
  final String message;
  final List<IncomeModel> incomes;

  IncomeTodayState({
    required this.statusRequest,
    required this.message,
    required this.incomes,
  });

  IncomeTodayState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<IncomeModel>? incomes,
  }) {
    return IncomeTodayState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      incomes: incomes ?? this.incomes,
    );
  }
}

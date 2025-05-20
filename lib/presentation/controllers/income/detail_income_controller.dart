import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/income_remote_date_source.dart';
import 'package:self_management/data/models/income_model.dart';

class DetailIncomeController extends GetxController {
  final _state = DetailIncomeState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailIncomeState get state => _state.value;

  set state(DetailIncomeState value) => _state.value = value;

  Future<DetailIncomeState> fetch(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message, income) = await IncomeRemoteDateSource.detail(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      income: income,
    );

    return state;
  }

  static delete() => Get.delete<DetailIncomeController>(force: true);
}

class DetailIncomeState {
  final StatusRequest statusRequest;
  final String message;
  final IncomeModel? income;

  DetailIncomeState({
    required this.statusRequest,
    required this.message,
    this.income,
  });

  DetailIncomeState copyWith({
    StatusRequest? statusRequest,
    String? message,
    IncomeModel? income,
  }) {
    return DetailIncomeState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      income: income ?? this.income,
    );
  }
}

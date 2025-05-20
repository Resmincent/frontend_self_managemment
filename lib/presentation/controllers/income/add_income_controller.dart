import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/income_remote_date_source.dart';

import '../../../data/models/income_model.dart';

class AddIncomeController extends GetxController {
  final _state = AddIncomeState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  AddIncomeState get state => _state.value;

  set state(AddIncomeState value) => _state.value = value;

  Future<AddIncomeState> executeRequest(IncomeModel income) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await IncomeRemoteDateSource.add(income);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<AddIncomeController>(force: true);
}

class AddIncomeState {
  final StatusRequest statusRequest;
  final String message;

  AddIncomeState({
    required this.statusRequest,
    required this.message,
  });

  AddIncomeState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return AddIncomeState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

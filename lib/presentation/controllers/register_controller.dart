import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/user_remote_data_source.dart';

class RegisterController extends GetxController {
  final _state = RegisterState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  RegisterState get state => _state.value;

  set state(RegisterState value) => _state.value = value;

  Future<RegisterState> executeRequest(
    String name,
    String email,
    String password,
  ) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) =
        await UserRemoteDataSource.register(name, email, password);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<RegisterController>(force: true);
}

class RegisterState {
  final StatusRequest statusRequest;
  final String message;

  RegisterState({
    required this.statusRequest,
    required this.message,
  });

  RegisterState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return RegisterState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

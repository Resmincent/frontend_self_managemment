import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/data/datasources/user_remote_data_source.dart';

class LoginController extends GetxController {
  final _state = LoginState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  LoginState get state => _state.value;

  set state(LoginState value) => _state.value = value;

  Future<LoginState> executeRequest(
    String email,
    String password,
  ) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, user) =
        await UserRemoteDataSource.login(email, password);

    if (success) {
      Session.saveUser(user!.toJson());
    }

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<LoginController>(force: true);
}

class LoginState {
  final StatusRequest statusRequest;
  final String message;

  LoginState({
    required this.statusRequest,
    required this.message,
  });

  LoginState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return LoginState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

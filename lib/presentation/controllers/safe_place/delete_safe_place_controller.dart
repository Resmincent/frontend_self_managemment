import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/safe_place_remote_data_source.dart';

class DeleteSafePlaceController extends GetxController {
  final _state = DeleteSafePlaceState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DeleteSafePlaceState get state => _state.value;

  set state(DeleteSafePlaceState value) => _state.value = value;

  Future<DeleteSafePlaceState> executeRequest(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await SafePlaceRemoteDataSource.delete(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<DeleteSafePlaceController>(force: true);
}

class DeleteSafePlaceState {
  final StatusRequest statusRequest;
  final String message;

  DeleteSafePlaceState({
    required this.statusRequest,
    required this.message,
  });

  DeleteSafePlaceState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return DeleteSafePlaceState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

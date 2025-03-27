import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/safe_place_remote_data_source.dart';
import 'package:self_management/data/models/safe_place_model.dart';

class DetailSafePlaceController extends GetxController {
  final _state = DetailSafePlaceState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailSafePlaceState get state => _state.value;

  set state(DetailSafePlaceState value) => _state.value = value;

  Future<DetailSafePlaceState> fetch(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message, safePlace) =
        await SafePlaceRemoteDataSource.detail(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      safePlace: safePlace,
    );

    return state;
  }

  static delete() => Get.delete<DetailSafePlaceController>(force: true);
}

class DetailSafePlaceState {
  final StatusRequest statusRequest;
  final String message;
  final SafePlaceModel? safePlace;

  DetailSafePlaceState(
      {required this.statusRequest, required this.message, this.safePlace});

  DetailSafePlaceState copyWith({
    StatusRequest? statusRequest,
    String? message,
    SafePlaceModel? safePlace,
  }) {
    return DetailSafePlaceState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      safePlace: safePlace ?? this.safePlace,
    );
  }
}

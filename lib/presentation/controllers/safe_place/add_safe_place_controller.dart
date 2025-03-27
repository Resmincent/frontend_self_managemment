import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/safe_place_remote_data_source.dart';
import 'package:self_management/data/models/safe_place_model.dart';

import '../../../common/info.dart';

class AddSafePlaceController extends GetxController {
  final _state = AddSafePlaceState(
    message: '',
    statusRequest: StatusRequest.init,
  ).obs;

  AddSafePlaceState get state => _state.value;

  set state(AddSafePlaceState value) => _state.value = value;

  Future<AddSafePlaceState> executeRequest(SafePlaceModel safePlace) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await SafePlaceRemoteDataSource.add(safePlace);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    state = state.copyWith(
      statusRequest: StatusRequest.success,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<AddSafePlaceController>(force: true);
}

class AddSafePlaceState {
  final StatusRequest statusRequest;
  final String message;

  AddSafePlaceState({
    required this.statusRequest,
    required this.message,
  });

  AddSafePlaceState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return AddSafePlaceState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

Future<bool> requestPermissions() async {
  final micPermission = await Permission.microphone.request();
  final storagePermission = await Permission.storage.request();

  if (micPermission.isGranted && storagePermission.isGranted) {
    return true;
  } else {
    // Jika izin ditolak, tampilkan pesan kepada pengguna
    Info.failed(
        'Microphone and storage permissions are required to record audio.');
    return false;
  }
}

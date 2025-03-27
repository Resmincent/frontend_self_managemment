import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/models/safe_place_model.dart';

import '../../../data/datasources/safe_place_remote_data_source.dart';

class AllSafePlaceController extends GetxController {
  final _state = AllSafePlaceState(
    statusRequest: StatusRequest.init,
    message: '',
    safePlaces: [],
  ).obs;

  AllSafePlaceState get state => _state.value;

  set state(AllSafePlaceState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, safePlaces) =
        await SafePlaceRemoteDataSource.all(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      safePlaces: safePlaces ?? [],
    );

    return state;
  }
}

class AllSafePlaceState {
  final StatusRequest statusRequest;
  final String message;
  final List<SafePlaceModel> safePlaces;

  AllSafePlaceState({
    required this.statusRequest,
    required this.message,
    required this.safePlaces,
  });

  AllSafePlaceState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<SafePlaceModel>? safePlaces,
  }) {
    return AllSafePlaceState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      safePlaces: safePlaces ?? this.safePlaces,
    );
  }
}

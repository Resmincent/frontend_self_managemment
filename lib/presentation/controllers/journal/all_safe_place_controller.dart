import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/models/journal_model.dart';

import '../../../data/datasources/journal_remote_data_source.dart';

class AllJournalController extends GetxController {
  final _state = AllJournalState(
    statusRequest: StatusRequest.init,
    message: '',
    journals: [],
  ).obs;

  AllJournalState get state => _state.value;

  set state(AllJournalState value) => _state.value = value;

  Future fetch(int userId) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, journals) =
        await JournalRemoteDataSource.all(userId);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      journals: journals ?? [],
    );

    return state;
  }

  Future search(int userId, String query) async {
    state = state.copyWith(statusRequest: StatusRequest.loading);

    final (success, message, journals) =
        await JournalRemoteDataSource.search(userId, query);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      journals: journals ?? [],
    );

    return state;
  }

  static delete() => Get.delete<AllJournalController>(force: true);
}

class AllJournalState {
  final StatusRequest statusRequest;
  final String message;
  final List<JournalModel> journals;

  AllJournalState({
    required this.statusRequest,
    required this.message,
    required this.journals,
  });

  AllJournalState copyWith({
    StatusRequest? statusRequest,
    String? message,
    List<JournalModel>? journals,
  }) {
    return AllJournalState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      journals: journals ?? this.journals,
    );
  }
}

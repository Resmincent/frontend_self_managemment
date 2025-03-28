import 'package:get/get.dart';

import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/journal_remote_data_source.dart';
import 'package:self_management/data/models/journal_model.dart';

class DetailJournalController extends GetxController {
  final _state = DetailJournalState(
    statusRequest: StatusRequest.init,
    message: '',
  ).obs;

  DetailJournalState get state => _state.value;

  set state(DetailJournalState value) => _state.value = value;

  Future<DetailJournalState> fetch(int id) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message, journal) =
        await JournalRemoteDataSource.detail(id);

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
      journal: journal,
    );

    return state;
  }

  static delete() => Get.delete<DetailJournalController>(force: true);
}

class DetailJournalState {
  final StatusRequest statusRequest;
  final String message;
  final JournalModel? journal;

  DetailJournalState(
      {required this.statusRequest, required this.message, this.journal});

  DetailJournalState copyWith({
    StatusRequest? statusRequest,
    String? message,
    JournalModel? journal,
  }) {
    return DetailJournalState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
      journal: journal ?? this.journal,
    );
  }
}

import 'package:get/get.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/data/datasources/journal_remote_data_source.dart';
import 'package:self_management/data/models/journal_model.dart';

class AddJournalController extends GetxController {
  final _state = AddJournalState(
    message: '',
    statusRequest: StatusRequest.init,
  ).obs;

  AddJournalState get state => _state.value;

  set state(AddJournalState value) => _state.value = value;

  Future<AddJournalState> executeRequest(JournalModel journal) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (success, message) = await JournalRemoteDataSource.add(journal);

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

  static delete() => Get.delete<AddJournalController>(force: true);
}

class AddJournalState {
  final StatusRequest statusRequest;
  final String message;

  AddJournalState({
    required this.statusRequest,
    required this.message,
  });

  AddJournalState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return AddJournalState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}

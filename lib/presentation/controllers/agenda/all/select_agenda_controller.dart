import 'package:get/get.dart';

import 'package:self_management/data/models/agenda_model.dart';

class SelectAgendaController extends GetxController {
  final _state = AgendaModel(
    id: 0,
    title: 'Agenda Selected',
    category: '',
    startEvent: DateTime.now(),
    endEvent: DateTime.now(),
  ).obs;

  AgendaModel get state => _state.value;

  set state(AgendaModel value) => _state.value = value;

  static delete() => Get.delete<SelectAgendaController>(force: true);
}

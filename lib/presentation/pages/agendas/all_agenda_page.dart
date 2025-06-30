import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/presentation/controllers/agenda/all/all_agenda_controller.dart';
import 'package:self_management/presentation/controllers/agenda/all/select_agenda_controller.dart';
import 'package:self_management/presentation/pages/agendas/add_agenda_page.dart';
import 'package:self_management/presentation/pages/agendas/detail_agenda_page.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

import '../../../core/session.dart';

class AllAgendaPage extends StatefulWidget {
  const AllAgendaPage({super.key});

  static const routeName = '/all-agenda';

  @override
  State<AllAgendaPage> createState() => _AllAgendaPageState();
}

class _AllAgendaPageState extends State<AllAgendaPage> {
  final allAgendaController = Get.put(AllAgendaController());
  final selectAgendaController = Get.put(SelectAgendaController());
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args == 'refresh') {
        referesh();
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    AllAgendaController.delete();
    SelectAgendaController.delete();
    super.dispose();
  }

  referesh() async {
    final user = await Session.getUser();
    int userId = user!.id;
    Future.wait([
      allAgendaController.fetch(userId),
    ]);
  }

  @override
  void initState() {
    referesh();
    super.initState();
  }

  Future<void> _goToAddAgenda() async {
    await Navigator.pushNamed(context, AddAgendaPage.routeName);
  }

  Future<void> _goToDetailAgenda(int id) async {
    Navigator.pushNamed(
      context,
      DetailAgendaPage.routeName,
      arguments: id,
    );
  }

  void _selectAgenda(AgendaModel agenda) {
    selectAgendaController.state = agenda;
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              await Navigator.pushReplacementNamed(context, '/dashboard');
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.primary,
            ),
          ),
          const Text(
            'All Agenda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          IconButton(
            onPressed: _goToAddAgenda,
            icon: const ImageIcon(
              AssetImage('assets/images/add_agenda.png'),
              size: 24,
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAgenda() {
    return Obx(() {
      final agendaSelect = selectAgendaController.state;
      int id = agendaSelect.id;
      return GestureDetector(
        onTap: id == 0 ? null : () => _goToDetailAgenda(id),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.colorWhite,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  agendaSelect.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textTitle,
                    fontSize: 14,
                  ),
                ),
              ),
              const ImageIcon(
                AssetImage('assets/images/arrow_right.png'),
                size: 24,
                color: AppColor.primary,
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWeekHeader(DateTime startDate, DateTime endDate) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: [
          Text(
            DateFormat('MMM d, yyyy').format(startDate),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.textTitle,
            ),
          ),
          const Gap(20),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor.textBody,
              ),
            ),
          ),
          const Gap(20),
          Text(
            DateFormat('MMM d, yyyy').format(endDate),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.textTitle,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEventTile(CalendarEventData event) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [event.startTime, event.endTime].map((value) {
          return Text(
            DateFormat('HH:mm').format(value!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.textTitle,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeekView() {
    return Obx(() {
      final state = allAgendaController.state;
      final statusRequest = state.statusRequest;
      if (statusRequest == StatusRequest.init) {
        return const SizedBox();
      }
      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (statusRequest == StatusRequest.failed) {
        return ResponseFailed(
          message: state.message,
          margin: const EdgeInsets.all(20),
        );
      }

      final list = state.list;
      if (list.isEmpty) {
        return const ResponseFailed(
          message: 'No Agenda Yet',
          margin: EdgeInsets.all(20),
        );
      }

      return WeekView(
        controller: EventController()..addAll(list),
        weekPageHeaderBuilder: (startDate, endDate) {
          return _buildWeekHeader(startDate, endDate);
        },
        eventTileBuilder: (
          date,
          events,
          boundary,
          startDuration,
          endDuration,
        ) {
          return _buildEventTile(events.first);
        },
        showLiveTimeLineInAllDays: true,
        width: MediaQuery.sizeOf(context).width,
        minDay: DateTime(DateTime.now().year),
        maxDay: DateTime(DateTime.now().year + 1, DateTime.now().month),
        initialDay: DateTime.now(),
        startDay: WeekDays.sunday,
        startHour: 5,
        endHour: 24,
        showVerticalLines: false,
        backgroundColor: Colors.transparent,
        heightPerMinute: 1,
        eventArranger: const SideEventArranger(),
        keepScrollOffset: true,
        onEventTap: (events, date) {
          _selectAgenda(events.first.event as AgendaModel);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(50),
          _buildHeader(),
          const Gap(10),
          _buildSelectAgenda(),
          Expanded(
            child: _buildWeekView(),
          ),
        ],
      ),
    );
  }
}

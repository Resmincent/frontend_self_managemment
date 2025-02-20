import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/d_chart.dart';
import 'package:d_chart/time/line.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/enums.dart';
import 'package:self_management/core/session.dart';
import 'package:self_management/presentation/controllers/analytic/analytic_agenda_last_month_controller.dart';
import 'package:self_management/presentation/controllers/analytic/analytic_expense_last_month_controller.dart';
import 'package:self_management/presentation/controllers/analytic/analytic_mood_last_month_controller.dart';
import 'package:self_management/presentation/controllers/analytic/analytic_mood_today_controller.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

class AnalyticFragment extends StatefulWidget {
  const AnalyticFragment({super.key});

  @override
  State<AnalyticFragment> createState() => _AnalyticFragmentState();
}

class _AnalyticFragmentState extends State<AnalyticFragment> {
  final analyticMoodTodayController = Get.put(AnalyticMoodTodayController());
  final analyticMoodLastMonthController =
      Get.put(AnalyticMoodLastMonthController());
  final analyticAgendaLastMonthController =
      Get.put(AnalyticAgendaLastMonthController());
  final analyticExpensesLastMonthController =
      Get.put(AnalyticExpenseLastMonthController());

  @override
  void dispose() {
    AnalyticMoodTodayController.delete();
    AnalyticMoodLastMonthController.delete();
    AnalyticAgendaLastMonthController.delete();
    AnalyticExpenseLastMonthController.delete();
    super.dispose();
  }

  referesh() async {
    final user = await Session.getUser();
    int userId = user!.id;
    Future.wait([
      analyticMoodTodayController.fetch(userId),
      analyticMoodLastMonthController.fetch(userId),
      analyticAgendaLastMonthController.fetch(userId),
      analyticExpensesLastMonthController.fetch(userId),
    ]);
  }

  @override
  void initState() {
    referesh();
    super.initState();
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytic For You',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        Gap(10),
        Text(
          'Check and boost up your quality',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColor.textBody,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodToday() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.colorWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Mood Today',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColor.textTitle,
            ),
          ),
          const Gap(30),
          Obx(() {
            final state = analyticMoodTodayController.state;
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
              return ResponseFailed(message: state.message);
            }

            List<TimeData> moods = state.moods;
            List groupLevels = state.group;

            if (moods.isEmpty) {
              return const ResponseFailed(message: 'No Mood Yet');
            }

            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(id: 'id', data: moods, color: AppColor.primary),
                    ],
                    measureAxis: const MeasureAxis(
                      showLine: true,
                      numericViewport: NumericViewport(0, 5),
                      numericTickProvider: NumericTickProvider(
                        desiredTickCount: 6,
                      ),
                    ),
                    layoutMargin: LayoutMargin(10, 0, 0, 10),
                    domainAxis: DomainAxis(
                      minimumPaddingBetweenLabels: 20,
                      labelAnchor: LabelAnchor.after,
                      tickLabelFormatterT: (domain) {
                        return DateFormat('H:mm').format(domain);
                      },
                    ),
                    configRenderLine: const ConfigRenderLine(
                      includeArea: true,
                      includePoints: true,
                    ),
                  ),
                ),
                const Gap(38),
                GridView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 24,
                  ),
                  children: groupLevels.map((value) {
                    int level = value['level'];
                    int total = value['total'];
                    return Row(
                      children: [
                        Image.asset(
                          'assets/images/mood_big_$level.png',
                          width: 24,
                          height: 24,
                        ),
                        const Gap(12),
                        Text(
                          '$total',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildMoodLastMonth() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.colorWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Mood Last Month',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColor.textTitle,
            ),
          ),
          const Gap(30),
          Obx(() {
            final state = analyticMoodLastMonthController.state;
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
              return ResponseFailed(message: state.message);
            }

            List<TimeData> moods = state.moods;
            List groupLevels = state.group;

            if (moods.isEmpty) {
              return const ResponseFailed(message: 'No Mood Yet');
            }

            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: 'id',
                        data: moods,
                        color: AppColor.primary,
                      ),
                    ],
                    measureAxis: const MeasureAxis(
                      showLine: true,
                      numericViewport: NumericViewport(0, 5),
                      numericTickProvider: NumericTickProvider(
                        desiredTickCount: 6,
                      ),
                    ),
                    layoutMargin: LayoutMargin(10, 0, 0, 10),
                    domainAxis: DomainAxis(
                      minimumPaddingBetweenLabels: 20,
                      labelAnchor: LabelAnchor.after,
                      tickLabelFormatterT: (domain) {
                        return DateFormat('H:mm').format(domain);
                      },
                    ),
                    configRenderLine: const ConfigRenderLine(
                      includeArea: true,
                      includePoints: true,
                    ),
                  ),
                ),
                const Gap(38),
                GridView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 24,
                  ),
                  children: groupLevels.map((value) {
                    int level = value['level'];
                    int total = value['total'];
                    return Row(
                      children: [
                        Image.asset(
                          'assets/images/mood_big_$level.png',
                          width: 24,
                          height: 24,
                        ),
                        const Gap(12),
                        Text(
                          '$total',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildAgendaLastMonth() {
    return const Column();
  }

  Widget _buildExpenseLastMonth() {
    return const Column();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Gap(55),
        _buildHeader(),
        const Gap(34),
        _buildMoodToday(),
        const Gap(34),
        _buildMoodLastMonth(),
        const Gap(34),
        _buildAgendaLastMonth(),
        const Gap(34),
        _buildExpenseLastMonth(),
      ],
    );
  }
}

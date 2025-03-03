import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/data/models/solution_model.dart';
import 'package:self_management/presentation/widgets/response_failed.dart';

import '../../../common/enums.dart';
import '../../controllers/solution/detail_solution_controlle.dart';

class DetailSolutionPage extends StatefulWidget {
  const DetailSolutionPage({super.key, required this.solutionId});

  final int solutionId;

  static const routeName = '/detail-solution';

  @override
  State<DetailSolutionPage> createState() => _DetailSolutionPageState();
}

class _DetailSolutionPageState extends State<DetailSolutionPage> {
  final detailSolutionController = Get.put(DetailSolutionController());

  @override
  void initState() {
    detailSolutionController.fetch(widget.solutionId);
    super.initState();
  }

  @override
  void dispose() {
    DetailSolutionController.delete();
    super.dispose();
  }

  Widget _buildHeaderTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.colorWhite,
            ),
          ),
          const Gap(13),
          const Text(
            'Detail Solusi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.colorWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const Gap(8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColor.textTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReference(List<String> references) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Referensi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const Gap(12),
            Column(
              children: references.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.link,
                          size: 18,
                          color: AppColor.primary,
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: SelectableText(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: AppColor.textBody,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 170,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          Obx(
            () {
              final state = detailSolutionController.state;
              final statusRequest = state.statusRequest;

              if (statusRequest == StatusRequest.init) {
                return const Center(
                  child: BackButton(color: AppColor.colorWhite),
                );
              }

              if (statusRequest == StatusRequest.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.colorWhite),
                );
              }

              if (statusRequest == StatusRequest.failed) {
                return ResponseFailed(
                  message: state.message,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                );
              }

              SolutionModel solution = state.solution!;
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Gap(50),
                  _buildHeaderTitle(),
                  const Gap(30),
                  _buildContentCard('Masalah', solution.problem),
                  const Gap(20),
                  _buildContentCard('Ringkasan', solution.summary),
                  const Gap(20),
                  _buildContentCard('Solusi', solution.solution),
                  const Gap(20),
                  _buildReference(solution.reference),
                  const Gap(30),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/data/models/solution_model.dart';
import 'package:self_management/presentation/controllers/solution_controller.dart';
import 'package:self_management/presentation/pages/solutions/add_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/detail_solution_page.dart';
import 'package:self_management/presentation/pages/solutions/update_solution_page.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../core/session.dart';
import '../../widgets/response_failed.dart';

class SolutionFragment extends StatefulWidget {
  const SolutionFragment({super.key});

  static const routeName = "/solution";
  @override
  State<SolutionFragment> createState() => _SolutionFragmentState();
}

class _SolutionFragmentState extends State<SolutionFragment> {
  final solutionController = Get.put(SolutionController());
  final searchController = TextEditingController();

  refresh() {
    Session.getUser().then((user) {
      int userId = user!.id;
      solutionController.fetch(userId);
    });
  }

  Future<void> _goToAddSolution() async {
    await Navigator.pushNamed(context, AddSolutionPage.routeName);
    refresh();
  }

  Future<void> _goToUpdateSolution(SolutionModel solution) async {
    await Navigator.pushNamed(context, UpdateSolutionPage.routeName,
        arguments: solution);
  }

  Future<void> _goToDetailSolution(int id) async {
    await Navigator.pushNamed(context, DetailSolutionPage.routeName,
        arguments: id);
  }

  void search() {
    final query = searchController.text;

    if (query == '') return;

    Session.getUser().then((user) {
      int userId = user!.id;
      solutionController.search(userId, query);
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    SolutionController.delete();
    super.dispose();
  }

  Widget _buildHeaderSolution() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Self Solution',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            Gap(10),
            Text(
              'Cek and solve your problem',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColor.textBody,
              ),
            ),
          ],
        ),
        IconButton.filled(
          constraints: BoxConstraints.tight(const Size(48, 48)),
          color: AppColor.colorWhite,
          style: const ButtonStyle(
            overlayColor: WidgetStatePropertyAll(AppColor.secondary),
          ),
          onPressed: _goToAddSolution,
          icon: const ImageIcon(
            AssetImage('assets/images/add_solution.png'),
            size: 24,
            color: AppColor.colorWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonSearch() {
    return TextFormField(
      controller: searchController,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.colorWhite,
      ),
      cursorColor: AppColor.secondary,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: search,
          child: const UnconstrainedBox(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: ImageIcon(
                AssetImage('assets/images/search.png'),
                color: AppColor.colorWhite,
                size: 24,
              ),
            ),
          ),
        ),
        fillColor: AppColor.primary,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        hintText: 'Search your problem..',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColor.colorWhite,
        ),
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      final state = solutionController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.init) {
        return const SizedBox();
      }

      if (statusRequest == StatusRequest.loading) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (statusRequest == StatusRequest.failed) {
        return SizedBox(
          height: 200,
          child: ResponseFailed(
            message: state.message,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      }

      final list = state.solutions;

      if (list.isEmpty) {
        return const SizedBox(
          height: 200,
          child: ResponseFailed(
            message: 'No Solution Yet',
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      }

      return Expanded(
        child: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          itemBuilder: (context, index) {
            SolutionModel solution = list[index];
            return _buildCardSolution(solution);
          },
        ),
      );
    });
  }

  Widget _buildCardSolution(SolutionModel solution) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _goToDetailSolution(solution.id),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.colorWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 55),
                    child: Text(
                      solution.problem,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textTitle,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    solution.solution,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textBody,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              width: 46,
              height: 36,
              child: FloatingActionButton(
                elevation: 0,
                onPressed: () => _goToUpdateSolution(solution),
                heroTag: 'solution-item-${solution.id}',
                backgroundColor: AppColor.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: const ImageIcon(
                  AssetImage('assets/images/update_solution.png'),
                  color: AppColor.colorWhite,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Gap(55),
          _buildHeaderSolution(),
          const Gap(30),
          _buildButtonSearch(),
          const Gap(16),
          _buildList(),
          const Gap(140)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/presentation/controllers/solution_controller.dart';
import 'package:self_management/presentation/pages/solutions/add_solution_page.dart';

import '../../../common/app_color.dart';
import '../../../core/session.dart';

class SolutionFragment extends StatefulWidget {
  const SolutionFragment({super.key});

  @override
  State<SolutionFragment> createState() => _SolutionFragmentState();
}

class _SolutionFragmentState extends State<SolutionFragment> {
  final solutionController = Get.put(SolutionController());
  final searchController = TextEditingController();

  refresh() async {
    final user = await Session.getUser();
    int userId = user!.id;
    solutionController.fetch(userId);
  }

  Future<void> _goToAddSolution() async {
    await Navigator.pushReplacementNamed(context, AddSolutionPage.routeName);
  }

  void search() {}

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
            alignment: Alignment(-0.5, 0),
            child: ImageIcon(
              AssetImage('assets/images/search.png'),
              color: AppColor.colorWhite,
              size: 24,
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => refresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                const Gap(55),
                _buildHeaderSolution(),
                const Gap(30),
                _buildButtonSearch(),
                const Gap(30),
                // _buildList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

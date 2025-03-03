import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/data/models/solution_model.dart';
import 'package:self_management/presentation/controllers/solution/delete_solution_controller.dart';
import 'package:self_management/presentation/controllers/solution_controller.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../core/session.dart';
import '../../controllers/solution/update_solution_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class UpdateSolutionPage extends StatefulWidget {
  const UpdateSolutionPage({super.key, required this.solution});

  final SolutionModel solution;

  static const routeName = "/update-solution";

  @override
  State<UpdateSolutionPage> createState() => _UpdateSolutionPageState();
}

class _UpdateSolutionPageState extends State<UpdateSolutionPage> {
  final updateSolutionController = Get.put(UpdateSolutionController());
  final deleteSolutionController = Get.put(DeleteSolutionController());
  final findSolutionController = Get.find<SolutionController>();

  final summaryController = TextEditingController();
  final problemController = TextEditingController();
  final solutionController = TextEditingController();
  final referenceController = TextEditingController();

  final references = <String>[].obs;

  @override
  void initState() {
    summaryController.text = widget.solution.summary;
    problemController.text = widget.solution.problem;
    solutionController.text = widget.solution.solution;
    references.value = widget.solution.reference;

    super.initState();
  }

  @override
  void dispose() {
    UpdateSolutionController.delete();
    DeleteSolutionController.delete();
    super.dispose();
  }

  void addItemReference() {
    final item = referenceController.text.trim();
    if (item.isEmpty) return;
    references.add(item);
    referenceController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void removeItemReference(String item) {
    references.remove(item);
  }

  Future<void> updateSolution() async {
    final solution = solutionController.text.trim();
    final problem = problemController.text.trim();
    final summary = summaryController.text.trim();

    if (summary.isEmpty) {
      Info.failed('Summary must be filled');
      return;
    }

    if (problem.isEmpty) {
      Info.failed('Problem must be filled');
      return;
    }

    if (solution.isEmpty) {
      Info.failed('Solution must be filled');
      return;
    }

    int userId = (await Session.getUser())!.id;

    final solutionModel = SolutionModel(
      id: widget.solution.id,
      userId: userId,
      summary: summary,
      problem: problem,
      reference: List.from(references),
      solution: solution,
      createdAt: widget.solution.createdAt,
    );

    final state = await updateSolutionController.executeRequest(solutionModel);
    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      Info.success(state.message);
      findSolutionController.fetch(userId);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    }
  }

  void deleteSolution() async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'Click yes to confirm delete',
    );
    bool clickYes = yes ?? false;
    if (!clickYes) return;

    int id = widget.solution.id;
    int userId = (await Session.getUser())!.id;

    final state = await deleteSolutionController.executeRequest(id);

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      Info.success(state.message);
      findSolutionController.fetch(userId);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    }
  }

  Widget _buildHeaderSolution() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.primary,
            ),
          ),
          const Text(
            'Update Solution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage('assets/images/add_agenda.png'),
              size: 24,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: summaryController,
          hintText: 'Input summary...',
          maxLines: 5,
          minLines: 3,
        ),
      ],
    );
  }

  Widget _buildProblemInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Problem',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: problemController,
          hintText: 'Input problem...',
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildSolutionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Solution',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: solutionController,
          hintText: 'Input solution...',
          maxLines: 3,
          minLines: 2,
        ),
      ],
    );
  }

  Widget _buildReferenceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reference',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.textTitle),
        ),
        const Gap(16),
        CustomInput(
          controller: referenceController,
          hintText: 'https://...',
          maxLines: 1,
          suffixIcon: 'assets/images/add_agenda.png',
          suffixOnTap: addItemReference,
        ),
        const Gap(16),
        Obx(() {
          return Column(
            children: references.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        onPressed: () => removeItemReference(item),
                        padding: const EdgeInsets.all(0),
                        icon: const ImageIcon(
                          AssetImage('assets/images/remove.png'),
                          size: 24,
                          color: AppColor.error,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Transform.translate(
                        offset: const Offset(0, 10),
                        child: SelectableText(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: AppColor.textBody,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        })
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Obx(() {
      final state = updateSolutionController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonPrimary(
        onPressed: updateSolution,
        title: 'Update Changes',
      );
    });
  }

  Widget _buildDeleteButton() {
    return Obx(() {
      final state = deleteSolutionController.state;
      final statusRequest = state.statusRequest;

      if (statusRequest == StatusRequest.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ButtonDelete(
        onPressed: deleteSolution,
        title: 'Delete',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(50),
          _buildHeaderSolution(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Gap(10),
                _buildSummaryInput(),
                const Gap(10),
                _buildProblemInput(),
                const Gap(10),
                _buildSolutionInput(),
                const Gap(10),
                _buildReferenceInput(),
                const Gap(40),
                _buildUpdateButton(),
                const Gap(10),
                _buildDeleteButton(),
                const Gap(60),
              ],
            ),
          )
        ],
      ),
    );
  }
}

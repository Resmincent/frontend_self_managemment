import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/presentation/controllers/solution/add_solution_controller.dart';

import '../../../common/app_color.dart';
import '../../widgets/custom_input.dart';

class AddSolutionPage extends StatefulWidget {
  const AddSolutionPage({super.key});

  static const routeName = "/add-solution";

  @override
  State<AddSolutionPage> createState() => _AddSolutionPageState();
}

class _AddSolutionPageState extends State<AddSolutionPage> {
  final addSolutionContrller = Get.put(AddSolutionController());

  final summaryController = TextEditingController();
  final problemController = TextEditingController();
  final solutionController = TextEditingController();

  @override
  void dispose() {
    AddSolutionController.delete();
    super.dispose();
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
            'Add Solution',
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
          hintText:
              'Dalam kehidupan, terdapat banyak ketentuan yang perlu kita jalankan dan memiliki prioritasnya masing-masing...',
          maxLines: 3,
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
          hintText: 'Aturan mana yang perlu kita dahulukan?',
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
          hintText:
              'Aturan yang memiliki level prioritas urgent dengan memerhatikan..',
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildReferenceInput() {
    return SizedBox();
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
                const Gap(60),
              ],
            ),
          )
        ],
      ),
    );
  }
}

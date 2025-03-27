import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/data/models/safe_place_model.dart';
import 'package:self_management/presentation/controllers/safe_place/all_safe_place_controller.dart';
import 'package:self_management/presentation/pages/safe_place/add_safe_place_page.dart';
import 'package:self_management/presentation/pages/safe_place/detail_safe_place_page.dart';

import '../../../common/app_color.dart';
import '../../../common/enums.dart';
import '../../../core/session.dart';
import '../../widgets/response_failed.dart';

class SafePlaceFragement extends StatefulWidget {
  const SafePlaceFragement({super.key});

  @override
  State<SafePlaceFragement> createState() => _SafePlaceFragementState();
}

class _SafePlaceFragementState extends State<SafePlaceFragement> {
  final safePlaceController = Get.put(AllSafePlaceController());

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    AllSafePlaceController.delete();
    super.dispose();
  }

  refresh() {
    Session.getUser().then((user) {
      int userId = user!.id;
      safePlaceController.fetch(userId);
    });
  }

  Future<void> _goToAddSafePlace() async {
    await Navigator.pushNamed(context, AddSafePlacePage.routeName);
    refresh();
  }

  Future<void> _goToDetailSafePlace(int id) async {
    await Navigator.pushNamed(context, DetailSafePlacePage.routeName,
        arguments: id);
  }

  Widget _buildHeaderSafePlace() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safe Place',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            Gap(10),
            Text(
              'Find a safe place to share your problem',
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
          onPressed: _goToAddSafePlace,
          icon: const ImageIcon(
            AssetImage('assets/images/add_solution.png'),
            size: 24,
            color: AppColor.colorWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Obx(() {
      final state = safePlaceController.state;
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

      final list = state.safePlaces;

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
            SafePlaceModel safePlaceModel = list[index];
            return _buildCardSafePlace(safePlaceModel);
          },
        ),
      );
    });
  }

  Widget _buildCardSafePlace(SafePlaceModel safePlaceModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _goToDetailSafePlace(safePlaceModel.id),
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
                      safePlaceModel.title.isNotEmpty
                          ? safePlaceModel.title
                          : 'Content',
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
                    safePlaceModel.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              width: 46,
              height: 36,
              child: Text(
                safePlaceModel.type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
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
          _buildHeaderSafePlace(),
          const Gap(30),
          _buildList(),
          const Gap(140)
        ],
      ),
    );
  }
}

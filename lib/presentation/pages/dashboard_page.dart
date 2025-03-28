import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/presentation/pages/fragments/analytic_fragment.dart';
// import 'package:self_management/presentation/pages/fragments/games_fragment.dart';
import 'package:self_management/presentation/pages/fragments/home_fragment.dart';
import 'package:self_management/presentation/pages/fragments/solution_fragment.dart';

import 'fragments/journal_fragement.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final navIndex = 0.obs;

  final List<Map<String, dynamic>> menu = [
    {
      'iconType': 'asset',
      'icon': 'assets/images/home.png',
      'view': const HomeFragment(),
    },
    {
      'iconType': 'asset',
      'icon': 'assets/images/analytic.png',
      'view': const AnalyticFragment(),
    },
    {
      'iconType': 'asset',
      'icon': 'assets/images/agenda.png',
      'view': const SolutionFragment(),
    },
    {
      'iconType': 'material',
      'icon': Icons.my_library_books_outlined,
      'view': const JournalFragement(),
    }
    // {
    //   'iconType': 'material',
    //   'icon': Icons.tv_rounded,
    //   'view': const GamesFragment(),
    // }
  ];

  Widget _buildIcon(Map<String, dynamic> menuItem, bool isActive) {
    if (menuItem['iconType'] == 'asset') {
      return ImageIcon(
        AssetImage(menuItem['icon']),
        color: isActive ? Colors.white : AppColor.primary,
      );
    } else {
      return Icon(
        menuItem['icon'],
        color: isActive ? Colors.white : AppColor.primary,
        size: 30,
      );
    }
  }

  Widget _buildMenu() {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 30),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              menu.length,
              (index) {
                bool isActive = index == navIndex.value;
                return Material(
                  color: isActive ? AppColor.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => navIndex.value = index,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isActive ? AppColor.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: _buildIcon(menu[index], isActive),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () {
          return menu[navIndex.value]['view'];
        },
      ),
      extendBody: true,
      bottomNavigationBar: _buildMenu(),
    );
  }
}

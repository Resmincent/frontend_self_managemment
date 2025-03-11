import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/games/flappy_dash_page.dart';

import '../../../common/app_color.dart';
import '../../../games/audio_helper.dart';
import '../../../games/service_locator.dart';
import '../../controllers/game_controller.dart';

class Game {
  final String title;
  final String description;
  final IconData icon;
  final Function() onTap;

  Game({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
}

class GamesFragment extends StatefulWidget {
  const GamesFragment({super.key});

  @override
  State<GamesFragment> createState() => _GamesFragmentState();
}

class _GamesFragmentState extends State<GamesFragment> {
  late List<Game> _games;

  @override
  void initState() {
    super.initState();
    _initGames();
  }

  void _initGames() {
    _games = [
      Game(
        title: 'Flappy Dash',
        description: 'Test your reflexes with this fun game!',
        icon: Icons.flight,
        onTap: _goToFlappyDash,
      ),
      // Add more games here
      Game(
        title: 'Memory Cards',
        description: 'Train your memory with card matching',
        icon: Icons.grid_view_rounded,
        onTap: () {
          // Navigate to memory game
          // Navigator.pushNamed(context, MemoryGamePage.routeName);
        },
      ),
      Game(
        title: 'Number Puzzle',
        description: 'Solve the sliding puzzle challenge',
        icon: Icons.extension,
        onTap: () {
          // Navigate to puzzle game
          // Navigator.pushNamed(context, PuzzleGamePage.routeName);
        },
      ),
      // You can add more games as needed
    ];
  }

  Future<void> _goToFlappyDash() async {
    if (!Get.isRegistered<GameController>()) {
      final audioHelper = getIt.get<AudioHelper>();
      Get.put(GameController(audioHelper));
    }

    await Navigator.pushNamed(context, FlappyDashPage.routeName);
  }

  Widget _buildHeaderGames() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Self Games',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        Gap(10),
        Text(
          'Find and Play the fun games',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColor.textBody,
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(Game game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          game.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            game.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColor.primary,
            ),
          ),
        ),
        onTap: game.onTap,
      ),
    );
  }

  Widget _buildListGames() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _games.length,
      itemBuilder: (context, index) {
        return _buildGameCard(_games[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(55),
            _buildHeaderGames(),
            const Gap(30),
            _buildListGames(),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

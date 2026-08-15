import 'package:flutter/material.dart';

import '../game_progress.dart';
import '../fidel_families.dart';
import 'crossword_screen.dart';
import 'level3_family_challenge_screen.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _prepareLevels();
  }

  Future<void> _prepareLevels() async {
    await GameProgress.unlockAllLevels();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _openLevel(BuildContext context, int level) {
    if (!GameProgress.isLevelUnlocked(level)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete earlier levels to unlock Level $level.',
          ),
        ),
      );
      return;
    }

    GameProgress.selectLevel(level);

    if (level == 3) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const Level3FamilyChallengeScreen(),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {});
        }
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const CrosswordScreen(),
        settings: RouteSettings(arguments: level),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _resetProgress() async {
    await GameProgress.resetProgress();

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Level progress has been reset.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Level'),
        actions: [
          IconButton(
            tooltip: 'Reset progress',
            onPressed: _resetProgress,
            icon: const Icon(
              Icons.restart_alt_rounded,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int columnCount = 3;

          if (constraints.maxWidth < 600) {
            columnCount = 2;
          }

          if (constraints.maxWidth < 380) {
            columnCount = 1;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: GameProgress.totalLevels,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final int level = index + 1;
              final bool unlocked = GameProgress.isLevelUnlocked(level);
              final bool selected = GameProgress.currentLevel == level;
              final bool isChallenge = level == 3;

              final Color borderColor = isChallenge
                  ? const Color(0xFFDA121A)
                  : selected
                      ? const Color(0xFF078930)
                      : Colors.grey.shade300;

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openLevel(context, level),
                child: Card(
                  color: isChallenge ? const Color(0xFFDA121A) : null,
                  elevation: selected || isChallenge ? 6 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      width: selected || isChallenge ? 3 : 1,
                      color: borderColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isChallenge
                              ? Icons.extension_rounded
                              : unlocked
                                  ? Icons.lock_open_rounded
                                  : Icons.lock_rounded,
                          size: 38,
                          color: isChallenge
                              ? Colors.white
                              : unlocked
                                  ? const Color(0xFF078930)
                                  : Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isChallenge
                              ? 'Level 3 — Challenge'
                              : 'Level $level — ${fidelFamilyName(level)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isChallenge ? Colors.white : null,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isChallenge
                              ? 'All Fidel families — mixed 1–7 order'
                              : unlocked
                                  ? '${fidelFamilies[level - 1].first} to ${fidelFamilies[level - 1].last}'
                                  : 'Locked',
                          style: TextStyle(
                            color: isChallenge
                                ? Colors.white
                                : unlocked
                                    ? const Color(0xFF078930)
                                    : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isChallenge) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Tap to play',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

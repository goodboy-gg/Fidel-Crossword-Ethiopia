import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../game_progress.dart';
import '../fidel_families.dart';
import 'level3_mixed_crossword_screen.dart';

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

  Future<void> _openLevel(BuildContext context, int level) async {
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

    await GameProgress.selectLevel(level);

    if (!mounted) {
      return;
    }

    if (level == 3) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const Level3MixedCrosswordScreen(),
        ),
      );
    } else {
      await Navigator.pushNamed(
        context,
        AppRoutes.crossword,
        arguments: level,
      );
    }

    if (mounted) {
      setState(() {});
    }
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

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openLevel(context, level),
                child: Card(
                  elevation: selected ? 6 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      width: selected ? 3 : 1,
                      color: selected
                          ? const Color(0xFF078930)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          unlocked
                              ? Icons.lock_open_rounded
                              : Icons.lock_rounded,
                          size: 34,
                          color: unlocked
                              ? const Color(0xFF078930)
                              : Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          level == 3
                              ? 'Level 3 — Mixed Challenge'
                              : 'Level $level — ${fidelFamilyName(level)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          unlocked
                              ? (level == 3
                                  ? '33 family starters'
                                  : '${fidelFamilies[level - 1].first} to ${fidelFamilies[level - 1].last}')
                              : 'Locked',
                          style: TextStyle(
                            color: unlocked
                                ? const Color(0xFF078930)
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
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

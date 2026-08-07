import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../game_progress.dart';
import '../fidel_families.dart';

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

  int _mixedFamilyIndex(int boxIndex) {
    // A fixed 34-family permutation keeps the challenge mixed while making
    // sure every Fidel family appears exactly once.
    return (boxIndex * 7 + 3) % fidelFamilies.length;
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

    Navigator.pushNamed(
      context,
      AppRoutes.crossword,
      arguments: level,
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
              final int familyIndex = _mixedFamilyIndex(index);
              final int familyLevel = familyIndex + 1;
              final bool unlocked = GameProgress.isLevelUnlocked(familyLevel);
              final bool selected = GameProgress.currentLevel == familyLevel;

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openLevel(context, familyLevel),
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
                          'Level $level — ${fidelFamilyName(familyLevel)}',
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
                              ? '${fidelFamilies[familyIndex].first} to ${fidelFamilies[familyIndex].last}'
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

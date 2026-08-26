import 'package:flutter/material.dart';

import '../fidel_families.dart';
import '../game_progress.dart';
import 'crossword_screen.dart';

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
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _openLevel(int level) {
    GameProgress.selectLevel(level);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const CrosswordScreen(),
        settings: RouteSettings(arguments: level),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Easy Fidel Crosswords')),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          int columnCount = 3;
          if (constraints.maxWidth < 600) columnCount = 2;
          if (constraints.maxWidth < 380) columnCount = 1;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: totalFidelFamilies,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final int level = index + 1;
              final List<String> family = fidelFamilies[index];
              final bool selected = GameProgress.currentLevel == level;

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openLevel(level),
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
                      children: <Widget>[
                        const Icon(Icons.lock_open_rounded,
                            size: 34, color: Color(0xFF078930)),
                        const SizedBox(height: 10),
                        Text(
                          'Level $level — ${family.first}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${family.first} to ${family.last}',
                          style: const TextStyle(
                            color: Color(0xFF078930),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '7-letter crossword',
                          style: TextStyle(color: Color(0xFF78909C), fontSize: 12),
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

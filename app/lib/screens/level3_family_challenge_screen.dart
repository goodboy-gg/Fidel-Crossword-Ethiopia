import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../app/app_routes.dart';
import '../fidel_families.dart';
import '../game_progress.dart';

class Level3FamilyChallengeScreen extends StatefulWidget {
  const Level3FamilyChallengeScreen({super.key});

  @override
  State<Level3FamilyChallengeScreen> createState() =>
      _Level3FamilyChallengeScreenState();
}

class _Level3FamilyChallengeScreenState
    extends State<Level3FamilyChallengeScreen> {
  late List<List<String>> _answers;
  late List<List<String>> _mixedFamilies;
  bool _checked = false;
  int _correctFamilies = 0;

  static const List<List<int>> _mixPatterns = <List<int>>[
    <int>[0, 2, 5, 6, 1, 3, 4],
    <int>[0, 4, 6, 1, 2, 3, 5],
    <int>[0, 5, 1, 3, 2, 4, 6],
    <int>[0, 3, 6, 2, 5, 1, 4],
    <int>[0, 6, 3, 1, 5, 2, 4],
  ];

  @override
  void initState() {
    super.initState();
    _resetChallenge();
  }

  void _resetChallenge() {
    _answers = List<List<String>>.generate(
      fidelFamilies.length,
      (_) => <String>[],
    );
    _mixedFamilies = List<List<String>>.generate(
      fidelFamilies.length,
      (int familyIndex) {
        final List<String> family = fidelFamilies[familyIndex];
        final List<int> pattern =
            _mixPatterns[familyIndex % _mixPatterns.length];
        return pattern.map((int index) => family[index]).toList();
      },
    );
    _checked = false;
    _correctFamilies = 0;
  }

  int get _filledLetters =>
      _answers.fold<int>(0, (int total, List<String> row) => total + row.length);

  int get _totalLetters => fidelFamilies.length * 7;

  double get _progress => _filledLetters / _totalLetters;

  int get _score => _correctFamilies * 10;

  void _chooseLetter(int familyIndex, String letter) {
    if (_answers[familyIndex].length >= 7 ||
        _answers[familyIndex].contains(letter)) {
      return;
    }

    setState(() {
      _answers[familyIndex].add(letter);
      _checked = false;
    });
  }

  void _undoFamily(int familyIndex) {
    if (_answers[familyIndex].isEmpty) return;
    setState(() {
      _answers[familyIndex].removeLast();
      _checked = false;
    });
  }

  void _clearFamily(int familyIndex) {
    setState(() {
      _answers[familyIndex].clear();
      _checked = false;
    });
  }

  bool _familyIsCorrect(int familyIndex) {
    final List<String> answer = _answers[familyIndex];
    final List<String> correct = fidelFamilies[familyIndex];
    if (answer.length != 7) return false;
    for (int i = 0; i < 7; i++) {
      if (answer[i] != correct[i]) return false;
    }
    return true;
  }

  Future<void> _checkAllFamilies() async {
    int correct = 0;
    for (int i = 0; i < fidelFamilies.length; i++) {
      if (_familyIsCorrect(i)) correct++;
    }

    setState(() {
      _correctFamilies = correct;
      _checked = true;
    });

    if (correct == fidelFamilies.length) {
      await GameProgress.unlockNextLevel(3);
      if (!mounted) return;

      final AudioPlayer player = AudioPlayer();
      await player.play(AssetSource('sounds/level_complete.wav'));
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            icon: const Icon(
              Icons.emoji_events_rounded,
              size: 58,
              color: Color(0xFFF4C430),
            ),
            title: const Text(
              'Level 3 Complete!',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Excellent! You put all 34 Fidel families in the correct order. Score: $_score.',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  setState(_resetChallenge);
                },
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Play Again'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.pushReplacementNamed(context, AppRoutes.levels);
                },
                icon: const Icon(Icons.grid_view_rounded),
                label: const Text('Levels'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$correct of ${fidelFamilies.length} families are in the correct order.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075A32),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Fidel Crossword — Level 3',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          tooltip: 'Back to levels',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.levels),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset challenge',
            onPressed: () => setState(_resetChallenge),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 14),
            _buildInstructions(),
            const SizedBox(height: 16),
            ...List<Widget>.generate(
              fidelFamilies.length,
              (int index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFamilyCard(index),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _checkAllFamilies,
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text(
                'Check All 34 Families',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF078930),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF075A32), Color(0xFF0B8F46)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Level 3 — Mixed Fidel Families',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Put every family back into its correct 1–7 order.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFF4C430)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_filledLetters / $_totalLetters letters',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4C430), width: 1.5),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_rounded, color: Color(0xFF8A6800)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Each family has the same 7 letters you learned before, but they are mixed. Tap the letters in the correct order. Example: ሀ ሁ ሂ ሃ ሄ ህ ሆ.',
              style: TextStyle(color: Color(0xFF594300), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyCard(int familyIndex) {
    final List<String> family = fidelFamilies[familyIndex];
    final List<String> answer = _answers[familyIndex];
    final List<String> mixed = _mixedFamilies[familyIndex];
    final bool correct = _familyIsCorrect(familyIndex);
    final bool complete = answer.length == 7;

    Color borderColor = const Color(0xFFD5D9E0);
    if (_checked && correct) {
      borderColor = const Color(0xFF078930);
    } else if (_checked && complete && !correct) {
      borderColor = const Color(0xFFDA121A);
    }

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Family ${familyIndex + 1} — ${family.first}',
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Undo last letter',
                onPressed: answer.isEmpty ? null : () => _undoFamily(familyIndex),
                icon: const Icon(Icons.undo_rounded),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Clear this family',
                onPressed: answer.isEmpty ? null : () => _clearFamily(familyIndex),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List<Widget>.generate(7, (int index) {
              final String letter = index < answer.length ? answer[index] : '';
              Color boxColor = const Color(0xFFF7F8FA);
              Color boxBorder = const Color(0xFFB8C0CC);
              if (_checked && complete) {
                final bool right = answer[index] == family[index];
                boxColor = right
                    ? const Color(0xFFD8F3DC)
                    : const Color(0xFFFFD6D6);
                boxBorder = right
                    ? const Color(0xFF078930)
                    : const Color(0xFFDA121A);
              }
              return Container(
                width: 42,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: boxBorder, width: 1.5),
                ),
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: mixed.map((String letter) {
              final bool used = answer.contains(letter);
              return SizedBox(
                width: 44,
                height: 42,
                child: FilledButton(
                  onPressed:
                      used ? null : () => _chooseLetter(familyIndex, letter),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF075A32),
                    disabledBackgroundColor: const Color(0xFFE7E9ED),
                    disabledForegroundColor: const Color(0xFF9AA0AA),
                    side: const BorderSide(color: Color(0xFFB7D8C5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

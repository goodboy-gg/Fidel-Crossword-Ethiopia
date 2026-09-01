import 'package:flutter/material.dart';

import '../fidel_families.dart';

class MixedLevel3ChallengeScreen extends StatefulWidget {
  const MixedLevel3ChallengeScreen({super.key});

  @override
  State<MixedLevel3ChallengeScreen> createState() =>
      _MixedLevel3ChallengeScreenState();
}

class _MixedLevel3ChallengeScreenState
    extends State<MixedLevel3ChallengeScreen> {
  static const List<List<int>> _mixPatterns = <List<int>>[
    <int>[3, 6, 1, 5, 0, 4, 2],
    <int>[2, 5, 0, 4, 6, 1, 3],
    <int>[4, 1, 6, 2, 5, 0, 3],
    <int>[1, 4, 6, 0, 3, 5, 2],
    <int>[5, 2, 0, 6, 3, 1, 4],
    <int>[6, 3, 1, 5, 2, 4, 0],
    <int>[2, 6, 4, 0, 5, 3, 1],
  ];

  late List<List<String>> _answers;

  @override
  void initState() {
    super.initState();
    _answers = List<List<String>>.generate(
      fidelFamilies.length,
      (_) => List<String>.filled(7, ''),
    );
  }

  List<String> _mixedFamily(int familyIndex) {
    final List<String> family = fidelFamilies[familyIndex];
    final List<int> pattern = _mixPatterns[familyIndex % _mixPatterns.length];
    return pattern.map((int index) => family[index]).toList(growable: false);
  }

  bool _familyComplete(int familyIndex) {
    final List<String> entered = _answers[familyIndex];
    final List<String> family = fidelFamilies[familyIndex];
    for (int i = 0; i < 7; i++) {
      if (entered[i] != family[i]) return false;
    }
    return true;
  }

  void _chooseLetter(int familyIndex, String letter) {
    final List<String> entered = _answers[familyIndex];
    final int next = entered.indexWhere((String value) => value.isEmpty);
    if (next == -1 || entered.contains(letter)) return;

    setState(() {
      entered[next] = letter;
    });
  }

  void _undoFamily(int familyIndex) {
    final List<String> entered = _answers[familyIndex];
    int last = -1;
    for (int i = entered.length - 1; i >= 0; i--) {
      if (entered[i].isNotEmpty) {
        last = i;
        break;
      }
    }
    if (last == -1) return;

    setState(() {
      entered[last] = '';
    });
  }

  void _resetFamily(int familyIndex) {
    setState(() {
      _answers[familyIndex] = List<String>.filled(7, '');
    });
  }

  void _resetAll() {
    setState(() {
      _answers = List<List<String>>.generate(
        fidelFamilies.length,
        (_) => List<String>.filled(7, ''),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF172033),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Fidel Crossword — Level 3',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset all families',
            onPressed: _resetAll,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFCDD09).withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3C23A)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.lightbulb_rounded, color: Color(0xFF6D5A00)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Each family has the same 7 letters you learned before, but they are mixed. '
                      'Tap the letters in the correct order. Example: ሀ ሁ ሂ ሃ ሄ ህ ሆ.',
                      style: TextStyle(
                        color: Color(0xFF3A3420),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...List<Widget>.generate(
              fidelFamilies.length,
              (int familyIndex) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _FamilyCard(
                  familyNumber: familyIndex + 1,
                  family: fidelFamilies[familyIndex],
                  mixedLetters: _mixedFamily(familyIndex),
                  entered: _answers[familyIndex],
                  complete: _familyComplete(familyIndex),
                  onLetter: (String letter) =>
                      _chooseLetter(familyIndex, letter),
                  onUndo: () => _undoFamily(familyIndex),
                  onReset: () => _resetFamily(familyIndex),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({
    required this.familyNumber,
    required this.family,
    required this.mixedLetters,
    required this.entered,
    required this.complete,
    required this.onLetter,
    required this.onUndo,
    required this.onReset,
  });

  final int familyNumber;
  final List<String> family;
  final List<String> mixedLetters;
  final List<String> entered;
  final bool complete;
  final ValueChanged<String> onLetter;
  final VoidCallback onUndo;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: complete ? const Color(0xFFEAF7EE) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: complete ? const Color(0xFF078930) : const Color(0xFFD6DAE0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Family $familyNumber — ${family.first}',
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (complete)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.check_circle_rounded, color: Color(0xFF078930)),
                ),
              IconButton(
                tooltip: 'Undo last letter',
                onPressed: onUndo,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.undo_rounded),
              ),
              IconButton(
                tooltip: 'Reset this family',
                onPressed: onReset,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: List<Widget>.generate(
              7,
              (int index) => Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: complete
                        ? const Color(0xFF078930)
                        : const Color(0xFFABB3BF),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  entered[index],
                  style: const TextStyle(
                    color: Color(0xFF9D0B11),
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mixedLetters.map((String letter) {
              final bool used = entered.contains(letter);
              return SizedBox(
                width: 52,
                height: 48,
                child: OutlinedButton(
                  onPressed: used ? null : () => onLetter(letter),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: Color(0xFFC6CBD3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      color: Color(0xFF9D0B11),
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

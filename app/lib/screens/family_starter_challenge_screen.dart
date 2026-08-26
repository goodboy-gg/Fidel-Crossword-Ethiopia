import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../app/app_settings.dart';
import '../fidel_families.dart';

class FamilyStarterChallengeScreen extends StatefulWidget {
  const FamilyStarterChallengeScreen({super.key});

  @override
  State<FamilyStarterChallengeScreen> createState() =>
      _FamilyStarterChallengeScreenState();
}

class _FamilyStarterChallengeScreenState
    extends State<FamilyStarterChallengeScreen> {
  static const List<int> _mixedOrder = <int>[
    22, 4, 11, 32, 13, 0, 27, 19, 8, 31, 24,
    5, 17, 21, 3, 30, 9, 15, 28, 2, 23, 14,
    6, 26, 1, 29, 20, 12, 25, 10, 16, 18, 7,
  ];

  late final List<String> _answers;
  late final List<String> _mixedLetters;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  bool _answersChecked = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _answers = fidelFamilies.map((List<String> family) => family.first).toList();
    _mixedLetters = _mixedOrder.map((int i) => _answers[i]).toList();
    _reset();
  }

  void _reset() {
    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = null;
    _answersChecked = false;
    _score = 0;
  }

  void _selectCell(int index) {
    setState(() {
      _selectedIndex = index;
      _answersChecked = false;
    });
  }

  void _enterLetter(String letter) {
    final int? selected = _selectedIndex;
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a numbered box first.')),
      );
      return;
    }

    setState(() {
      _playerAnswers[selected] = letter;
      _answersChecked = false;
      for (int i = selected + 1; i < _playerAnswers.length; i++) {
        if (_playerAnswers[i].isEmpty) {
          _selectedIndex = i;
          return;
        }
      }
    });
  }

  Future<void> _checkAnswers() async {
    int correct = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_playerAnswers[i] == _answers[i]) correct++;
    }

    setState(() {
      _answersChecked = true;
      _score = correct * 10;
    });

    if (correct != _answers.length) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$correct of ${_answers.length} letters are correct.')),
      );
      return;
    }

    if (AppSettings.soundEnabled.value) {
      final AudioPlayer player = AudioPlayer();
      try {
        await player.play(AssetSource('sounds/level_complete.wav'));
      } catch (_) {
        // Completion still works if sound cannot be played.
      } finally {
        await player.dispose();
      }
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.emoji_events_rounded,
          size: 58,
          color: Color(0xFFF4C430),
        ),
        title: const Text('Challenge Complete!', textAlign: TextAlign.center),
        content: Text(
          'Excellent! You placed all ${_answers.length} Fidel families correctly and scored $_score points.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          FilledButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(_reset);
            },
            icon: const Icon(Icons.replay_rounded),
            label: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Color _cellColor(int index) {
    if (_selectedIndex == index) return const Color(0xFFFFE08A);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFFD8F3DC)
          : const Color(0xFFFFD6D6);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Level 4 — Challenge Yourself',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Put the 33 mixed Fidel family starters back into their correct numbered order.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 18),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _answers.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => _selectCell(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _cellColor(index),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedIndex == index
                                  ? const Color(0xFF6A1B9A)
                                  : Colors.grey.shade400,
                              width: _selectedIndex == index ? 3 : 1.5,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 5,
                                left: 7,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  _playerAnswers[index],
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Choose a Fidel letter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _mixedLetters.map((String letter) {
                      return SizedBox(
                        width: 56,
                        height: 50,
                        child: FilledButton(
                          onPressed: () => _enterLetter(letter),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6A1B9A),
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: Color(0xFFD1B3E0)),
                          ),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(_reset),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _checkAnswers,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF6A1B9A),
                          ),
                          icon: const Icon(Icons.check_circle_rounded),
                          label: const Text('Check Answers'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Score: $_score',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

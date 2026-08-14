import 'dart:math';

import 'package:flutter/material.dart';

import '../fidel_families.dart';

class Level3RedChallengeScreen extends StatefulWidget {
  const Level3RedChallengeScreen({super.key});

  @override
  State<Level3RedChallengeScreen> createState() =>
      _Level3RedChallengeScreenState();
}

class _Level3RedChallengeScreenState extends State<Level3RedChallengeScreen> {
  int _familyIndex = 0;
  late List<String> _answers;
  late List<String> _keyboard;
  late List<String> _playerAnswers;

  int? _selectedIndex;
  int _score = 0;
  bool _answersChecked = false;
  bool _familyCompleted = false;

  List<String> get _family => fidelFamilies[_familyIndex];

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    final List<String> family = _family;
    final List<String> distractorFamily =
        fidelFamilies[(_familyIndex + 1) % fidelFamilies.length];

    _answers = <String>[
      family[0], family[1], family[2], '#', '#',
      '#', '#', family[3], '#', '#',
      '#', '#', family[4], family[5], family[6],
      '#', '#', '#', '#', '#',
      '#', '#', '#', '#', '#',
    ];

    _keyboard = <String>[
      ...family,
      distractorFamily[0],
      distractorFamily[1],
      distractorFamily[2],
    ]..shuffle(Random());

    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = null;
    _score = 0;
    _answersChecked = false;
    _familyCompleted = false;
  }

  int get _playableCellCount =>
      _answers.where((String letter) => letter != '#').length;

  int get _filledCellCount {
    int count = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  double get _overallProgress =>
      (_familyIndex + (_filledCellCount / _playableCellCount)) /
      fidelFamilies.length;

  void _selectCell(int index) {
    if (_answers[index] == '#') return;
    setState(() {
      _selectedIndex = index;
      _answersChecked = false;
    });
  }

  void _enterLetter(String letter) {
    final int? selectedIndex = _selectedIndex;
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tap a white crossword square first.')),
      );
      return;
    }

    setState(() {
      _playerAnswers[selectedIndex] = letter;
      _answersChecked = false;
      _moveToNextCell();
    });
  }

  void _moveToNextCell() {
    final int? current = _selectedIndex;
    if (current == null) return;

    for (int i = current + 1; i < _answers.length; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }

    for (int i = 0; i < current; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }
  }

  void _clearSelectedCell() {
    final int? selectedIndex = _selectedIndex;
    if (selectedIndex == null) return;

    setState(() {
      _playerAnswers[selectedIndex] = '';
      _answersChecked = false;
      _familyCompleted = false;
    });
  }

  void _resetPuzzle() => setState(_loadPuzzle);

  void _checkAnswers() {
    int correct = 0;
    bool allFilled = true;

    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] == '#') continue;
      if (_playerAnswers[i].isEmpty) allFilled = false;
      if (_playerAnswers[i] == _answers[i]) correct++;
    }

    final bool completed = allFilled && correct == _playableCellCount;

    setState(() {
      _score = correct * 10;
      _answersChecked = true;
      _familyCompleted = completed;
    });

    if (completed) {
      _showFamilyCompleteDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$correct of $_playableCellCount letters are correct.'),
        ),
      );
    }
  }

  Future<void> _showFamilyCompleteDialog() async {
    final bool lastFamily = _familyIndex == fidelFamilies.length - 1;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.emoji_events_rounded,
            size: 56,
            color: Color(0xFFF4C430),
          ),
          title: Text(
            lastFamily ? 'Level 3 Complete!' : '${_family.first} Family Complete!',
            textAlign: TextAlign.center,
          ),
          content: Text(
            lastFamily
                ? 'Excellent! You completed all ${fidelFamilies.length} mixed Fidel family crosswords.'
                : 'Correct. Now continue to family ${_familyIndex + 2} of ${fidelFamilies.length}.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            if (!lastFamily)
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  setState(() {
                    _familyIndex++;
                    _loadPuzzle();
                  });
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next Family'),
              )
            else
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  setState(() {
                    _familyIndex = 0;
                    _loadPuzzle();
                  });
                },
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Play Again'),
              ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Home'),
            ),
          ],
        );
      },
    );
  }

  void _previousFamily() {
    if (_familyIndex == 0) return;
    setState(() {
      _familyIndex--;
      _loadPuzzle();
    });
  }

  Color _cellColor(int index) {
    if (_answers[index] == '#') return const Color(0xFF172033);
    if (_selectedIndex == index) return const Color(0xFFF4C430);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFFD8F3DC)
          : const Color(0xFFFFD6D6);
    }
    return Colors.white;
  }

  Color _borderColor(int index) {
    if (_selectedIndex == index) return const Color(0xFFDA121A);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFF078930)
          : const Color(0xFFDA121A);
    }
    return const Color(0xFFB8C0CC);
  }

  int _numberForIndex(int targetIndex) {
    int number = 0;
    for (int i = 0; i <= targetIndex; i++) {
      if (_answers[i] != '#') number++;
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDA121A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Fidel Crossword — Level 3',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Mix again',
            onPressed: _resetPuzzle,
            icon: const Icon(Icons.shuffle_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF8B1E1E), Color(0xFFDA121A)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Level 3 — Mixed Fidel Challenge',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Family ${_familyIndex + 1} of ${fidelFamilies.length} — ${_family.first} family',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _overallProgress,
                            minHeight: 10,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFF4C430),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4C7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF4C430)),
                    ),
                    child: Text(
                      'Put ${_family.join(' ')} into the seven white squares. The choices are mixed with three letters from the next family.',
                      style: const TextStyle(
                        color: Color(0xFF594300),
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: SizedBox(
                        height: 480,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _answers.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final bool blocked = _answers[index] == '#';
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: blocked ? null : () => _selectCell(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                decoration: BoxDecoration(
                                  color: _cellColor(index),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _borderColor(index),
                                    width: _selectedIndex == index ? 3 : 1.5,
                                  ),
                                ),
                                child: blocked
                                    ? null
                                    : Stack(
                                        children: <Widget>[
                                          Positioned(
                                            top: 5,
                                            left: 7,
                                            child: Text(
                                              '${_numberForIndex(index)}',
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
                                                color: Color(0xFF172033),
                                                fontSize: 30,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Choose from the mixed Fidel letters',
                    style: TextStyle(
                      color: Color(0xFF172033),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    alignment: WrapAlignment.center,
                    children: _keyboard.map((String letter) {
                      return SizedBox(
                        width: 67,
                        height: 57,
                        child: FilledButton(
                          onPressed: () => _enterLetter(letter),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF9D0B11),
                            elevation: 2,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                              side: const BorderSide(color: Color(0xFFE4B4B6)),
                            ),
                          ),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 25,
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
                          onPressed: _familyIndex == 0 ? null : _previousFamily,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Previous Family'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _resetPuzzle,
                          icon: const Icon(Icons.shuffle_rounded),
                          label: const Text('Mix Again'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _clearSelectedCell,
                    icon: const Icon(Icons.backspace_rounded),
                    label: const Text('Clear Selected'),
                  ),
                  const SizedBox(height: 11),
                  FilledButton.icon(
                    onPressed: _checkAnswers,
                    icon: const Icon(Icons.check_circle_rounded),
                    label: Text(
                      _familyCompleted ? 'Family Complete' : 'Check Answers',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFDA121A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(58),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

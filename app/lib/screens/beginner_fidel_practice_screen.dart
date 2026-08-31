import 'package:flutter/material.dart';

import '../fidel_families.dart';

class BeginnerFidelPracticeScreen extends StatefulWidget {
  const BeginnerFidelPracticeScreen({super.key});

  @override
  State<BeginnerFidelPracticeScreen> createState() =>
      _BeginnerFidelPracticeScreenState();
}

class _BeginnerFidelPracticeScreenState
    extends State<BeginnerFidelPracticeScreen> {
  late final List<String> _answers;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  bool _answersChecked = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _answers = fidelFamilies.expand((List<String> family) => family).toList();
    _reset();
  }

  void _reset() {
    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = 0;
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
    if (selected == null) return;

    setState(() {
      _playerAnswers[selected] = letter;
      _answersChecked = false;

      for (int i = selected + 1; i < _playerAnswers.length; i++) {
        if (_playerAnswers[i].isEmpty) {
          _selectedIndex = i;
          return;
        }
      }

      for (int i = 0; i < selected; i++) {
        if (_playerAnswers[i].isEmpty) {
          _selectedIndex = i;
          return;
        }
      }

      _selectedIndex = null;
    });
  }

  void _clearSelected() {
    final int? selected = _selectedIndex;
    if (selected == null) return;

    setState(() {
      _playerAnswers[selected] = '';
      _answersChecked = false;
    });
  }

  void _checkAnswers() {
    int correct = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_playerAnswers[i] == _answers[i]) correct++;
    }

    setState(() {
      _answersChecked = true;
      _score = correct * 10;
    });

    if (correct == _answers.length) {
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.school_rounded,
            size: 58,
            color: Color(0xFFF4C430),
          ),
          title: const Text(
            'Beginner Practice Complete!',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Excellent! You placed all ${_answers.length} Fidel letters in the correct order.\n\nScore: $_score',
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
              label: const Text('Practice Again'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('$correct of ${_answers.length} letters are correct.'),
          ),
        );
    }
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

  bool _isNextLetter(String letter) {
    final int? selected = _selectedIndex;
    if (selected == null) return false;
    return _answers[selected] == letter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF078930),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Begin Learning Fidel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF9CC7A4)),
                    ),
                    child: const Column(
                      children: <Widget>[
                        Text(
                          'STEP 1 — SEE • COPY • PLACE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Use the four guide panels to place all 231 Fidel letters in order. Tap ሀ for box 1, then ሁ for box 2, and continue.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, height: 1.25),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCompactGuide(),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'Copy the Fidel letters into boxes 1–231',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Score: $_score',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildAnswerGrid(),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearSelected,
                          icon: const Icon(Icons.backspace_rounded),
                          label: const Text('Clear Selected'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(_reset),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _checkAnswers,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF078930),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text(
                      'Check Answers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactGuide() {
    const List<List<int>> ranges = <List<int>>[
      <int>[0, 8],
      <int>[8, 16],
      <int>[16, 24],
      <int>[24, 33],
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double gap = 8;
        final double panelWidth;
        if (constraints.maxWidth >= 1000) {
          panelWidth = (constraints.maxWidth - (gap * 3)) / 4;
        } else if (constraints.maxWidth >= 650) {
          panelWidth = (constraints.maxWidth - gap) / 2;
        } else {
          panelWidth = constraints.maxWidth;
        }

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List<Widget>.generate(ranges.length, (int panelIndex) {
            final int start = ranges[panelIndex][0];
            final int end = ranges[panelIndex][1];
            return SizedBox(
              width: panelWidth,
              child: _buildGuidePanel(start, end),
            );
          }),
        );
      },
    );
  }

  Widget _buildGuidePanel(int start, int end) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE5DF)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Families ${start + 1}–$end',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF3E5B48),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          for (int familyIndex = start; familyIndex < end; familyIndex++)
            _buildFamilyRow(familyIndex),
        ],
      ),
    );
  }

  Widget _buildFamilyRow(int familyIndex) {
    final List<String> family = fidelFamilies[familyIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 22,
            child: Text(
              '${familyIndex + 1}.',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF65706F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 1,
              runSpacing: 1,
              children: family.map((String letter) {
                final bool nextLetter = _isNextLetter(letter);
                return InkWell(
                  onTap: () => _enterLetter(letter),
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: nextLetter
                          ? const Color(0xFFDDF4E3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: nextLetter
                          ? Border.all(color: const Color(0xFF078930))
                          : null,
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.0,
                        fontWeight:
                            nextLetter ? FontWeight.bold : FontWeight.w600,
                        color: const Color(0xFF17251D),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerGrid() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns;
        final double aspectRatio;
        if (constraints.maxWidth >= 900) {
          columns = 21;
          aspectRatio = 1.15;
        } else if (constraints.maxWidth >= 600) {
          columns = 14;
          aspectRatio = 1.1;
        } else {
          columns = 7;
          aspectRatio = 1.0;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _answers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => _selectCell(index),
              borderRadius: BorderRadius.circular(7),
              child: Container(
                decoration: BoxDecoration(
                  color: _cellColor(index),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: _selectedIndex == index
                        ? const Color(0xFF078930)
                        : const Color(0xFFB8C0CC),
                    width: _selectedIndex == index ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 2,
                      left: 3,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 7,
                          color: Color(0xFF65706F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        _playerAnswers[index],
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

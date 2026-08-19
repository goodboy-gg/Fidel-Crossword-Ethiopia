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
    _answers = fidelFamilies.expand((family) => family).toList(growable: false);
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
      ScaffoldMessenger.of(context).showSnackBar(
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
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
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
                    child: const Text(
                      'STEP 1 — SEE • COPY • PLACE\nTap ሀ for box 1, then ሁ for box 2, and continue in order. The next box is selected automatically.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth >= 1050) {
                        return _buildWideLearningLayout();
                      }
                      return _buildCompactLearningLayout();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideLearningLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 245,
          child: Column(
            children: <Widget>[
              _buildGuideCard(0, 8, 'Guide 1 • Families 1–8'),
              const SizedBox(height: 10),
              _buildGuideCard(16, 24, 'Guide 3 • Families 17–24'),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildPracticePanel(14)),
        const SizedBox(width: 12),
        SizedBox(
          width: 245,
          child: Column(
            children: <Widget>[
              _buildGuideCard(8, 16, 'Guide 2 • Families 9–16'),
              const SizedBox(height: 10),
              _buildGuideCard(24, 33, 'Guide 4 • Families 25–33'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLearningLayout() {
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            SizedBox(
              width: 290,
              child: _buildGuideCard(0, 8, 'Guide 1 • Families 1–8'),
            ),
            SizedBox(
              width: 290,
              child: _buildGuideCard(8, 16, 'Guide 2 • Families 9–16'),
            ),
            SizedBox(
              width: 290,
              child: _buildGuideCard(16, 24, 'Guide 3 • Families 17–24'),
            ),
            SizedBox(
              width: 290,
              child: _buildGuideCard(24, 33, 'Guide 4 • Families 25–33'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = constraints.maxWidth >= 760
                ? 14
                : constraints.maxWidth >= 520
                    ? 11
                    : 7;
            return _buildPracticePanel(columns);
          },
        ),
      ],
    );
  }

  Widget _buildPracticePanel(int columns) {
    final int filled = _playerAnswers.where((String value) => value.isNotEmpty).length;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE5DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Place the 231 Fidel letters in order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '$filled/231  •  Score: $_score',
                style: const TextStyle(
                  color: Color(0xFF466052),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildAnswerGrid(columns),
        ],
      ),
    );
  }

  Widget _buildGuideCard(int start, int end, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE5DF)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF078930),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          ...List<Widget>.generate(end - start, (int offset) {
            final int familyIndex = start + offset;
            final List<String> family = fidelFamilies[familyIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${familyIndex + 1}.',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF078930),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: family.map((String letter) {
                        return InkWell(
                          onTap: () => _enterLetter(letter),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
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
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerGrid(int columns) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _answers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => _selectCell(index),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color: _cellColor(index),
              borderRadius: BorderRadius.circular(6),
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
                    style: TextStyle(
                      fontSize: columns >= 14 ? 16 : 19,
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
  }

  Widget _buildControls() {
    return Row(
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
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: _checkAnswers,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF078930),
            ),
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text(
              'Check Answers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

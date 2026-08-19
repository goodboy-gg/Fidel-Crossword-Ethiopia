import 'dart:math';

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
  late final List<String> _letterBank;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  bool _answersChecked = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _answers = fidelFamilies.expand((family) => family).toList(growable: false);
    _letterBank = List<String>.from(_answers)..shuffle(Random(33));
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
        SnackBar(content: Text('$correct of ${_answers.length} letters are correct.')),
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
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF9CC7A4)),
                    ),
                    child: const Text(
                      'STEP 1 — SEE • COPY • PLACE\n\nUse the complete Fidel chart below as your guide. Then place the same 231 letters into the numbered boxes. You do not need to know them from memory yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Your Fidel Guide — all 33 families in order',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildReferenceChart(),
                  const SizedBox(height: 24),
                  const Text(
                    'Now copy the guide into the 231 numbered boxes',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildAnswerGrid(),
                  const SizedBox(height: 22),
                  const Text(
                    'Choose a Fidel letter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildLetterBank(),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearSelected,
                          icon: const Icon(Icons.backspace_rounded),
                          label: const Text('Clear Selected'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(_reset),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: _checkAnswers,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF078930),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text(
                      'Check Answers',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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

  Widget _buildReferenceChart() {
    return Column(
      children: List<Widget>.generate(fidelFamilies.length, (int familyIndex) {
        final List<String> family = fidelFamilies[familyIndex];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDE5DF)),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 34,
                child: Text(
                  '${familyIndex + 1}.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: family
                      .map(
                        (String letter) => Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnswerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _answers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => _selectCell(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: _cellColor(index),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedIndex == index
                    ? const Color(0xFF078930)
                    : const Color(0xFFB8C0CC),
                width: _selectedIndex == index ? 2.5 : 1,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 3,
                  left: 4,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 8,
                      color: Color(0xFF65706F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    _playerAnswers[index],
                    style: const TextStyle(
                      fontSize: 20,
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

  Widget _buildLetterBank() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: _letterBank.map((String letter) {
        return SizedBox(
          width: 48,
          height: 44,
          child: FilledButton(
            onPressed: () => _enterLetter(letter),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF075A32),
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Color(0xFFB7D8C5)),
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}

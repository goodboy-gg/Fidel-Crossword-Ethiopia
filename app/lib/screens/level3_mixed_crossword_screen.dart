import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../fidel_families.dart';
import '../game_progress.dart';

class Level3MixedCrosswordScreen extends StatefulWidget {
  const Level3MixedCrosswordScreen({super.key});

  @override
  State<Level3MixedCrosswordScreen> createState() =>
      _Level3MixedCrosswordScreenState();
}

class _Level3MixedCrosswordScreenState
    extends State<Level3MixedCrosswordScreen> {
  late List<String> _answers;
  late List<String> _keyboard;
  late List<String> _playerAnswers;

  int? _selectedIndex;
  int _score = 0;
  bool _answersChecked = false;
  bool _puzzleCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    _answers = fidelFamilies.map((List<String> family) => family.first).toList();
    _keyboard = List<String>.from(_answers)..shuffle(Random());

    if (_keyboard.length > 1 && _sameOrder(_keyboard, _answers)) {
      final String first = _keyboard.removeAt(0);
      _keyboard.add(first);
    }

    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = null;
    _score = 0;
    _answersChecked = false;
    _puzzleCompleted = false;
  }

  bool _sameOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int get _filledCellCount =>
      _playerAnswers.where((String letter) => letter.isNotEmpty).length;

  double get _progress =>
      _answers.isEmpty ? 0 : _filledCellCount / _answers.length;

  void _selectCell(int index) {
    setState(() {
      _selectedIndex = index;
      _answersChecked = false;
      _puzzleCompleted = false;
    });
  }

  void _enterLetter(String letter) {
    final int? selectedIndex = _selectedIndex;
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a numbered box first.')),
      );
      return;
    }

    setState(() {
      _playerAnswers[selectedIndex] = letter;
      _answersChecked = false;
      _puzzleCompleted = false;
      _moveToNextEmptyCell();
    });
  }

  void _moveToNextEmptyCell() {
    final int? current = _selectedIndex;
    if (current == null) return;

    for (int i = current + 1; i < _playerAnswers.length; i++) {
      if (_playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }

    for (int i = 0; i < current; i++) {
      if (_playerAnswers[i].isEmpty) {
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
      _puzzleCompleted = false;
    });
  }

  void _resetPuzzle() {
    setState(_loadPuzzle);
  }

  void _checkAnswers() {
    int correct = 0;
    bool allFilled = true;

    for (int i = 0; i < _answers.length; i++) {
      if (_playerAnswers[i].isEmpty) allFilled = false;
      if (_playerAnswers[i] == _answers[i]) correct++;
    }

    final bool completed = allFilled && correct == _answers.length;

    setState(() {
      _score = correct * 10;
      _answersChecked = true;
      _puzzleCompleted = completed;
    });

    if (completed) {
      _showCompletionDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$correct of ${_answers.length} boxes are correct.'),
        ),
      );
    }
  }

  Future<void> _showCompletionDialog() async {
    await GameProgress.unlockNextLevel(3);
    if (!mounted) return;

    final AudioPlayer player = AudioPlayer();
    try {
      await player.play(AssetSource('sounds/level_complete.wav'));
    } catch (_) {
      // The reward dialog still works if audio is unavailable.
    }

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
            'Excellent! You put all ${_answers.length} Fidel family starters in the correct order and scored $_score points.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FilledButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _resetPuzzle();
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Play Again'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await GameProgress.selectLevel(4);
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.crossword,
                  arguments: 4,
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Next Level'),
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
  }

  Color _boxColor(int index) {
    if (_selectedIndex == index) return const Color(0xFFF4C430);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFFD8F3DC)
          : const Color(0xFFFFD6D6);
    }
    return Colors.white;
  }

  Color _borderColor(int index) {
    if (_selectedIndex == index) return const Color(0xFF078930);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFF078930)
          : const Color(0xFFDA121A);
    }
    return const Color(0xFFB8C0CC);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E1E),
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
            tooltip: 'New mixed puzzle',
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
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildInstructions(),
                  const SizedBox(height: 18),
                  _buildAnswerGrid(),
                  const SizedBox(height: 20),
                  const Row(
                    children: <Widget>[
                      Icon(Icons.shuffle_rounded, color: Color(0xFF8B1E1E)),
                      SizedBox(width: 8),
                      Text(
                        'Mixed Fidel family starters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildKeyboard(),
                  const SizedBox(height: 18),
                  _buildActions(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF8B1E1E), Color(0xFFB52A2A)],
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
                      'Level 3 — Mixed Family Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'The learning help is gone — solve the family order from memory.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
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
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFF4C430)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_filledCellCount / ${_answers.length} boxes',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4C430), width: 1.5),
      ),
      child: Text(
        'All ${_answers.length} Fidel family starters are mixed. Tap a numbered box, then choose the correct family starter. Put every family back in the correct order from 1 to ${_answers.length}.',
        style: const TextStyle(
          color: Color(0xFF594300),
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAnswerGrid() {
    final int columns = MediaQuery.sizeOf(context).width < 500 ? 5 : 6;
    final int rows = (_answers.length / columns).ceil();

    return SizedBox(
      height: rows * 72.0,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _answers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _selectCell(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                color: _boxColor(index),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _borderColor(index),
                  width: _selectedIndex == index ? 3 : 1.5,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 4,
                    left: 6,
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
                        color: Color(0xFF172033),
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
    );
  }

  Widget _buildKeyboard() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _keyboard.map((String letter) {
        return SizedBox(
          width: 54,
          height: 50,
          child: FilledButton(
            onPressed: () => _enterLetter(letter),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF8B1E1E),
              elevation: 2,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE0B7B7)),
              ),
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActions() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearSelectedCell,
                icon: const Icon(Icons.backspace_rounded),
                label: const Text('Clear'),
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
        const SizedBox(height: 11),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _checkAnswers,
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text(
              'Check Answers',
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
        ),
        if (_answersChecked && !_puzzleCompleted) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            'Green boxes are correct. Red boxes need another try.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

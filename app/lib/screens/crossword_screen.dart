import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../app/app_routes.dart';
import '../game_progress.dart';
import '../fidel_families.dart';

class CrosswordScreen extends StatefulWidget {
  const CrosswordScreen({super.key});

  @override
  State<CrosswordScreen> createState() => _CrosswordScreenState();
}

class _CrosswordScreenState extends State<CrosswordScreen> {
  int _level = 1;
  bool _levelLoaded = false;
  late _PuzzleData _puzzle;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  int _score = 0;
  bool _answersChecked = false;
  bool _puzzleCompleted = false;

  static const List<List<int>> _levelLayouts = <List<int>>[
    <int>[0, 1, 2, 7, 12, 13, 14],
    <int>[2, 7, 10, 11, 12, 17, 22],
    <int>[4, 9, 10, 11, 12, 13, 14],
    <int>[0, 5, 10, 11, 12, 17, 22],
    <int>[4, 9, 12, 13, 14, 17, 22],
    <int>[0, 1, 6, 11, 12, 17, 18],
    <int>[2, 3, 4, 9, 14, 19, 24],
    <int>[0, 5, 6, 7, 12, 17, 22],
    <int>[3, 8, 11, 12, 13, 18, 23],
    <int>[1, 6, 10, 11, 12, 16, 21],
    <int>[0, 5, 10, 15, 20, 21, 22],
    <int>[2, 7, 12, 13, 14, 19, 24],
  ];

  static final List<_PuzzleData> _puzzles =
      List<_PuzzleData>.generate(fidelFamilies.length, (int index) {
    final List<String> family = fidelFamilies[index];
    final List<String> previousFamily =
        fidelFamilies[(index - 1 + fidelFamilies.length) % fidelFamilies.length];

    if (index == 2) {
      return _PuzzleData(
        title: 'Level 3 — Mixed Family Challenge',
        subtitle: 'Review seven different Fidel families together.',
        instruction:
            'Place the seven family letters in the correct order: ሀ, ለ, ሐ, መ, ሠ, ረ, ሰ.',
        answers: _answersForLayout(
          _levelLayouts[2],
          const <String>['ሀ', 'ለ', 'ሐ', 'መ', 'ሠ', 'ረ', 'ሰ'],
        ),
        keyboard: const <String>[
          'ረ', 'ሀ', 'ሠ', 'ሐ', 'ሰ', 'ለ', 'መ', 'ሑ', 'ሙ', 'ሱ',
        ],
      );
    }

    final List<int> layout = _levelLayouts[index % _levelLayouts.length];

    return _PuzzleData(
      title: 'Level ${index + 1} — ${family.first} Family',
      subtitle: 'Learn the seven forms of ${family.first}.',
      instruction:
          'Complete the ${family.first} family from ${family.first} to ${family.last}.',
      answers: _answersForLayout(layout, family),
      keyboard: <String>[
        ...family,
        previousFamily[0],
        previousFamily[1],
        previousFamily[2],
      ],
    );
  });

  static List<String> _answersForLayout(
    List<int> positions,
    List<String> letters,
  ) {
    final List<String> answers = List<String>.filled(25, '#');
    for (int i = 0; i < 7; i++) {
      answers[positions[i]] = letters[i];
    }
    return answers;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_levelLoaded) return;

    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is int && arguments >= 1 && arguments <= _puzzles.length) {
      _level = arguments;
    } else {
      _level = GameProgress.currentLevel;
      if (_level < 1 || _level > _puzzles.length) {
        _level = 1;
      }
    }

    _loadPuzzle();
    _levelLoaded = true;
  }

  void _loadPuzzle() {
    _puzzle = _puzzles[_level - 1];
    _playerAnswers = List<String>.filled(_puzzle.answers.length, '');
    _selectedIndex = null;
    _score = 0;
    _answersChecked = false;
    _puzzleCompleted = false;
  }

  int get _playableCellCount =>
      _puzzle.answers.where((String letter) => letter != '#').length;

  int get _filledCellCount {
    int count = 0;
    for (int i = 0; i < _puzzle.answers.length; i++) {
      if (_puzzle.answers[i] != '#' && _playerAnswers[i].isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  double get _progress =>
      _playableCellCount == 0 ? 0 : _filledCellCount / _playableCellCount;

  void _selectCell(int index) {
    if (_puzzle.answers[index] == '#') return;
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
        const SnackBar(content: Text('Select a white crossword square first.')),
      );
      return;
    }

    setState(() {
      _playerAnswers[selectedIndex] = letter;
      _answersChecked = false;
      _puzzleCompleted = false;
      _moveToNextCell();
    });
  }

  void _moveToNextCell() {
    final int? currentIndex = _selectedIndex;
    if (currentIndex == null) return;

    for (int i = currentIndex + 1; i < _puzzle.answers.length; i++) {
      if (_puzzle.answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }
    for (int i = 0; i < currentIndex; i++) {
      if (_puzzle.answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }
  }

  void _clearSelectedCell() {
    final int? selectedIndex = _selectedIndex;
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a square that you want to clear.')),
      );
      return;
    }

    setState(() {
      _playerAnswers[selectedIndex] = '';
      _answersChecked = false;
      _puzzleCompleted = false;
    });
  }

  void _resetPuzzle() => setState(_loadPuzzle);

  void _checkAnswers() {
    int correctAnswers = 0;
    bool everyCellIsFilled = true;

    for (int i = 0; i < _puzzle.answers.length; i++) {
      if (_puzzle.answers[i] == '#') continue;
      if (_playerAnswers[i].isEmpty) everyCellIsFilled = false;
      if (_playerAnswers[i] == _puzzle.answers[i]) correctAnswers++;
    }

    final bool completed =
        everyCellIsFilled && correctAnswers == _playableCellCount;

    setState(() {
      _score = correctAnswers * 10;
      _answersChecked = true;
      _puzzleCompleted = completed;
    });

    if (completed) {
      _showCompletionDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$correctAnswers of $_playableCellCount letters are correct.'),
        ),
      );
    }
  }

  Future<void> _showCompletionDialog() async {
    await GameProgress.unlockNextLevel(_level);
    if (!mounted) return;

    final bool hasNextLevel = _level < GameProgress.totalLevels;
    final AudioPlayer celebrationPlayer = AudioPlayer();
    await celebrationPlayer.play(AssetSource('sounds/level_complete.wav'));
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
          title: const Text('Puzzle Complete!', textAlign: TextAlign.center),
          content: Text(
            'Excellent! You completed Level $_level and scored $_score points.',
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
            if (hasNextLevel)
              FilledButton.icon(
                onPressed: () async {
                  final int nextLevel = _level + 1;
                  await GameProgress.selectLevel(nextLevel);
                  if (!mounted) return;
                  Navigator.of(dialogContext).pop();
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.crossword,
                    arguments: nextLevel,
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

  Color _cellBackgroundColor(int index) {
    if (_puzzle.answers[index] == '#') return const Color(0xFF172033);
    if (_selectedIndex == index) return const Color(0xFFF4C430);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      if (_playerAnswers[index] == _puzzle.answers[index]) {
        return const Color(0xFFD8F3DC);
      }
      return const Color(0xFFFFD6D6);
    }
    return Colors.white;
  }

  Color _cellBorderColor(int index) {
    if (_selectedIndex == index) return const Color(0xFF078930);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      if (_playerAnswers[index] == _puzzle.answers[index]) {
        return const Color(0xFF078930);
      }
      return const Color(0xFFDA121A);
    }
    return const Color(0xFFB8C0CC);
  }

  @override
  Widget build(BuildContext context) {
    if (!_levelLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075A32),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Fidel Crossword — Level $_level',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          tooltip: 'Back to levels',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.levels),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset puzzle',
            onPressed: _resetPuzzle,
            icon: const Icon(Icons.refresh_rounded),
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
                  _buildInformationCard(),
                  const SizedBox(height: 18),
                  _buildInstructionsCard(),
                  const SizedBox(height: 18),
                  _buildCrosswordGrid(),
                  const SizedBox(height: 20),
                  _buildKeyboardHeading(),
                  const SizedBox(height: 10),
                  _buildFidelKeyboard(),
                  const SizedBox(height: 18),
                  _buildActionButtons(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF075A32), Color(0xFF0B8F46)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _puzzle.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _puzzle.subtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF4C430)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_filledCellCount / $_playableCellCount letters',
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

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4C430), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.lightbulb_rounded, color: Color(0xFF8A6800), size: 29),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Puzzle instructions',
                  style: TextStyle(
                    color: Color(0xFF594300),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_puzzle.instruction} Tap a white square and choose the correct Fidel letter below.',
                  style: const TextStyle(color: Color(0xFF594300), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _playableNumberForIndex(int targetIndex) {
    int number = 0;
    for (int i = 0; i <= targetIndex; i++) {
      if (_puzzle.answers[i] != '#') number++;
    }
    return number;
  }

  Widget _buildCrosswordGrid() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _puzzle.answers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (BuildContext context, int index) {
              final bool isBlocked = _puzzle.answers[index] == '#';
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: isBlocked ? null : () => _selectCell(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: _cellBackgroundColor(index),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _cellBorderColor(index),
                      width: _selectedIndex == index ? 3 : 1.5,
                    ),
                    boxShadow: isBlocked
                        ? null
                        : <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: isBlocked
                      ? null
                      : Stack(
                          children: <Widget>[
                            Positioned(
                              top: 5,
                              left: 7,
                              child: Text(
                                '${_playableNumberForIndex(index)}',
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
    );
  }

  Widget _buildKeyboardHeading() {
    return const Row(
      children: <Widget>[
        Icon(Icons.keyboard_rounded, color: Color(0xFF075A32)),
        SizedBox(width: 8),
        Text(
          'Choose a Fidel letter',
          style: TextStyle(
            color: Color(0xFF172033),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFidelKeyboard() {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      alignment: WrapAlignment.center,
      children: _puzzle.keyboard.map((String letter) {
        return SizedBox(
          width: 67,
          height: 57,
          child: FilledButton(
            onPressed: () => _enterLetter(letter),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF075A32),
              elevation: 2,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
                side: const BorderSide(color: Color(0xFFB7D8C5)),
              ),
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearSelectedCell,
                icon: const Icon(Icons.backspace_rounded),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  foregroundColor: const Color(0xFF075A32),
                  side: const BorderSide(color: Color(0xFF075A32)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _resetPuzzle,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  foregroundColor: const Color(0xFFDA121A),
                  side: const BorderSide(color: Color(0xFFDA121A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
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
            'Green squares are correct. Red squares need another try.',
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

class _PuzzleData {
  const _PuzzleData({
    required this.title,
    required this.subtitle,
    required this.instruction,
    required this.answers,
    required this.keyboard,
  });

  final String title;
  final String subtitle;
  final String instruction;
  final List<String> answers;
  final List<String> keyboard;
}

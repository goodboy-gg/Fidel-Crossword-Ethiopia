import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../game_progress.dart';

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

  static _PuzzleData _familyPuzzle({
    required int level,
    required String family,
    required List<String> forms,
    required List<String> distractors,
  }) {
    return _PuzzleData(
      title: 'Level $level — $family Family',
      subtitle: 'Learn the seven forms of $family.',
      instruction:
          'Complete the $family family from ${forms.first} to ${forms.last}.',
      answers: <String>[
        forms[0], forms[1], forms[2], '#', '#',
        '#', '#', forms[3], '#', '#',
        '#', '#', forms[4], forms[5], forms[6],
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>[
        ...forms,
        ...distractors,
      ],
    );
  }

  static final List<_PuzzleData> _puzzles = <_PuzzleData>[
    _PuzzleData(
      title: 'Level 1 — ሀ Family',
      subtitle: 'Learn the seven forms of ሀ.',
      instruction: 'Complete the ሀ family from ሀ to ሆ.',
      answers: <String>[
        'ሀ', 'ሁ', 'ሂ', '#', '#',
        '#', '#', 'ሃ', '#', '#',
        '#', '#', 'ሄ', 'ህ', 'ሆ',
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>['ሀ', 'ሁ', 'ሂ', 'ሃ', 'ሄ', 'ህ', 'ሆ', 'ለ', 'ሉ', 'ሊ'],
    ),
    _PuzzleData(
      title: 'Level 2 — ለ Family',
      subtitle: 'Learn the seven forms of ለ.',
      instruction: 'Complete the ለ family from ለ to ሎ.',
      answers: <String>[
        '#', 'ለ', '#', '#', '#',
        '#', 'ሉ', '#', '#', '#',
        'ሊ', 'ላ', 'ሌ', '#', '#',
        '#', '#', 'ል', '#', '#',
        '#', '#', 'ሎ', '#', '#',
      ],
      keyboard: <String>['ለ', 'ሉ', 'ሊ', 'ላ', 'ሌ', 'ል', 'ሎ', 'ሀ', 'ሁ', 'ሂ'],
    ),
    _PuzzleData(
      title: 'Level 3 — ሐ Family',
      subtitle: 'Learn the seven forms of ሐ.',
      instruction: 'Complete the ሐ family from ሐ to ሖ.',
      answers: <String>[
        '#', '#', 'ሐ', '#', '#',
        '#', '#', 'ሑ', '#', '#',
        '#', 'ሒ', 'ሓ', 'ሔ', '#',
        '#', '#', 'ሕ', '#', '#',
        '#', '#', 'ሖ', '#', '#',
      ],
      keyboard: <String>['ሐ', 'ሑ', 'ሒ', 'ሓ', 'ሔ', 'ሕ', 'ሖ', 'ለ', 'ሉ', 'ሊ'],
    ),
    _PuzzleData(
      title: 'Level 4 — መ Family',
      subtitle: 'Learn the seven forms of መ.',
      instruction: 'Complete the መ family from መ to ሞ.',
      answers: <String>[
        'መ', '#', '#', '#', '#',
        'ሙ', '#', '#', '#', '#',
        'ሚ', 'ማ', 'ሜ', 'ም', 'ሞ',
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>['መ', 'ሙ', 'ሚ', 'ማ', 'ሜ', 'ም', 'ሞ', 'ሐ', 'ሑ', 'ሒ'],
    ),
    _PuzzleData(
      title: 'Level 5 — ሠ Family',
      subtitle: 'Learn the seven forms of ሠ.',
      instruction: 'Complete the ሠ family from ሠ to ሦ.',
      answers: <String>[
        '#', '#', '#', '#', 'ሠ',
        '#', '#', '#', '#', 'ሡ',
        'ሦ', 'ሥ', 'ሤ', 'ሣ', 'ሢ',
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>['ሠ', 'ሡ', 'ሢ', 'ሣ', 'ሤ', 'ሥ', 'ሦ', 'መ', 'ሙ', 'ሚ'],
    ),
    _PuzzleData(
      title: 'Level 6 — ረ Family',
      subtitle: 'Learn the seven forms of ረ.',
      instruction: 'Complete the ረ family from ረ to ሮ.',
      answers: <String>[
        '#', 'ረ', 'ሩ', 'ሪ', '#',
        '#', '#', 'ራ', '#', '#',
        '#', '#', 'ሬ', '#', '#',
        '#', '#', 'ር', '#', '#',
        '#', '#', 'ሮ', '#', '#',
      ],
      keyboard: <String>['ረ', 'ሩ', 'ሪ', 'ራ', 'ሬ', 'ር', 'ሮ', 'ሠ', 'ሡ', 'ሢ'],
    ),
    _PuzzleData(
      title: 'Level 7 — ሰ Family',
      subtitle: 'Learn the seven forms of ሰ.',
      instruction: 'Complete the ሰ family from ሰ to ሶ.',
      answers: <String>[
        '#', '#', 'ሰ', '#', '#',
        '#', '#', 'ሱ', '#', '#',
        'ሲ', 'ሳ', 'ሴ', 'ስ', 'ሶ',
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>['ሰ', 'ሱ', 'ሲ', 'ሳ', 'ሴ', 'ስ', 'ሶ', 'ረ', 'ሩ', 'ሪ'],
    ),
    _PuzzleData(
      title: 'Level 8 — ሸ Family',
      subtitle: 'Learn the seven forms of ሸ.',
      instruction: 'Complete the ሸ family from ሸ to ሾ.',
      answers: <String>[
        'ሸ', 'ሹ', 'ሺ', 'ሻ', 'ሼ',
        '#', '#', '#', '#', 'ሽ',
        '#', '#', '#', '#', 'ሾ',
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>['ሸ', 'ሹ', 'ሺ', 'ሻ', 'ሼ', 'ሽ', 'ሾ', 'ሰ', 'ሱ', 'ሲ'],
    ),
    _PuzzleData(
      title: 'Level 9 — ቀ Family',
      subtitle: 'Learn the seven forms of ቀ.',
      instruction: 'Complete the ቀ family from ቀ to ቆ.',
      answers: <String>[
        '#', '#', '#', '#', '#',
        '#', 'ቀ', '#', '#', '#',
        '#', 'ቁ', 'ቂ', 'ቃ', 'ቄ',
        '#', 'ቅ', '#', '#', '#',
        '#', 'ቆ', '#', '#', '#',
      ],
      keyboard: <String>['ቀ', 'ቁ', 'ቂ', 'ቃ', 'ቄ', 'ቅ', 'ቆ', 'ሸ', 'ሹ', 'ሺ'],
    ),
    _PuzzleData(
      title: 'Level 10 — በ Family',
      subtitle: 'Learn the seven forms of በ.',
      instruction: 'Complete the በ family from በ to ቦ.',
      answers: <String>[
        '#', '#', 'በ', '#', '#',
        '#', '#', 'ቡ', '#', '#',
        '#', '#', 'ቢ', 'ባ', 'ቤ',
        '#', '#', 'ብ', '#', '#',
        '#', '#', 'ቦ', '#', '#',
      ],
      keyboard: <String>['በ', 'ቡ', 'ቢ', 'ባ', 'ቤ', 'ብ', 'ቦ', 'ቀ', 'ቁ', 'ቂ'],
    ),
    _PuzzleData(
      title: 'Level 11 — ተ Family',
      subtitle: 'Learn the seven forms of ተ.',
      instruction: 'Complete the ተ family from ተ to ቶ.',
      answers: <String>[
        'ተ', '#', '#', '#', '#',
        'ቱ', '#', '#', '#', '#',
        'ቲ', 'ታ', 'ቴ', '#', '#',
        '#', '#', 'ት', '#', '#',
        '#', '#', 'ቶ', '#', '#',
      ],
      keyboard: <String>['ተ', 'ቱ', 'ቲ', 'ታ', 'ቴ', 'ት', 'ቶ', 'በ', 'ቡ', 'ቢ'],
    ),
    _PuzzleData(
      title: 'Level 12 — ቸ Family',
      subtitle: 'Complete the final beginner family.',
      instruction: 'Complete the ቸ family from ቸ to ቾ.',
      answers: <String>[
        '#', '#', '#', 'ቸ', '#',
        '#', '#', '#', 'ቹ', '#',
        'ቾ', 'ች', 'ቼ', 'ቻ', 'ቺ',
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ],
      keyboard: <String>['ቸ', 'ቹ', 'ቺ', 'ቻ', 'ቼ', 'ች', 'ቾ', 'ተ', 'ቱ', 'ቲ'],
    ),
    _familyPuzzle(level: 13, family: 'ኀ', forms: <String>['ኀ', 'ኁ', 'ኂ', 'ኃ', 'ኄ', 'ኅ', 'ኆ'], distractors: <String>['ቸ', 'ቹ', 'ቺ']),
    _familyPuzzle(level: 14, family: 'ነ', forms: <String>['ነ', 'ኑ', 'ኒ', 'ና', 'ኔ', 'ን', 'ኖ'], distractors: <String>['ኀ', 'ኁ', 'ኂ']),
    _familyPuzzle(level: 15, family: 'ኘ', forms: <String>['ኘ', 'ኙ', 'ኚ', 'ኛ', 'ኜ', 'ኝ', 'ኞ'], distractors: <String>['ነ', 'ኑ', 'ኒ']),
    _familyPuzzle(level: 16, family: 'አ', forms: <String>['አ', 'ኡ', 'ኢ', 'ኣ', 'ኤ', 'እ', 'ኦ'], distractors: <String>['ኘ', 'ኙ', 'ኚ']),
    _familyPuzzle(level: 17, family: 'ከ', forms: <String>['ከ', 'ኩ', 'ኪ', 'ካ', 'ኬ', 'ክ', 'ኮ'], distractors: <String>['አ', 'ኡ', 'ኢ']),
    _familyPuzzle(level: 18, family: 'ኸ', forms: <String>['ኸ', 'ኹ', 'ኺ', 'ኻ', 'ኼ', 'ኽ', 'ኾ'], distractors: <String>['ከ', 'ኩ', 'ኪ']),
    _familyPuzzle(level: 19, family: 'ወ', forms: <String>['ወ', 'ዉ', 'ዊ', 'ዋ', 'ዌ', 'ው', 'ዎ'], distractors: <String>['ኸ', 'ኹ', 'ኺ']),
    _familyPuzzle(level: 20, family: 'ዐ', forms: <String>['ዐ', 'ዑ', 'ዒ', 'ዓ', 'ዔ', 'ዕ', 'ዖ'], distractors: <String>['ወ', 'ዉ', 'ዊ']),
    _familyPuzzle(level: 21, family: 'ዘ', forms: <String>['ዘ', 'ዙ', 'ዚ', 'ዛ', 'ዜ', 'ዝ', 'ዞ'], distractors: <String>['ዐ', 'ዑ', 'ዒ']),
    _familyPuzzle(level: 22, family: 'ዠ', forms: <String>['ዠ', 'ዡ', 'ዢ', 'ዣ', 'ዤ', 'ዥ', 'ዦ'], distractors: <String>['ዘ', 'ዙ', 'ዚ']),
    _familyPuzzle(level: 23, family: 'የ', forms: <String>['የ', 'ዩ', 'ዪ', 'ያ', 'ዬ', 'ይ', 'ዮ'], distractors: <String>['ዠ', 'ዡ', 'ዢ']),
    _familyPuzzle(level: 24, family: 'ደ', forms: <String>['ደ', 'ዱ', 'ዲ', 'ዳ', 'ዴ', 'ድ', 'ዶ'], distractors: <String>['የ', 'ዩ', 'ዪ']),
    _familyPuzzle(level: 25, family: 'ጀ', forms: <String>['ጀ', 'ጁ', 'ጂ', 'ጃ', 'ጄ', 'ጅ', 'ጆ'], distractors: <String>['ደ', 'ዱ', 'ዲ']),
    _familyPuzzle(level: 26, family: 'ገ', forms: <String>['ገ', 'ጉ', 'ጊ', 'ጋ', 'ጌ', 'ግ', 'ጎ'], distractors: <String>['ጀ', 'ጁ', 'ጂ']),
    _familyPuzzle(level: 27, family: 'ጠ', forms: <String>['ጠ', 'ጡ', 'ጢ', 'ጣ', 'ጤ', 'ጥ', 'ጦ'], distractors: <String>['ገ', 'ጉ', 'ጊ']),
    _familyPuzzle(level: 28, family: 'ጨ', forms: <String>['ጨ', 'ጩ', 'ጪ', 'ጫ', 'ጬ', 'ጭ', 'ጮ'], distractors: <String>['ጠ', 'ጡ', 'ጢ']),
    _familyPuzzle(level: 29, family: 'ጰ', forms: <String>['ጰ', 'ጱ', 'ጲ', 'ጳ', 'ጴ', 'ጵ', 'ጶ'], distractors: <String>['ጨ', 'ጩ', 'ጪ']),
    _familyPuzzle(level: 30, family: 'ጸ', forms: <String>['ጸ', 'ጹ', 'ጺ', 'ጻ', 'ጼ', 'ጽ', 'ጾ'], distractors: <String>['ጰ', 'ጱ', 'ጲ']),
    _familyPuzzle(level: 31, family: 'ፀ', forms: <String>['ፀ', 'ፁ', 'ፂ', 'ፃ', 'ፄ', 'ፅ', 'ፆ'], distractors: <String>['ጸ', 'ጹ', 'ጺ']),
    _familyPuzzle(level: 32, family: 'ፈ', forms: <String>['ፈ', 'ፉ', 'ፊ', 'ፋ', 'ፌ', 'ፍ', 'ፎ'], distractors: <String>['ፀ', 'ፁ', 'ፂ']),
    _familyPuzzle(level: 33, family: 'ፐ', forms: <String>['ፐ', 'ፑ', 'ፒ', 'ፓ', 'ፔ', 'ፕ', 'ፖ'], distractors: <String>['ፈ', 'ፉ', 'ፊ']),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_levelLoaded) return;

    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is int && arguments >= 1 && arguments <= _puzzles.length) {
      _level = arguments;
    } else {
      _level = GameProgress.currentLevel;
      if (_level < 1 || _level > _puzzles.length) _level = 1;
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
    int filledCells = 0;
    for (int index = 0; index < _puzzle.answers.length; index++) {
      if (_puzzle.answers[index] != '#' && _playerAnswers[index].isNotEmpty) {
        filledCells++;
      }
    }
    return filledCells;
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
    for (int index = currentIndex + 1; index < _puzzle.answers.length; index++) {
      if (_puzzle.answers[index] != '#' && _playerAnswers[index].isEmpty) {
        _selectedIndex = index;
        return;
      }
    }
    for (int index = 0; index < currentIndex; index++) {
      if (_puzzle.answers[index] != '#' && _playerAnswers[index].isEmpty) {
        _selectedIndex = index;
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
    for (int index = 0; index < _puzzle.answers.length; index++) {
      if (_puzzle.answers[index] == '#') continue;
      if (_playerAnswers[index].isEmpty) everyCellIsFilled = false;
      if (_playerAnswers[index] == _puzzle.answers[index]) correctAnswers++;
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
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _puzzle.answers[index]
          ? const Color(0xFFD8F3DC)
          : const Color(0xFFFFD6D6);
    }
    if (_selectedIndex == index) return const Color(0xFFF4C430);
    return Colors.white;
  }

  Color _cellBorderColor(int index) {
    if (_selectedIndex == index) return const Color(0xFF078930);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _puzzle.answers[index]
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
        title: Text('Fidel Crossword — Level $_level'),
        centerTitle: true,
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
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildInstructionCard(),
                  const SizedBox(height: 18),
                  _buildCrosswordGrid(),
                  const SizedBox(height: 18),
                  _buildKeyboardHeading(),
                  const SizedBox(height: 10),
                  _buildFidelKeyboard(),
                  const SizedBox(height: 18),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF075A32), Color(0xFF078930)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
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
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF4C430)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Score: $_score',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4C430)),
      ),
      child: Text(
        _puzzle.instruction,
        style: const TextStyle(
          color: Color(0xFF594300),
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCrosswordGrid() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SizedBox(
          height: 480,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _puzzle.answers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final bool blocked = _puzzle.answers[index] == '#';
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: blocked ? null : () => _selectCell(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  decoration: BoxDecoration(
                    color: _cellBackgroundColor(index),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _cellBorderColor(index),
                      width: _selectedIndex == index ? 3 : 1.5,
                    ),
                  ),
                  child: blocked
                      ? null
                      : Center(
                          child: Text(
                            _playerAnswers[index],
                            style: const TextStyle(
                              color: Color(0xFF172033),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _resetPuzzle,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset'),
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
            ),
          ),
        ),
        if (_answersChecked && !_puzzleCompleted) ...<Widget>[
          const SizedBox(height: 12),
          const Text(
            'Green squares are correct. Red squares need another try.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
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

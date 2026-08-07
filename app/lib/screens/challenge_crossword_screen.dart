import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../fidel_families.dart';

class ChallengeCrosswordScreen extends StatefulWidget {
  const ChallengeCrosswordScreen({
    super.key,
    required this.level,
  });

  final int level;

  @override
  State<ChallengeCrosswordScreen> createState() =>
      _ChallengeCrosswordScreenState();
}

class _ChallengeCrosswordScreenState extends State<ChallengeCrosswordScreen> {
  late List<String> _answers;
  late List<String> _keyboard;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  int _score = 0;
  bool _answersChecked = false;
  bool _puzzleCompleted = false;

  List<String> get _family => fidelFamilies[widget.level - 1];

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    final List<String> family = _family;
    final List<String> previousFamily = fidelFamilies[
        (widget.level - 2 + fidelFamilies.length) % fidelFamilies.length];

    _answers = <String>[
      family[0], family[1], family[2], '#', '#',
      '#', '#', family[3], '#', '#',
      '#', '#', family[4], family[5], family[6],
      '#', '#', '#', '#', '#',
      '#', '#', '#', '#', '#',
    ];

    final List<String> choices = <String>[
      ...family,
      previousFamily[0],
      previousFamily[1],
      previousFamily[2],
    ];

    // Fixed mixed order: every challenge opens mixed, while the correct
    // family itself and crossword answers remain unchanged.
    const List<int> mixedOrder = <int>[4, 0, 8, 2, 6, 9, 1, 7, 5, 3];
    _keyboard = mixedOrder.map((int i) => choices[i]).toList();

    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = null;
    _score = 0;
    _answersChecked = false;
    _puzzleCompleted = false;
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

  double get _progress =>
      _playableCellCount == 0 ? 0 : _filledCellCount / _playableCellCount;

  void _selectCell(int index) {
    if (_answers[index] == '#') return;
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

    for (int i = currentIndex + 1; i < _answers.length; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }

    for (int i = 0; i < currentIndex; i++) {
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
      _puzzleCompleted = false;
    });
  }

  void _resetPuzzle() => setState(_loadPuzzle);

  void _checkAnswers() {
    int correctAnswers = 0;
    bool everyCellIsFilled = true;

    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] == '#') continue;
      if (_playerAnswers[i].isEmpty) everyCellIsFilled = false;
      if (_playerAnswers[i] == _answers[i]) correctAnswers++;
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
    final AudioPlayer celebrationPlayer = AudioPlayer();
    await celebrationPlayer.play(AssetSource('sounds/level_complete.wav'));
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.emoji_events_rounded,
            size: 58,
            color: Color(0xFFF4C430),
          ),
          title: const Text('Challenge Complete!', textAlign: TextAlign.center),
          content: Text(
            'Excellent! You solved the ${_family.first} family challenge and scored $_score points.',
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
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text('Challenges'),
            ),
          ],
        );
      },
    );
  }

  Color _cellBackgroundColor(int index) {
    if (_answers[index] == '#') return const Color(0xFF172033);
    if (_selectedIndex == index) return const Color(0xFFF4C430);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFFD8F3DC)
          : const Color(0xFFFFD6D6);
    }
    return Colors.white;
  }

  Color _cellBorderColor(int index) {
    if (_selectedIndex == index) return const Color(0xFFDA121A);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFF078930)
          : const Color(0xFFDA121A);
    }
    return const Color(0xFFB8C0CC);
  }

  int _playableNumberForIndex(int targetIndex) {
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
        title: Text(
          'Challenge ${widget.level} — ${_family.first} Family',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset challenge',
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
          colors: <Color>[Color(0xFF9D0B11), Color(0xFFDA121A)],
        ),
        borderRadius: BorderRadius.circular(22),
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
                      '${_family.first} Family Challenge',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'The letters are mixed. Put ${_family.first} to ${_family.last} in the correct crossword squares.',
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
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_rounded, color: Color(0xFF8A6800), size: 29),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tap a white square, then choose from the mixed Fidel letters below.',
              style: TextStyle(color: Color(0xFF594300), height: 1.4),
            ),
          ),
        ],
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
            itemCount: _answers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final bool isBlocked = _answers[index] == '#';
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
        Icon(Icons.shuffle_rounded, color: Color(0xFFDA121A)),
        SizedBox(width: 8),
        Text(
          'Choose from the mixed Fidel letters',
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
              backgroundColor: const Color(0xFFDA121A),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(58),
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

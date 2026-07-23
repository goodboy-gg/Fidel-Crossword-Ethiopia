import 'package:flutter/material.dart';

class CrosswordScreen extends StatefulWidget {

  const CrosswordScreen({super.key});

  @override

  State<CrosswordScreen> createState() => _CrosswordScreenState();

}

class _CrosswordScreenState extends State<CrosswordScreen> {

  // The # symbol represents a blocked crossword square.

  final List<String> _answers = <String>[

    'ሀ', 'ሁ', '#', 'ለ', 'ሉ',

    'ሂ', 'ሃ', '#', 'ሊ', 'ላ',

    '#', '#', '#', '#', '#',

    'መ', 'ሙ', '#', 'ሰ', 'ሱ',

    'ሚ', 'ማ', '#', 'ሲ', 'ሳ',

  ];

  final List<String> _playerAnswers =

      List<String>.filled(25, '');

  final List<String> _fidelKeyboard = <String>[

    'ሀ',

    'ሁ',

    'ሂ',

    'ሃ',

    'ለ',

    'ሉ',

    'ሊ',

    'ላ',

    'መ',

    'ሙ',

    'ሚ',

    'ማ',

    'ሰ',

    'ሱ',

    'ሲ',

    'ሳ',

  ];

  int? _selectedIndex;

  int _score = 0;

  bool _answersChecked = false;

  bool _puzzleCompleted = false;

  int get _playableCellCount {

    return _answers

        .where((String letter) => letter != '#')

        .length;

  }

  int get _filledCellCount {

    int filledCells = 0;

    for (int index = 0; index < _answers.length; index++) {

      if (_answers[index] != '#' &&

          _playerAnswers[index].isNotEmpty) {

        filledCells++;

      }

    }

    return filledCells;

  }

  double get _progress {

    if (_playableCellCount == 0) {

      return 0;

    }

    return _filledCellCount / _playableCellCount;

  }

  void _selectCell(int index) {

    if (_answers[index] == '#') {

      return;

    }

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

        const SnackBar(

          content: Text(

            'Select a white crossword square first.',

          ),

        ),

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

    if (currentIndex == null) {

      return;

    }

    // First, search forward for an empty playable cell.

    for (int index = currentIndex + 1;

        index < _answers.length;

        index++) {

      if (_answers[index] != '#' &&

          _playerAnswers[index].isEmpty) {

        _selectedIndex = index;

        return;

      }

    }

    // If necessary, return to the beginning.

    for (int index = 0; index < currentIndex; index++) {

      if (_answers[index] != '#' &&

          _playerAnswers[index].isEmpty) {

        _selectedIndex = index;

        return;

      }

    }

  }

  void _clearSelectedCell() {

    final int? selectedIndex = _selectedIndex;

    if (selectedIndex == null) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(

            'Select a square that you want to clear.',

          ),

        ),

      );

      return;

    }

    setState(() {

      _playerAnswers[selectedIndex] = '';

      _answersChecked = false;

      _puzzleCompleted = false;

    });

  }

  void _resetPuzzle() {

    setState(() {

      for (int index = 0;

          index < _playerAnswers.length;

          index++) {

        _playerAnswers[index] = '';

      }

      _selectedIndex = null;

      _score = 0;

      _answersChecked = false;

      _puzzleCompleted = false;

    });

  }

  void _checkAnswers() {

    int correctAnswers = 0;

    bool everyCellIsFilled = true;

    for (int index = 0; index < _answers.length; index++) {

      if (_answers[index] == '#') {

        continue;

      }

      if (_playerAnswers[index].isEmpty) {

        everyCellIsFilled = false;

      }

      if (_playerAnswers[index] == _answers[index]) {

        correctAnswers++;

      }

    }

    final bool completed =

        everyCellIsFilled &&

        correctAnswers == _playableCellCount;

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

          content: Text(

            '$correctAnswers of $_playableCellCount letters are correct.',

          ),

        ),

      );

    }

  }

  Future<void> _showCompletionDialog() async {

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

            'Puzzle Complete!',

            textAlign: TextAlign.center,

          ),

          content: Text(

            'Excellent work!\n\n'

            'You completed the first Fidel crossword.\n'

            'Your score is $_score points.',

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

              icon: const Icon(Icons.home_rounded),

              label: const Text('Main Menu'),

            ),

          ],

        );

      },

    );

  }

  Color _cellBackgroundColor(int index) {

    if (_answers[index] == '#') {

      return const Color(0xFF172033);

    }

    if (_selectedIndex == index) {

      return const Color(0xFFF4C430);

    }

    if (_answersChecked &&

        _playerAnswers[index].isNotEmpty) {

      if (_playerAnswers[index] == _answers[index]) {

        return const Color(0xFFD8F3DC);

      }

      return const Color(0xFFFFD6D6);

    }

    return Colors.white;

  }

  Color _cellBorderColor(int index) {

    if (_selectedIndex == index) {

      return const Color(0xFF078930);

    }

    if (_answersChecked &&

        _playerAnswers[index].isNotEmpty) {

      if (_playerAnswers[index] == _answers[index]) {

        return const Color(0xFF078930);

      }

      return const Color(0xFFDA121A);

    }

    return const Color(0xFFB8C0CC);

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(

        backgroundColor: const Color(0xFF075A32),

        foregroundColor: Colors.white,

        centerTitle: true,

        title: const Text(

          'Fidel Crossword',

          style: TextStyle(

            fontWeight: FontWeight.bold,

          ),

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

              constraints: const BoxConstraints(

                maxWidth: 720,

              ),

              child: Column(

                crossAxisAlignment:

                    CrossAxisAlignment.stretch,

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

          colors: <Color>[

            Color(0xFF075A32),

            Color(0xFF0B8F46),

          ],

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

              const Expanded(

                child: Column(

                  crossAxisAlignment:

                      CrossAxisAlignment.start,

                  children: <Widget>[

                    Text(

                      'Beginner Puzzle 1',

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 21,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    SizedBox(height: 5),

                    Text(

                      'Complete the Fidel families.',

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 15,

                      ),

                    ),

                  ],

                ),

              ),

              Container(

                padding: const EdgeInsets.symmetric(

                  horizontal: 14,

                  vertical: 9,

                ),

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

              backgroundColor:

                  Colors.white.withOpacity(0.25),

              valueColor:

                  const AlwaysStoppedAnimation<Color>(

                Color(0xFFF4C430),

              ),

            ),

          ),

          const SizedBox(height: 8),

          Align(

            alignment: Alignment.centerRight,

            child: Text(

              '$_filledCellCount / '

              '$_playableCellCount letters',

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

        border: Border.all(

          color: const Color(0xFFF4C430),

          width: 1.5,

        ),

      ),

      child: const Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[

          Icon(

            Icons.lightbulb_rounded,

            color: Color(0xFF8A6800),

            size: 29,

          ),

          SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:

                  CrossAxisAlignment.start,

              children: <Widget>[

                Text(

                  'Puzzle instructions',

                  style: TextStyle(

                    color: Color(0xFF594300),

                    fontSize: 17,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                SizedBox(height: 5),

                Text(

                  'Tap a white square and choose the '

                  'correct Fidel letter below. Complete '

                  'the ሀ, ለ, መ and ሰ families.',

                  style: TextStyle(

                    color: Color(0xFF594300),

                    height: 1.4,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

  // BLOCK 1 ENDS HERE.

  // PASTE BLOCK 2 DIRECTLY BELOW THIS LINE.

Widget _buildCrosswordGrid() {

    return Center(

      child: ConstrainedBox(

        constraints: const BoxConstraints(

          maxWidth: 480,

        ),

        child: AspectRatio(

          aspectRatio: 1,

          child: GridView.builder(

            physics: const NeverScrollableScrollPhysics(),

            itemCount: _answers.length,

            gridDelegate:

                const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 5,

              crossAxisSpacing: 5,

              mainAxisSpacing: 5,

            ),

            itemBuilder: (

              BuildContext context,

              int index,

            ) {

              final bool isBlocked =

                  _answers[index] == '#';

              return InkWell(

                borderRadius: BorderRadius.circular(10),

                onTap: isBlocked

                    ? null

                    : () => _selectCell(index),

                child: AnimatedContainer(

                  duration:

                      const Duration(milliseconds: 180),

                  decoration: BoxDecoration(

                    color: _cellBackgroundColor(index),

                    borderRadius: BorderRadius.circular(10),

                    border: Border.all(

                      color: _cellBorderColor(index),

                      width:

                          _selectedIndex == index ? 3 : 1.5,

                    ),

                    boxShadow: isBlocked

                        ? null

                        : <BoxShadow>[

                            BoxShadow(

                              color:

                                  Colors.black.withOpacity(0.08),

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

        Icon(

          Icons.keyboard_rounded,

          color: Color(0xFF075A32),

        ),

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

      children: _fidelKeyboard.map((String letter) {

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

                side: const BorderSide(

                  color: Color(0xFFB7D8C5),

                ),

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

                icon: const Icon(

                  Icons.backspace_rounded,

                ),

                label: const Text('Clear'),

                style: OutlinedButton.styleFrom(

                  minimumSize: const Size.fromHeight(52),

                  foregroundColor:

                      const Color(0xFF075A32),

                  side: const BorderSide(

                    color: Color(0xFF075A32),

                  ),

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

                icon: const Icon(

                  Icons.refresh_rounded,

                ),

                label: const Text('Reset'),

                style: OutlinedButton.styleFrom(

                  minimumSize: const Size.fromHeight(52),

                  foregroundColor:

                      const Color(0xFFDA121A),

                  side: const BorderSide(

                    color: Color(0xFFDA121A),

                  ),

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

            icon: const Icon(

              Icons.check_circle_rounded,

            ),

            label: const Text(

              'Check Answers',

              style: TextStyle(

                fontSize: 17,

                fontWeight: FontWeight.bold,

              ),

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

        if (_answersChecked &&

            !_puzzleCompleted) ...<Widget>[

          const SizedBox(height: 12),

          Text(

            'Green squares are correct. '

            'Red squares need another try.',

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
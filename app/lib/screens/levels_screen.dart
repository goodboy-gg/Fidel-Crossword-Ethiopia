import 'package:flutter/material.dart';

import '../game_progress.dart';
import '../fidel_families.dart';
import 'crossword_screen.dart';
import 'level3_red_challenge_screen.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
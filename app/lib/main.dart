import 'package:flutter/material.dart';

import 'app/fidel_crossword_app.dart';
import 'game_progress.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
await GameProgress.loadProgress();
  runApp(const FidelCrosswordApp());

}
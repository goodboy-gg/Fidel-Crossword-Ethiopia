import 'package:flutter/material.dart';

import 'app/app_settings.dart';
import 'app/fidel_crossword_app.dart';
import 'game_progress.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameProgress.loadProgress();
  await AppSettings.load();
  runApp(const FidelCrosswordApp());
}

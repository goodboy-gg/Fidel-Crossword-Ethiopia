import 'package:shared_preferences/shared_preferences.dart';

import 'fidel_families.dart';

class GameProgress {
  GameProgress._();

  static const int totalLevels = totalFidelFamilies;
  static const String _highestUnlockedKey = 'highest_unlocked_level';
  static const String _currentLevelKey = 'current_level';

  static int currentLevel = 1;
  static int highestUnlockedLevel = totalLevels;
  static bool _hasLoaded = false;

  static bool get hasLoaded => _hasLoaded;

  static Future<void> loadProgress() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    currentLevel = preferences.getInt(_currentLevelKey) ?? 1;
    highestUnlockedLevel =
        preferences.getInt(_highestUnlockedKey) ?? totalLevels;

    if (currentLevel < 1 || currentLevel > totalLevels) currentLevel = 1;
    if (highestUnlockedLevel < 1 || highestUnlockedLevel > totalLevels) {
      highestUnlockedLevel = totalLevels;
    }

    // Version 1 ships with all family levels open so learners may choose freely.
    highestUnlockedLevel = totalLevels;
    await preferences.setInt(_highestUnlockedKey, highestUnlockedLevel);
    _hasLoaded = true;
  }

  static bool isLevelUnlocked(int level) =>
      level >= 1 && level <= highestUnlockedLevel;

  static Future<void> selectLevel(int level) async {
    if (!isLevelUnlocked(level)) return;
    currentLevel = level;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_currentLevelKey, currentLevel);
  }

  static Future<void> unlockNextLevel(int completedLevel) async {
    final int nextLevel = completedLevel + 1;
    if (nextLevel > highestUnlockedLevel && nextLevel <= totalLevels) {
      highestUnlockedLevel = nextLevel;
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt(_highestUnlockedKey, highestUnlockedLevel);
    }
  }

  static Future<void> unlockAllLevels() async {
    highestUnlockedLevel = totalLevels;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_highestUnlockedKey, highestUnlockedLevel);
  }

  static Future<void> resetProgress() async {
    currentLevel = 1;
    highestUnlockedLevel = totalLevels;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_currentLevelKey, currentLevel);
    await preferences.setInt(_highestUnlockedKey, highestUnlockedLevel);
  }
}

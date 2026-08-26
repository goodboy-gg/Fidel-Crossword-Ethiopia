import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  AppSettings._();

  static const String _largeTextKey = 'large_text_enabled';
  static const String _soundKey = 'sound_enabled';

  static final ValueNotifier<bool> largeTextEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> soundEnabled = ValueNotifier<bool>(true);

  static Future<void> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    largeTextEnabled.value = preferences.getBool(_largeTextKey) ?? false;
    soundEnabled.value = preferences.getBool(_soundKey) ?? true;
  }

  static Future<void> setLargeText(bool enabled) async {
    largeTextEnabled.value = enabled;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_largeTextKey, enabled);
  }

  static Future<void> setSound(bool enabled) async {
    soundEnabled.value = enabled;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundKey, enabled);
  }
}

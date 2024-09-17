import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends ChangeNotifier {
  bool _showIntro;

  AppStateProvider({required bool hasSeenOnboarding})
      : _showIntro = !hasSeenOnboarding;

  bool get showIntro => _showIntro;

  Future<void> completeOnboarding() async {
    _showIntro = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }
}

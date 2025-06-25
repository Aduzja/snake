import 'package:shared_preferences/shared_preferences.dart';

class HighScoreService {
  static const String _highScoreKey = 'high_score';
  static const String _gamesPlayedKey = 'games_played';
  static const String _totalScoreKey = 'total_score';

  static HighScoreService? _instance;
  late SharedPreferences _prefs;

  HighScoreService._internal();

  static Future<HighScoreService> getInstance() async {
    _instance ??= HighScoreService._internal();
    _instance!._prefs = await SharedPreferences.getInstance();
    return _instance!;
  }

  int getHighScore() {
    return _prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<bool> setHighScore(int score) async {
    final currentHigh = getHighScore();
    if (score > currentHigh) {
      return await _prefs.setInt(_highScoreKey, score);
    }
    return false;
  }

  int getGamesPlayed() {
    return _prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  Future<void> incrementGamesPlayed() async {
    final current = getGamesPlayed();
    await _prefs.setInt(_gamesPlayedKey, current + 1);
  }

  int getTotalScore() {
    return _prefs.getInt(_totalScoreKey) ?? 0;
  }

  Future<void> addToTotalScore(int score) async {
    final current = getTotalScore();
    await _prefs.setInt(_totalScoreKey, current + score);
  }

  double getAverageScore() {
    final games = getGamesPlayed();
    final total = getTotalScore();
    return games > 0 ? total / games : 0.0;
  }

  Future<void> clearStats() async {
    await _prefs.remove(_highScoreKey);
    await _prefs.remove(_gamesPlayedKey);
    await _prefs.remove(_totalScoreKey);
  }
}

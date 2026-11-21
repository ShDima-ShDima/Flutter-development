import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _kA = 'last_a';
  static const _kB = 'last_b';
  static const _kC = 'last_c';

  /// Сохранить последние введённые коэффициенты
  Future<void> saveCoefficients(String a, String b, String c) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kA, a);
    await prefs.setString(_kB, b);
    await prefs.setString(_kC, c);
  }

  /// Прочитать последние коэффициенты (null — если не сохранены)
  Future<Map<String, String?>> loadCoefficients() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'a': prefs.getString(_kA),
      'b': prefs.getString(_kB),
      'c': prefs.getString(_kC),
    };
  }

  /// Очистить сохранённые коэффициенты
  Future<void> clearCoefficients() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kA);
    await prefs.remove(_kB);
    await prefs.remove(_kC);
  }
}
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/db_provider.dart';
import '../../../data/prefs_service.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  final DBProvider _db = DBProvider.db;
  final PrefsService _prefs = PrefsService();

  MainScreenCubit() : super(const MainScreenInitialState()) {
    _restoreCoefficients();
  }

  /// Восстановление последних коэффициентов из SharedPreferences
  Future<void> _restoreCoefficients() async {
    final saved = await _prefs.loadCoefficients();
    emit(MainScreenInitialState(
      lastA: saved['a'],
      lastB: saved['b'],
      lastC: saved['c'],
    ));
  }

  /// Валидация + расчёт + сохранение
  Future<void> solveEquation({
    required String aText,
    required String bText,
    required String cText,
  }) async {
    final a = _parse(aText);
    final b = _parse(bText);
    final c = _parse(cText);

    if (a == null || b == null || c == null) {
      emit(const MainScreenErrorState('Введите корректные числа во все поля'));
      return;
    }
    if (a == 0) {
      emit(const MainScreenErrorState('Коэффициент a не может быть 0'));
      return;
    }

    // --- Сохраняем введённые данные в SharedPreferences ---
    await _prefs.saveCoefficients(aText, bText, cText);

    // --- Расчёт ---
    final d = b * b - 4 * a * c;
    String resultText;
    double? x1;
    double? x2;

    if (d > 0) {
      x1 = (-b + sqrt(d)) / (2 * a);
      x2 = (-b - sqrt(d)) / (2 * a);
      resultText = 'D = ${_fmt(d)}\nx1 = ${_fmt(x1)}\nx2 = ${_fmt(x2)}';
    } else if (d == 0) {
      x1 = -b / (2 * a);
      resultText = 'D = 0\nx = ${_fmt(x1)}';
    } else {
      resultText = 'D = ${_fmt(d)}\nНет действительных корней';
    }

    // --- Метод записи в БД (п.4 порядка выполнения) ---
    await _saveToDb(a, b, c, d, resultText);

    emit(MainScreenResultState(
      a: a,
      b: b,
      c: c,
      discriminant: d,
      x1: x1,
      x2: x2,
      resultText: resultText,
    ));
  }

  /// Запись результата в SQflite
  Future<void> _saveToDb(
    double a,
    double b,
    double c,
    double d,
    String result,
  ) async {
    await _db.insertEquation({
      'a': a,
      'b': b,
      'c': c,
      'discriminant': d,
      'result': result,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Возврат к экрану ввода (с подстановкой сохранённых коэффициентов)
  Future<void> reset() async {
    final saved = await _prefs.loadCoefficients();
    emit(MainScreenInitialState(
      lastA: saved['a'],
      lastB: saved['b'],
      lastC: saved['c'],
    ));
  }

  double? _parse(String text) {
    final trimmed = text.trim().replaceAll(',', '.');
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(const MainScreenInitialState());

  /// Валидация и расчёт квадратного уравнения
  void solveEquation({
    required String aText,
    required String bText,
    required String cText,
  }) {
    // --- Валидация ---
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

  /// Возврат к экрану ввода
  void reset() {
    emit(const MainScreenInitialState());
  }

  // --- Вспомогательные методы ---
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
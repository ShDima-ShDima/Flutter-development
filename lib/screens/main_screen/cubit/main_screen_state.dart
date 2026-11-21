import 'package:equatable/equatable.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние — ввод коэффициентов
class MainScreenInitialState extends MainScreenState {
  const MainScreenInitialState();
}

/// Состояние ошибки (например, a == 0 или некорректные данные)
class MainScreenErrorState extends MainScreenState {
  final String message;

  const MainScreenErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Состояние с результатом решения уравнения
class MainScreenResultState extends MainScreenState {
  final double a;
  final double b;
  final double c;
  final double discriminant;
  final double? x1;
  final double? x2;
  final String resultText;

  const MainScreenResultState({
    required this.a,
    required this.b,
    required this.c,
    required this.discriminant,
    required this.resultText,
    this.x1,
    this.x2,
  });

  @override
  List<Object?> get props => [a, b, c, discriminant, x1, x2, resultText];
}
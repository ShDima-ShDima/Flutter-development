import 'package:equatable/equatable.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();
  @override
  List<Object?> get props => [];
}

class MainScreenInitialState extends MainScreenState {
  /// Восстановленные из SharedPreferences значения (null — если не было)
  final String? lastA;
  final String? lastB;
  final String? lastC;

  const MainScreenInitialState({this.lastA, this.lastB, this.lastC});

  @override
  List<Object?> get props => [lastA, lastB, lastC];
}

class MainScreenErrorState extends MainScreenState {
  final String message;
  const MainScreenErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

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
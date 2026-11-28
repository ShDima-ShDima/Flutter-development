import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  final List<WeatherModel> history;

  const WeatherLoaded({required this.weather, required this.history});

  @override
  List<Object?> get props => [weather, history];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
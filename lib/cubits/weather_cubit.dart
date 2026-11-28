import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _service = WeatherService();
  final Box<WeatherModel> _historyBox;

  WeatherCubit(this._historyBox) : super(WeatherInitial());

  List<WeatherModel> get history => _historyBox.values.toList().reversed.toList();

  Future<void> loadWeather(String city) async {
    emit(WeatherLoading());
    try {
      final weather = await _service.fetchWeather(city);
      await _historyBox.add(weather);
      emit(WeatherLoaded(weather: weather, history: history));
    } catch (e) {
      emit(WeatherError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> loadLast() async {
    if (_historyBox.isNotEmpty) {
      final last = _historyBox.values.last;
      emit(WeatherLoaded(weather: last, history: history));
    }
  }

  Future<void> clearHistory() async {
    await _historyBox.clear();
    if (state is WeatherLoaded) {
      final s = state as WeatherLoaded;
      emit(WeatherLoaded(weather: s.weather, history: []));
    }
  }
}
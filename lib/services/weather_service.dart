import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '261e7ea991a1b3b1a6c5ea3de691e8d9';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=ru',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return WeatherModel.fromJson(data, city);
    } else if (response.statusCode == 404) {
      throw Exception('Город не найден');
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }
}
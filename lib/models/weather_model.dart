import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0)
  final String city;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final double feelsLike;

  @HiveField(3)
  final int humidity;

  @HiveField(4)
  final double windSpeed;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final DateTime requestedAt;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.requestedAt,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    return WeatherModel(
      city: city,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      requestedAt: DateTime.now(),
    );
  }
}

// Модель для истории расчётов
@HiveType(typeId: 1)
class CalcHistoryItem extends HiveObject {
  @HiveField(0)
  final String input;

  @HiveField(1)
  final String result;

  @HiveField(2)
  final DateTime createdAt;

  CalcHistoryItem({
    required this.input,
    required this.result,
    required this.createdAt,
  });
}
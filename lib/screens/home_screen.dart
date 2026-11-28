import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubits/weather_cubit.dart';
import '../cubits/weather_state.dart';
import 'developer_screen.dart';
import 'calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController(text: 'Moscow');

  Future<void> _openWeatherSite() async {
    final uri = Uri.parse('https://openweathermap.org/city/524901');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            tooltip: 'Конвертер температур',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalculatorScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'О разработчике',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DeveloperScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Город',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<WeatherCubit>().loadWeather(_controller.text.trim()),
                      child: const Text('Найти'),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _openWeatherSite,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Открыть сайт погоды'),
              ),
              const Divider(),
              Expanded(child: _buildContent(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(WeatherState state) {
    if (state is WeatherLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is WeatherError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Ошибка: ${state.message}',
              style: const TextStyle(color: Colors.red)),
        ),
      );
    }
    if (state is WeatherLoaded) {
      final w = state.weather;
      return Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${w.city} — ${w.description}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Температура: ${w.temperature.toStringAsFixed(1)} °C'),
                  Text('Ощущается как: ${w.feelsLike.toStringAsFixed(1)} °C'),
                  Text('Влажность: ${w.humidity}%'),
                  Text('Ветер: ${w.windSpeed.toStringAsFixed(1)} м/с'),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('История запросов',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(
                onPressed: () => context.read<WeatherCubit>().clearHistory(),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Очистить'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (_, i) {
                final item = state.history[i];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('${item.city}: ${item.temperature.toStringAsFixed(1)} °C'),
                  subtitle: Text(
                    '${item.description} — ${_formatDate(item.requestedAt)}',
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    return const Center(child: Text('Введите город и нажмите «Найти»'));
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.'
      '${d.month.toString().padLeft(2, '0')}.'
      '${d.year} ${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}
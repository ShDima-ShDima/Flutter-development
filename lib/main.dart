import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/weather_model.dart';
import 'cubits/weather_cubit.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(WeatherModelAdapter());
  Hive.registerAdapter(CalcHistoryItemAdapter());

  final weatherBox = await Hive.openBox<WeatherModel>('weather_history');
  await Hive.openBox<CalcHistoryItem>('calc_history');

  runApp(MyApp(weatherBox: weatherBox));
}

class MyApp extends StatelessWidget {
  final Box<WeatherModel> weatherBox;
  const MyApp({super.key, required this.weatherBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(weatherBox)..loadLast(),
      child: MaterialApp(
        title: 'Weather Lab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
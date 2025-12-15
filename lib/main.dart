import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_converter/app.dart';
import 'package:weather_converter/models/weather_model.dart';
import 'package:weather_converter/models/conversion_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(WeatherDataAdapter());
  Hive.registerAdapter(ConversionHistoryAdapter());
  Hive.registerAdapter(ConversionTypeAdapter());
  
  await Hive.openBox<WeatherData>('weather_history');
  await Hive.openBox<ConversionHistory>('conversion_history');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погода + Конвертер',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const App(),
    );
  }
}
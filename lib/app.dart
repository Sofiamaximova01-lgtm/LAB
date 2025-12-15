import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_converter/cubit/weather_cubit.dart';
import 'package:weather_converter/screens/home_screen.dart';
import 'package:weather_converter/screens/developer_screen.dart';
import 'package:weather_converter/screens/converter_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(),
      child: MaterialApp(
        title: 'Погода + Конвертер',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/developer': (context) => const DeveloperScreen(),
          '/converter': (context) => const ConverterScreen(),
        },
      ),
    );
  }
}
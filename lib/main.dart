import 'package:flutter/material.dart';
import 'screens/bmi_screen_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ИМТ калькулятор',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BmiScreenProvider(),
    );
  }
}
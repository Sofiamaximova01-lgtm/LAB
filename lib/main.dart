import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/bmi_cubit.dart';
import 'cubit/history_cubit.dart';
import 'screens/bmi_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BmiCubit>(
          create: (context) => BmiCubit(),
        ),
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'ИМТ калькулятор',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const BmiScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
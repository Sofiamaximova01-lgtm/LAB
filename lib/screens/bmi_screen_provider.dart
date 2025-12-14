import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bmi_cubit.dart';
import 'bmi_screen.dart';

class BmiScreenProvider extends StatelessWidget {
  const BmiScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BmiCubit(),
      child: const BmiScreen(),
    );
  }
}
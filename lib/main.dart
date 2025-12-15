import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/screens/home_screen.dart';
import 'package:photo_gallery/cubits/photo_cubit.dart';
import 'package:photo_gallery/repositories/photo_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          centerTitle: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (context) => PhotoRepository(),
        child: BlocProvider(
          create: (context) => PhotoCubit(
            repository: context.read<PhotoRepository>(),
          )..loadPhotos(),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
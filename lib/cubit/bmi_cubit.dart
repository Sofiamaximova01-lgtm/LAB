import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_provider.dart';
import '../models/bmi_record.dart';

abstract class BmiState {}

class BmiInitial extends BmiState {}

class BmiInputState extends BmiState {
  final String weight;
  final String height;
  final bool isAgreed;

  BmiInputState({
    required this.weight,
    required this.height,
    required this.isAgreed,
  });

  BmiInputState copyWith({
    String? weight,
    String? height,
    bool? isAgreed,
  }) {
    return BmiInputState(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      isAgreed: isAgreed ?? this.isAgreed,
    );
  }
}

class BmiResultState extends BmiState {
  final double weight;
  final double height;
  final double bmi;
  final String bmiCategory;

  BmiResultState({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.bmiCategory,
  });
}

class BmiErrorState extends BmiState {
  final String message;
  final BmiInputState previousState;

  BmiErrorState(this.message, this.previousState);
}

class BmiCubit extends Cubit<BmiState> {
  final DBProvider _dbProvider = DBProvider();
  
  BmiCubit() : super(BmiInputState(
    weight: '',
    height: '',
    isAgreed: false,
  )) {
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWeight = prefs.getString('saved_weight') ?? '';
    final savedHeight = prefs.getString('saved_height') ?? '';
    final savedAgreement = prefs.getBool('saved_agreement') ?? false;

    emit(BmiInputState(
      weight: savedWeight,
      height: savedHeight,
      isAgreed: savedAgreement,
    ));
  }

  Future<void> _saveToPreferences(String weight, String height, bool isAgreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_weight', weight);
    await prefs.setString('saved_height', height);
    await prefs.setBool('saved_agreement', isAgreed);
  }

  Future<void> _saveToDatabase(double weight, double height, double bmi, String category) async {
    try {
      final record = BmiRecord(
        id: DateTime.now().millisecondsSinceEpoch,
        weight: weight,
        height: height,
        bmi: bmi,
        category: category,
        createdAt: DateTime.now(),
      );
      await _dbProvider.insertBmiRecord(record);
    } catch (e) {
      print('Ошибка сохранения в базу данных: $e');
    }
  }

  void updateWeight(String weightValue) {
    final currentState = state;
    if (currentState is BmiInputState) {
      final newState = currentState.copyWith(weight: weightValue);
      emit(newState);
      _saveToPreferences(weightValue, newState.height, newState.isAgreed);
    } else if (currentState is BmiErrorState) {
      final newState = currentState.previousState.copyWith(weight: weightValue);
      emit(newState);
      _saveToPreferences(weightValue, newState.height, newState.isAgreed);
    }
  }

  void updateHeight(String heightValue) {
    final currentState = state;
    if (currentState is BmiInputState) {
      final newState = currentState.copyWith(height: heightValue);
      emit(newState);
      _saveToPreferences(newState.weight, heightValue, newState.isAgreed);
    } else if (currentState is BmiErrorState) {
      final newState = currentState.previousState.copyWith(height: heightValue);
      emit(newState);
      _saveToPreferences(newState.weight, heightValue, newState.isAgreed);
    }
  }

  void updateAgreement(bool isAgreed) {
    final currentState = state;
    if (currentState is BmiInputState) {
      final newState = currentState.copyWith(isAgreed: isAgreed);
      emit(newState);
      _saveToPreferences(newState.weight, newState.height, isAgreed);
    } else if (currentState is BmiErrorState) {
      final newState = currentState.previousState.copyWith(isAgreed: isAgreed);
      emit(newState);
      _saveToPreferences(newState.weight, newState.height, isAgreed);
    }
  }

  void calculateBmi() {
    final currentState = state;
    
    BmiInputState inputState;
    
    if (currentState is BmiInputState) {
      inputState = currentState;
    } else if (currentState is BmiErrorState) {
      inputState = currentState.previousState;
    } else {
      emit(BmiErrorState('Неверное состояние', BmiInputState(
        weight: '',
        height: '',
        isAgreed: false,
      )));
      return;
    }

    if (!inputState.isAgreed) {
      emit(BmiErrorState('Необходимо согласие на обработку данных', inputState));
      return;
    }

    final weightStr = inputState.weight.trim();
    final heightStr = inputState.height.trim();

    if (weightStr.isEmpty || heightStr.isEmpty) {
      emit(BmiErrorState('Заполните все поля', inputState));
      return;
    }

    final weight = double.tryParse(weightStr);
    final height = double.tryParse(heightStr);

    if (weight == null || height == null) {
      emit(BmiErrorState('Введите корректные числа', inputState));
      return;
    }

    if (weight <= 0 || height <= 0) {
      emit(BmiErrorState('Вес и рост должны быть положительными числами', inputState));
      return;
    }

    double adjustedHeight = height > 4 ? height / 100 : height;
    double bmi = weight / (adjustedHeight * adjustedHeight);
    
    String category = _getBmiCategory(bmi);

    final result = BmiResultState(
      weight: weight,
      height: height,
      bmi: bmi,
      bmiCategory: category,
    );

    _saveToDatabase(weight, height, bmi, category);

    emit(result);
  }

  void returnToInput() {
    final currentState = state;
    if (currentState is BmiResultState) {
      emit(BmiInputState(
        weight: currentState.weight.toStringAsFixed(1),
        height: currentState.height.toStringAsFixed(1),
        isAgreed: true,
      ));
    } else if (currentState is BmiErrorState) {
      emit(currentState.previousState);
    } else {
      emit(BmiInputState(
        weight: '',
        height: '',
        isAgreed: false,
      ));
    }
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 16) return 'Выраженный дефицит массы тела';
    if (bmi < 18.5) return 'Недостаточная масса тела';
    if (bmi < 25) return 'Нормальная масса тела';
    if (bmi < 30) return 'Избыточная масса тела';
    if (bmi < 35) return 'Ожирение 1 степени';
    if (bmi < 40) return 'Ожирение 2 степени';
    return 'Ожирение 3 степени';
  }
}
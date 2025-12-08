import 'package:flutter_bloc/flutter_bloc.dart';

// Состояния
abstract class BmiState {}

class BmiInitial extends BmiState {}

class BmiInputState extends BmiState {
  final double? weight;
  final double? height;
  final bool isAgreed;

  BmiInputState({
    this.weight,
    this.height,
    required this.isAgreed,
  });

  BmiInputState copyWith({
    double? weight,
    double? height,
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

// Cubit
class BmiCubit extends Cubit<BmiState> {
  BmiCubit() : super(BmiInputState(isAgreed: false));

  // Обновление веса
  void updateWeight(String weightValue) {
    final currentState = state;
    if (currentState is BmiInputState) {
      final weight = double.tryParse(weightValue);
      emit(currentState.copyWith(weight: weight));
    } else if (currentState is BmiErrorState) {
      final weight = double.tryParse(weightValue);
      emit(currentState.previousState.copyWith(weight: weight));
    }
  }

  // Обновление роста
  void updateHeight(String heightValue) {
    final currentState = state;
    if (currentState is BmiInputState) {
      final height = double.tryParse(heightValue);
      emit(currentState.copyWith(height: height));
    } else if (currentState is BmiErrorState) {
      final height = double.tryParse(heightValue);
      emit(currentState.previousState.copyWith(height: height));
    }
  }

  // Обновление согласия
  void updateAgreement(bool isAgreed) {
    final currentState = state;
    if (currentState is BmiInputState) {
      emit(currentState.copyWith(isAgreed: isAgreed));
    } else if (currentState is BmiErrorState) {
      emit(currentState.previousState.copyWith(isAgreed: isAgreed));
    }
  }

  // Расчет ИМТ
  void calculateBmi() {
    final currentState = state;
    
    BmiInputState inputState;
    
    if (currentState is BmiInputState) {
      inputState = currentState;
    } else if (currentState is BmiErrorState) {
      inputState = currentState.previousState;
    } else {
      emit(BmiErrorState('Неверное состояние', BmiInputState(isAgreed: false)));
      return;
    }

    if (!inputState.isAgreed) {
      emit(BmiErrorState('Необходимо согласие на обработку данных', inputState));
      return;
    }

    final weight = inputState.weight;
    final height = inputState.height;

    if (weight == null || height == null) {
      emit(BmiErrorState('Заполните все поля', inputState));
      return;
    }

    if (weight <= 0 || height <= 0) {
      emit(BmiErrorState('Вес и рост должны быть положительными числами', inputState));
      return;
    }

    // Расчет ИМТ
    double adjustedHeight = height > 4 ? height / 100 : height;
    double bmi = weight / (adjustedHeight * adjustedHeight);
    
    String category = _getBmiCategory(bmi);

    emit(BmiResultState(
      weight: weight,
      height: height,
      bmi: bmi,
      bmiCategory: category,
    ));
  }

  // Возврат к вводу данных
  void returnToInput() {
    final currentState = state;
    if (currentState is BmiResultState) {
      emit(BmiInputState(
        weight: currentState.weight,
        height: currentState.height,
        isAgreed: true,
      ));
    } else if (currentState is BmiErrorState) {
      emit(currentState.previousState);
    } else {
      emit(BmiInputState(isAgreed: false));
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
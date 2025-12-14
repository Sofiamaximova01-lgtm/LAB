import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bmi_cubit.dart';
import 'history_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncControllersWithState(context.read<BmiCubit>().state);
    });
  }

  void _syncControllersWithState(BmiState state) {
    if (state is BmiInputState) {
      if (_weightController.text != state.weight) {
        _weightController.text = state.weight;
        _weightController.selection = TextSelection.collapsed(
          offset: state.weight.length,
        );
      }
      if (_heightController.text != state.height) {
        _heightController.text = state.height;
        _heightController.selection = TextSelection.collapsed(
          offset: state.height.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Максимова Софья Николаевна'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
        ),
      ),
      body: BlocConsumer<BmiCubit, BmiState>(
        listener: (context, state) {
          if (state is BmiErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          _syncControllersWithState(state);
        },
        builder: (context, state) {
          if (state is BmiInputState) {
            return _buildInputScreen(context, state);
          } else if (state is BmiResultState) {
            return _buildResultScreen(context, state);
          } else if (state is BmiErrorState) {
            return _buildInputScreen(context, state.previousState);
          } else {
            return _buildInputScreen(context, BmiInputState(
              weight: '',
              height: '',
              isAgreed: false,
            ));
          }
        },
      ),
    );
  }

  Widget _buildInputScreen(BuildContext context, BmiInputState state) {
    final cubit = context.read<BmiCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Калькулятор ИМТ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Введите данные:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Рост (см)',
              border: OutlineInputBorder(),
              hintText: 'Введите рост',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => cubit.updateHeight(value),
          ),
          const SizedBox(height: 15),
          
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Вес (кг)',
              border: OutlineInputBorder(),
              hintText: 'Введите вес',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => cubit.updateWeight(value),
          ),
          const SizedBox(height: 15),
          
          CheckboxListTile(
            title: const Text('Я согласен на обработку персональных данных'),
            value: state.isAgreed,
            onChanged: (bool? value) {
              cubit.updateAgreement(value ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 30),
          
          Center(
            child: ElevatedButton(
              onPressed: () => cubit.calculateBmi(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Рассчитать ИМТ'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, BmiResultState state) {
    final cubit = context.read<BmiCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Результаты расчёта ИМТ:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Уравнение: вес / рост²',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 15),
          Text(
            'Вес: ${state.weight} кг',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Рост: ${state.height} см',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'ИМТ: ${state.bmi.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Категория: ${state.bmiCategory}',
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 20),
          const Text(
            'Таблица ИМТ:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 82, 114, 80),
            child: Image.asset(
              'assets/Tabl.png', 
              height: 400,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Изображение таблицы не найдено\n\n'
                          'Таблица ИМТ:\n'
                          '• < 16 - Выраженный дефицит\n'
                          '• 16-18.5 - Недостаточная масса\n'
                          '• 18.5-25 - Норма\n'
                          '• 25-30 - Избыточная масса\n'
                          '• 30-35 - Ожирение 1 ст.\n'
                          '• 35-40 - Ожирение 2 ст.\n'
                          '• > 40 - Ожирение 3 ст.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => cubit.returnToInput(),
              child: const Text('Вернуться назад'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
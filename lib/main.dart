import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bmi_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
          title: Text('Легендарные моменты из легендарного мультфильма',
          style: TextStyle(
            fontSize: 30.0, 
          ),
          ),
          centerTitle: true,
        ),
        body: MyHomePage(),
      ),
<<<<<<< Updated upstream
=======
      home: BlocProvider(
        create: (context) => BmiCubit(),
        child: const BmiScreen(),
      ),
>>>>>>> Stashed changes
    );
  }
}

<<<<<<< Updated upstream
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
=======
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
    _syncControllersWithState(context.read<BmiCubit>().state);
  }

  void _syncControllersWithState(BmiState state) {
    if (state is BmiInputState) {
      if (state.weight != null && _weightController.text != state.weight.toString()) {
        _weightController.text = state.weight.toString();
        _weightController.selection = TextSelection.fromPosition(
          TextPosition(offset: _weightController.text.length),
        );
      }
      if (state.height != null && _heightController.text != state.height.toString()) {
        _heightController.text = state.height.toString();
        _heightController.selection = TextSelection.fromPosition(
          TextPosition(offset: _heightController.text.length),
        );
      }
    }
  }
>>>>>>> Stashed changes

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Center(
      child:SingleChildScrollView(
        
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 134, 108, 108),
            child: Image.asset(
              'logo_1.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 134, 108, 108),
            child: Image.asset(
              'logo_2.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Color.fromARGB(255, 42, 23, 146),
            child: Image.asset(
              'logo_3.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 42, 23, 146),
            child: Image.asset(
              'logo_4.jpg',
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 42, 23, 146),
            child: Image.asset(
              'logo_5.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 175, 14, 14),
            child: Image.asset(
              'logo_6.png', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 175, 14, 14),
            child: Image.asset(
              'logo_7.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
=======
    return Scaffold(
      appBar: AppBar(
        title: const Text('Максимова Софья Николаевна'),
        backgroundColor: Colors.green,
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
            return _buildInputScreen(context, BmiInputState(isAgreed: false));
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
          
          // Поле для роста
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Рост (см)',
              border: OutlineInputBorder(),
              hintText: 'Введите рост',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => cubit.updateHeight(value),
          ),
          const SizedBox(height: 15),
          
          // Поле для веса
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Вес (кг)',
              border: OutlineInputBorder(),
              hintText: 'Введите вес',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => cubit.updateWeight(value),
          ),
          const SizedBox(height: 15),
          
          // Чекбокс согласия
          CheckboxListTile(
            title: const Text('Я согласен на обработку персональных данных'),
            value: state.isAgreed,
            onChanged: (bool? value) {
              cubit.updateAgreement(value ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 30),
          
          // Кнопка расчета
          Center(
            child: ElevatedButton(
              onPressed: () => cubit.calculateBmi(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Рассчитать ИМТ'),
>>>>>>> Stashed changes
            ),
          ),
        ],
      ),
<<<<<<< Updated upstream
      )
=======
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
          Text(
            'Уравнение: вес / рост²',
            style: const TextStyle(fontSize: 18),
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
>>>>>>> Stashed changes
    );
  }
}
import 'package:flutter/material.dart';

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
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreen();
}

class _InputScreen extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  bool isAgreed = false;

  void _navigateToResults(BuildContext context) {
    if (_formKey.currentState!.validate() && isAgreed) {
      final double a = double.parse(aController.text);
      final double b = double.parse(bController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            a: a,
            b: b,
          ),
        ),
      );
    } else if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Необходимо согласие на обработку данных'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Максимова Софья Николаевна'), 
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              
              // Поле для коэффициента b
              TextFormField(
                controller: bController,
                decoration: const InputDecoration(
                  labelText: 'Рост',
                  border: OutlineInputBorder(),
                  hintText: 'Введите рост',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не может быть пустым';
                  }
                  final double? number = double.tryParse(value);
                  if (number == null) {
                    return 'Введите корректное число';
                  }
                  if (number <= 0) {
                    return 'Рост не может быть меньше нуля';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
              // Поле для коэффициента a
              TextFormField(
                controller: aController,
                decoration: const InputDecoration(
                  labelText: 'Вес',
                  border: OutlineInputBorder(),
                  hintText: 'Введите вес',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не может быть пустым';
                  }
                  final double? number = double.tryParse(value);
                  if (number == null) {
                    return 'Введите корректное число';
                  }
                  if (number <= 0) {
                    return 'Вес не может быть меньше нуля';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
             
              // Чекбокс согласия
              CheckboxListTile(
                title: const Text('Я согласен на обработку персональных данных'),
                value: isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    isAgreed = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 30),
              
              // Кнопка расчета
              Center(
                child: ElevatedButton(
                  onPressed: () => _navigateToResults(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Рассчитать коэффициент'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final double a;
  final double b;

  const ResultsScreen({
    super.key,
    required this.a,
    required this.b,
  });

  @override
  Widget build(BuildContext context) {
    final equationResults = _Equation(a, b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты расчета'),
        backgroundColor: Colors.lime,
      ),
      body: Padding(
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
              'Уравнение: a / b² ',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            Text(
              'ИМТ = ${equationResults['x']}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Таблица ИМТ:',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(8.0),
              color: const Color.fromARGB(255, 82, 114, 80),
              child: Image.asset(
                'Tabl.png', 
                height: 500,
                width: 750,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Вернуться назад'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _Equation(double a, double b) {
    if(b>4){
      b=b/100;
    }
    final x = a / (b*b) ;
      return {
      
      'x': x,
    };
  }
}
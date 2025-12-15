import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_converter/models/conversion_model.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  final _conversionBox = Hive.box<ConversionHistory>('conversion_history');
  bool _isCelsiusToFahrenheit = true;
  double _result = 0.0;

  void _convertTemperature() {
    final input = double.tryParse(_inputController.text);
    if (input == null) return;

    setState(() {
      if (_isCelsiusToFahrenheit) {
        _result = (input * 9 / 5) + 32;
      } else {
        _result = (input - 32) * 5 / 9;
      }
    });

    final conversion = ConversionHistory(
      type: _isCelsiusToFahrenheit 
          ? ConversionType.celsiusToFahrenheit 
          : ConversionType.fahrenheitToCelsius,
      inputValue: input,
      resultValue: _result,
      timestamp: DateTime.now(),
    );
    
    _conversionBox.add(conversion);
  }

  void _clearHistory() {
    _conversionBox.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер температур'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: [_isCelsiusToFahrenheit, !_isCelsiusToFahrenheit],
                      onPressed: (index) {
                        setState(() {
                          _isCelsiusToFahrenheit = index == 0;
                          _result = 0.0;
                          _inputController.clear();
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('°C → °F'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('°F → °C'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _isCelsiusToFahrenheit 
                            ? 'Введите температуру в °C'
                            : 'Введите температуру в °F',
                        border: const OutlineInputBorder(),
                        suffixText: _isCelsiusToFahrenheit ? '°C' : '°F',
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    ElevatedButton(
                      onPressed: _convertTemperature,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Конвертировать'),
                    ),
                    const SizedBox(height: 20),
                    
                    Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Результат:',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_result.toStringAsFixed(2)}${_isCelsiusToFahrenheit ? '°F' : '°C'}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'История конвертаций',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: _clearHistory,
                        tooltip: 'Очистить историю',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _conversionBox.listenable(),
                      builder: (context, Box<ConversionHistory> box, _) {
                        final history = box.values.toList();
                        history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                        
                        if (history.isEmpty) {
                          return const Center(
                            child: Text('Конвертаций не проводилось'),
                          );
                        }
                        
                        return ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final conversion = history[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.swap_horiz, color: Colors.green),
                                title: Text(
                                  '${conversion.inputValue.toStringAsFixed(1)} → '
                                  '${conversion.resultValue.toStringAsFixed(1)}',
                                ),
                                subtitle: Text(conversion.typeString),
                                trailing: Text(
                                  conversion.timestamp.toString().substring(11, 16),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
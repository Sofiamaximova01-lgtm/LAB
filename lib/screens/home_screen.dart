import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_converter/cubit/weather_cubit.dart';
import 'package:weather_converter/models/weather_model.dart';
import '../cubit/weather_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final _weatherBox = Hive.box<WeatherData>('weather_history');

  void _fetchWeather() {
    if (_cityController.text.isNotEmpty) {
      context.read<WeatherCubit>().fetchWeather(_cityController.text);
    }
  }

  void _openWeatherWebsite() async {
    const url = 'https://www.weather.gov';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удаётся открыть сайт')),
      );
    }
  }

void _clearWeatherHistory() {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Очистить историю'),
        content: const Text('Вы уверены, что хотите удалить всю историю поиска погоды?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              _weatherBox.clear(); 
              Navigator.pop(context);
              
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('История погоды очищена'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Очистить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода + Конвертер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/developer'),
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => Navigator.pushNamed(context, '/converter'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Введите город',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: const Text('Узнать погоду'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherError) {
                  return Card(
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 10),
                          Text('Ошибка: ${state.message}'),
                        ],
                      ),
                    ),
                  );
                } else if (state is WeatherLoaded) {
                  _weatherBox.put(state.weatherData.timestamp.toString(), state.weatherData);
                  
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            state.weatherData.city,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${state.weatherData.temperatureC.toStringAsFixed(1)}°C',
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '${state.weatherData.temperatureF.toStringAsFixed(1)}°F',
                                style: const TextStyle(fontSize: 32),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.weatherData.description,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Обновлено: ${state.weatherData.timestamp.toString().substring(0, 16)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.cloud, size: 48, color: Colors.blue),
                        SizedBox(height: 10),
                        Text('Введите город, чтобы узнать погоду'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: _openWeatherWebsite,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Открыть National Weather Service'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
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
                        'История поиска погоды',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        onPressed: _clearWeatherHistory,
                        tooltip: 'Очистить всю историю',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _weatherBox.listenable(),
                      builder: (context, Box<WeatherData> box, _) {
                        final history = box.values.toList();
                        history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                        
                        if (history.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history, size: 48, color: Colors.grey),
                                SizedBox(height: 10),
                                Text('История поиска пуста'),
                                Text('Начните искать погоду для разных городов'),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final weather = history[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.cloud, color: Colors.blue),
                                title: Text(weather.city),
                                subtitle: Text(
                                  '${weather.temperatureC.toStringAsFixed(1)}°C / '
                                  '${weather.temperatureF.toStringAsFixed(1)}°F\n'
                                  '${weather.description}',
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weather.timestamp.toString().substring(11, 16),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      weather.timestamp.toString().substring(0, 10),
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
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
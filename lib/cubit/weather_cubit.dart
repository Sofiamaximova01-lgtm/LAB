import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather_converter/models/weather_model.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  final String apiKey = 'bf88cc954a8fed038a0393dec63adbe0';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<void> fetchWeather(String city) async {
    emit(WeatherLoading());
    
    try {
      print('🔄 Запрос погоды для города: $city');
      
      final response = await http.get(
        Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric&lang=ru'),
      );

      print('📡 Статус ответа API: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Ошибка API (${response.statusCode}): ${response.body}');
      }

      final jsonData = json.decode(response.body);
      
      final temperatureC = jsonData['main']['temp'].toDouble();
      final temperatureF = (temperatureC * 9 / 5) + 32;
      final description = jsonData['weather'][0]['description'].toString();
      final cityName = jsonData['name'].toString();

      print('🌡️ Температура: $temperatureC°C / ${temperatureF.toStringAsFixed(1)}°F');
      print('📝 Описание: $description');

      final weatherData = WeatherData(
        city: cityName,
        temperatureC: temperatureC,
        temperatureF: temperatureF,
        description: description,
        timestamp: DateTime.now(),
      );

      emit(WeatherLoaded(weatherData));
      
    } catch (e) {
      print('❌ Ошибка при запросе погоды: $e');
      emit(WeatherError('Не удалось получить погоду: $e'));
    }
  }
}
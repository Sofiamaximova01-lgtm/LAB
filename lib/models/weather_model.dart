import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherData {
  @HiveField(0)
  final String city;
  
  @HiveField(1)
  final double temperatureC;
  
  @HiveField(2)
  final double temperatureF;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final DateTime timestamp;
  
  WeatherData({
    required this.city,
    required this.temperatureC,
    required this.temperatureF,
    required this.description,
    required this.timestamp,
  });
}
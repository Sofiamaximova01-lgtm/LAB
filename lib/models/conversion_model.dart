import 'package:hive/hive.dart';

part 'conversion_model.g.dart'; 

@HiveType(typeId: 1)
enum ConversionType {
  @HiveField(0)
  celsiusToFahrenheit,
  
  @HiveField(1)
  fahrenheitToCelsius,
}

@HiveType(typeId: 2)
class ConversionHistory {
  @HiveField(0)
  final ConversionType type;
  
  @HiveField(1)
  final double inputValue;
  
  @HiveField(2)
  final double resultValue;
  
  @HiveField(3)
  final DateTime timestamp;
  
  ConversionHistory({
    required this.type,
    required this.inputValue,
    required this.resultValue,
    required this.timestamp,
  });
  
  String get typeString {
    return type == ConversionType.celsiusToFahrenheit 
        ? '°C → °F' 
        : '°F → °C';
  }
}
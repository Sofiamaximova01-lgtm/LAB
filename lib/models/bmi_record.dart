import 'dart:convert';

class BmiRecord {
  final int id;
  final double weight;
  final double height;
  final double bmi;
  final String category;
  final DateTime createdAt;

  BmiRecord({
    required this.id,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'category': category,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    return BmiRecord(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      weight: json['weight'] is double ? json['weight'] : double.parse(json['weight'].toString()),
      height: json['height'] is double ? json['height'] : double.parse(json['height'].toString()),
      bmi: json['bmi'] is double ? json['bmi'] : double.parse(json['bmi'].toString()),
      category: json['category'].toString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['created_at'] is int ? json['created_at'] : int.parse(json['created_at'].toString()),
      ),
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory BmiRecord.fromJsonString(String jsonString) {
    return BmiRecord.fromJson(jsonDecode(jsonString));
  }
}
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._internal();
  factory DBProvider() => _instance;
  DBProvider._internal();

  static const String _historyKey = 'bmi_history';
  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  Future<List<BmiRecord>> getAllRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      final records = <BmiRecord>[];
      
      for (var jsonString in historyJson) {
        try {
          final record = BmiRecord.fromJsonString(jsonString);
          records.add(record);
        } catch (e) {
          continue;
        }
      }
      
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return records;
    } catch (e) {
      return [];
    }
  }

  Future<int> insertBmiRecord(BmiRecord record) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      final newRecord = BmiRecord(
        id: DateTime.now().millisecondsSinceEpoch,
        weight: record.weight,
        height: record.height,
        bmi: record.bmi,
        category: record.category,
        createdAt: record.createdAt,
      );
      
      historyJson.add(newRecord.toJsonString());
      await prefs.setStringList(_historyKey, historyJson);
      
      _notifyListeners(); 
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<bool> deleteRecord(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      if (index >= 0 && index < historyJson.length) {
        historyJson.removeAt(index);
        await prefs.setStringList(_historyKey, historyJson);
        
        _notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      
      _notifyListeners(); 
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getRecordsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      return historyJson.length;
    } catch (e) {
      return 0;
    }
  }
}
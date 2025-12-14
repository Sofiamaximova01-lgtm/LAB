import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/db_provider.dart';
import '../models/bmi_record.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<BmiRecord> records;
  
  HistoryLoaded(this.records);
}

class HistoryError extends HistoryState {
  final String message;
  
  HistoryError(this.message);
}

class HistoryEmpty extends HistoryState {}

class HistoryCubit extends Cubit<HistoryState> {
  final DBProvider _dbProvider = DBProvider();
  
  HistoryCubit() : super(HistoryInitial()) {
    _dbProvider.addListener(_onDataChanged);
    loadHistory();
  }

  void _onDataChanged() {
    loadHistory();
  }

  @override
  Future<void> close() {
    _dbProvider.removeListener(_onDataChanged);
    return super.close();
  }

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    
    try {
      final records = await _dbProvider.getAllRecords();
      
      if (records.isEmpty) {
        emit(HistoryEmpty());
      } else {
        emit(HistoryLoaded(records));
      }
    } catch (e) {
      emit(HistoryError('Не удалось загрузить историю'));
      await Future.delayed(const Duration(seconds: 1));
      emit(HistoryEmpty());
    }
  }

  Future<void> deleteRecord(int index) async {
    emit(HistoryLoading());
    
    try {
      final success = await _dbProvider.deleteRecord(index);
      if (!success) {
        emit(HistoryError('Не удалось удалить запись'));
        await Future.delayed(const Duration(milliseconds: 500));
        await loadHistory();
      }
    } catch (e) {
      emit(HistoryError('Ошибка при удалении записи: $e'));
      await Future.delayed(const Duration(milliseconds: 500));
      await loadHistory();
    }
  }

  Future<void> clearHistory() async {
    emit(HistoryLoading());
    
    try {
      final success = await _dbProvider.clearAllRecords();
      if (!success) {
        emit(HistoryError('Не удалось очистить историю'));
      }
    } catch (e) {
      emit(HistoryError('Ошибка при очистке истории: $e'));
    }
  }
}
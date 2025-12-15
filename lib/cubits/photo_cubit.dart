import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/repositories/photo_repository.dart';
import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final PhotoRepository repository;
  int _currentPage = 1;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _isRandomMode = false;

  PhotoCubit({required this.repository}) : super(PhotoInitial());

  Future<void> loadPhotos() async {
    _isRandomMode = false;
    _currentPage = 1;
    
    emit(PhotoLoading());
    
    try {
      final photos = await repository.fetchPhotos(page: _currentPage, limit: _limit);
      
      if (photos.isEmpty) {
        emit(PhotoLoaded(photos: [], hasReachedMax: true));
      } else {
        emit(PhotoLoaded(photos: photos, hasReachedMax: false));
      }
    } catch (e) {
      emit(PhotoError(message: e.toString()));
    }
  }

  Future<void> loadMorePhotos() async {
    if (_isLoadingMore || _isRandomMode) return;
    
    final currentState = state;
    
    if (currentState is PhotoLoaded && !currentState.hasReachedMax) {
      _isLoadingMore = true;
      
      try {
        _currentPage++;
        final newPhotos = await repository.fetchPhotos(page: _currentPage, limit: _limit);
        
        if (newPhotos.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          final allPhotos = currentState.photos + newPhotos;
          emit(PhotoLoaded(photos: allPhotos, hasReachedMax: false));
        }
      } catch (e) {
        emit(PhotoError(message: 'Ошибка загрузки: $e'));
      } finally {
        _isLoadingMore = false;
      }
    }
  }

  Future<void> refreshPhotos() async {
    _isRandomMode = false;
    _currentPage = 1;
    if (state is! PhotoLoading) {
      await loadPhotos();
    }
  }

  Future<void> loadRandomPhotos() async {
    _isRandomMode = true;
    emit(PhotoLoading());
    
    try {
      final photos = await repository.fetchRandomPhotos(count: 15);
      emit(PhotoLoaded(photos: photos, hasReachedMax: true));
    } catch (e) {
      emit(PhotoError(message: e.toString()));
    }
  }
}
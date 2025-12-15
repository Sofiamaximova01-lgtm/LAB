import 'package:equatable/equatable.dart';
import 'package:photo_gallery/models/photo.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<Photo> photos;
  final bool hasReachedMax;

  const PhotoLoaded({
    required this.photos,
    required this.hasReachedMax,
  });

  PhotoLoaded copyWith({
    List<Photo>? photos,
    bool? hasReachedMax,
  }) {
    return PhotoLoaded(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [photos, hasReachedMax];
}

class PhotoError extends PhotoState {
  final String message;

  const PhotoError({required this.message});

  @override
  List<Object> get props => [message];
}
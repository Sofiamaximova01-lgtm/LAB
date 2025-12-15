import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  const Photo({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? '',
      author: json['author'] ?? 'Unknown Author',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
      downloadUrl: json['download_url'] ?? '',
    );
  }

  String getImageUrl({int width = 300, int height = 200}) {
    return 'https://picsum.photos/id/$id/$width/$height';
  }

  String get originalImageUrl {
    return 'https://picsum.photos/id/$id/$width/$height';
  }

  @override
  List<Object> get props => [id, author, url];
}
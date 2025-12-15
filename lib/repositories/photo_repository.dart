import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/models/photo.dart';

class PhotoRepository {
  static const String _baseUrl = 'https://picsum.photos';
  final Random _random = Random();

  Future<List<Photo>> fetchPhotos({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/v2/list?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return [];
        }
        return jsonList.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Photo> fetchPhotoById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/id/$id/info'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Photo.fromJson(jsonData);
      } else {
        return _fetchRandomPhotoInfo();
      }
    } catch (e) {
      return _fetchRandomPhotoInfo();
    }
  }

  Future<List<Photo>> fetchRandomPhotos({int count = 10}) async {
    try {
      final List<Photo> photos = [];
      
      final randomIds = List.generate(count, (_) => _random.nextInt(1000) + 1);
      
      for (final id in randomIds) {
        try {
          final photo = await _fetchRandomPhotoInfo(id: id);
          photos.add(photo);
        } catch (e) {
          continue;
        }
        
        await Future.delayed(const Duration(milliseconds: 50));
      }
      
      if (photos.length < count) {
        final remaining = count - photos.length;
        final standardPhotos = await fetchPhotos(limit: remaining);
        photos.addAll(standardPhotos);
      }
      
      return photos;
    } catch (e) {
      return fetchPhotos(limit: count);
    }
  }

  Future<Photo> _fetchRandomPhotoInfo({int? id}) async {
    try {
      final photoId = id ?? _random.nextInt(1000) + 1;
      
      final response = await http.get(
        Uri.parse('$_baseUrl/id/$photoId/info'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Photo.fromJson(jsonData);
      } else {
        return _fetchRandomPhotoInfo(id: _random.nextInt(1000) + 1);
      }
    } catch (e) {
      throw Exception('Failed to load random photo: $e');
    }
  }

  Future<bool> checkPhotoExists(String id) async {
    try {
      final response = await http.head(
        Uri.parse('$_baseUrl/id/$id/info'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import '../data/api/api_service.dart';
import '../data/repository/auth_repository.dart';
import '../data/responses/stories_response.dart';
import '../utils/custom_exception.dart';
import '../utils/enum.dart';
import 'package:geocoding/geocoding.dart' as geo;

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  StoryProvider({
    required this.apiService,
    required this.authRepository,
  });

  // List<Story>? _allStories;
  final List<Story> _allStories = [];
  Story? _story;
  String? _message;
  ResultState? _state;
  int? pageItems = 1;
  int sizeItems = 10;
  final Set<Marker> markers = {};
  String _currentAddress = "Location Unknown";

  List<Story>? get allStories => _allStories;
  Story? get story => _story;
  String? get message => _message;
  ResultState? get state => _state;

  Future<dynamic> fetchAllStories({int location = 0}) async {
    final token = await authRepository.token;
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      final storiesResponse = await apiService.getAllStories(
          token, pageItems!, sizeItems, location);

      if (storiesResponse.listStory.isNotEmpty) {
        _allStories.addAll(storiesResponse.listStory);
        _state = ResultState.success;
        notifyListeners();

        if (storiesResponse.listStory.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
      } else {
        pageItems = null; // No more stories to load
      }
    } catch (e) {
      _state = ResultState.error;

      _message = 'Error --> ${e.toString()}';
      notifyListeners();
      return _message;
    }
  }

  Future<dynamic> fetchStoryById(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final detailResponse = await apiService.getDetailStory(id);

      _state = ResultState.success;
      notifyListeners();

      _story = detailResponse.story;

      if (_story?.lat != null && _story?.lon != null) {
        final info = await geo.placemarkFromCoordinates(
          _story!.lat!,
          _story!.lon!,
        );

        if (info.isNotEmpty) {
          final place = info[0];
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        }

        final marker = Marker(
          markerId: const MarkerId("story-position"),
          infoWindow: InfoWindow(title: _currentAddress),
          position: LatLng(_story!.lat!, _story!.lon!),
        );

        markers.clear();
        markers.add(marker);
        notifyListeners();
      }

      return detailResponse;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      throw CustomException(e.toString());
    }
  }

  Future<dynamic> refreshPage() async {
    _allStories.clear();
    pageItems = 1;
    await fetchAllStories();
    notifyListeners();
  }

  Future<dynamic> uploadStory({
    required String token,
    required String fileName,
    required List<int> bytes,
    required String desc,
    double? lat,
    double? lon,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final responseData =
          await apiService.postStory(token, bytes, fileName, desc, lat, lon);

      if (responseData.error == false) {
        await refreshPage();
        _state = ResultState.success;
        notifyListeners();

        return responseData;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      _message = '$e';
      throw Exception('Error --> $e');
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}

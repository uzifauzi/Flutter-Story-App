import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/custom_exception.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../responses/api_response.dart';
import '../responses/detail_story_response.dart';
import '../responses/login_response.dart';
import '../responses/stories_response.dart';

class ApiService {
  final String baseUrl = 'https://story-api.dicoding.dev/v1';
  final AuthRepository authRepository;

  ApiService(this.authRepository);

  Future<ApiResponse> postRegister(UserModel user) async {
    final uri = '$baseUrl/register';
    final body = jsonEncode(user.toJson());

    final response = await http.post(
      Uri.parse(uri),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String errorMessage =
          responseBody['message'] ?? 'Failed to create account.';

      // Mencetak pesan kesalahan ke konsol (hanya untuk debugging)

      // Menggunakan CustomException untuk memberikan pesan kesalahan yang lebih informatif
      throw CustomException(errorMessage);
    }
  }

  Future<LoginResponse> postLogin(String email, String password) async {
    final uri = '$baseUrl/login';

    final response = await http.post(
      Uri.parse(uri),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String errorMessage = responseBody['message'] ?? 'Failed to login.';

      throw CustomException(errorMessage);
    }
  }

  Future<StoriesResponse> getAllStories(String token,
      [int page = 1, int size = 10, int location = 0]) async {
    final uri = '$baseUrl/stories?page=$page&size=$size&location=$location';
    print(uri);

    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return StoriesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<DetailStoryResponse> getDetailStory(String id) async {
    final authToken = await authRepository.token;
    final uri = '$baseUrl/stories/$id';
    final Map<String, String> headers = {"Authorization": "Bearer $authToken"};

    final response = await http.get(
      Uri.parse(uri),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DetailStoryResponse.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String errorMessage =
          responseBody['message'] ?? 'Failed to get story.';
      throw CustomException(errorMessage);
    }
  }

  Future<ApiResponse> postStory(
    String token,
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lon,
  ) async {
    final uri = Uri.parse('$baseUrl/stories');
    var request = http.MultipartRequest('POST', uri);

    final Map<String, String> fields = {
      "description": description,
    };
    // Add latitude and longitude to fields if they are provided
    if (lat != null && lon != null) {
      fields['lat'] = lat.toString();
      fields['lon'] = lon.toString();
    }
    request.fields.addAll(fields);

    final MultipartFile multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    request.files.add(multiPartFile);

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    };
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;
    final String responseData = await streamedResponse.stream.bytesToString();

    if (statusCode == 200 || statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(responseData));
    } else {
      throw Exception("Failed to upload data.");
    }
  }
}

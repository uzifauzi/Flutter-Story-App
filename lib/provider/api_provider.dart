import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/models/user_model.dart';
import '../data/responses/api_response.dart';
import '../data/responses/login_response.dart';
import '../utils/custom_exception.dart';
import '../utils/enum.dart';

class ApiProvider extends ChangeNotifier {
  final ApiService apiService;

  ApiProvider(this.apiService);

  ResultState? _state;

  ResultState? get state => _state;

  String _message = '';

  String get message => _message;

  Future<ApiResponse> fetchRegister(UserModel user) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final response = await apiService.postRegister(user);

      _state = ResultState.success;
      notifyListeners();
      return response;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      throw CustomException(e.toString());
    }
  }

  Future<LoginResponse> fetchLogin(String email, String password) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final loginResponse = await apiService.postLogin(email, password);
      _state = ResultState.success;
      notifyListeners();
      _message = loginResponse.message;
      return loginResponse;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      throw CustomException(e.toString());
    }
  }

  // Future<dynamic> fetchLogin(String email, String password) async {
  //   try {
  //     _state = ResultState.loading;
  //     notifyListeners();
  //     final loginResponse = await apiService.postLogin(email, password);
  //     if (loginResponse.error == true) {
  //       _state = ResultState.error;
  //       notifyListeners();
  //       return _message = loginResponse.message;
  //     } else {
  //       _state = ResultState.success;
  //       notifyListeners();
  //       return loginResponse;
  //     }
  //   } catch (e) {
  //     _state = ResultState.error;
  //     notifyListeners();
  //     return _message = 'Error --> $e';
  //   }
  // }
}

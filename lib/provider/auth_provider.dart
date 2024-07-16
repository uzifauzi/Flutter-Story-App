import 'package:flutter/foundation.dart';

import '../data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository}) {
    _getToken();
  }

  String _token = '';

  String get token => _token;

  Future<void> _getToken() async {
    _token = await authRepository.token;
    notifyListeners();
  }

  void setLoginToken(String token) {
    authRepository.setToken(token);
    _token = token;
    notifyListeners();
  }

  void removeLoginToken() async {
    await authRepository.logout();
    _token = '';
    notifyListeners();
  }
}

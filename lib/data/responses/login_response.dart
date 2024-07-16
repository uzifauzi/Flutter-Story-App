import 'package:json_annotation/json_annotation.dart';

import 'login_result.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  LoginResponse(this.error, this.message, this.loginResult);

  bool error;
  String message;
  LoginResult loginResult;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

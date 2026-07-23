import 'dart:convert' show json;
import 'package:rapidito/src/data/api/ApiConfig.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:http/http.dart' as http;
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

class AuthService {
  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      Uri url = Uri.http(ApiConfig.API_PROJECT, '/auth/login');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode({'email': email, 'password': password});
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data Remote: ${authResponse.toJson()}');
        print('token: ${authResponse.token}');

        return Success(data: authResponse);
      } else {
        return ErrorData(message: data['message']);
      }
    } catch (e) {
      print('Error $e');
      return ErrorData(message: e.toString());
    }
  }

  Future<Resource<AuthResponse>> register(User user) async {
    try {
      Uri url = Uri.http(ApiConfig.API_PROJECT, '/auth/register');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode(user.toJson());
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data Remote: ${authResponse.toJson()}');
        print('token: ${authResponse.token}');

        return Success(data: authResponse);
      } else {
        return ErrorData(message: data['message']);
      }
    } catch (e) {
      print('Error $e');
      return ErrorData(message: e.toString());
    }
  }
}

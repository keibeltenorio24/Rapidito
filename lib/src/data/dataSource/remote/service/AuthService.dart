import 'dart:convert' show json;
import 'package:rapidito/src/data/api/ApiConfig.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:http/http.dart' as http;
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

class AuthService {
  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      Uri url = Uri.https(ApiConfig.API_PROJECT, '/auth/login');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode({'email': email, 'password': password});
      final response = await http.post(url, headers: headers, body: body);
      print('Login - Status: ${response.statusCode}, Body: "${response.body}"');

      if (response.body.isEmpty) {
        return ErrorData(message: 'El servidor retornó una respuesta vacía');
      }

      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        return ErrorData(message: 'El servidor no retornó JSON válido. ¿Estás usando HTTP en lugar de HTTPS?');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data Remote: ${authResponse.toJson()}');
        print('token: ${authResponse.token}');

        return Success(data: authResponse);
      } else {
        String errorMessage = 'Error desconocido';
        if (data is Map) {
          if (data.containsKey('message')) {
            var msg = data['message'];
            errorMessage = msg is List ? msg.join(', ') : msg.toString();
          } else if (data.containsKey('detail')) {
            errorMessage = data['detail'].toString();
          } else if (data.isNotEmpty) {
            var firstVal = data.values.first;
            errorMessage = firstVal is List ? firstVal.join(', ') : firstVal.toString();
          }
        }
        return ErrorData(message: errorMessage);
      }
    } catch (e) {
      print('Error $e');
      return ErrorData(message: e.toString());
    }
  }

  Future<Resource<AuthResponse>> register(User user) async {
    try {
      Uri url = Uri.https(ApiConfig.API_PROJECT, '/auth/register');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode(user.toJson());
      final response = await http.post(url, headers: headers, body: body);
      print('Register - Status: ${response.statusCode}, Body: "${response.body}"');

      if (response.body.isEmpty) {
        return ErrorData(message: 'El servidor retornó una respuesta vacía');
      }

      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        return ErrorData(message: 'El servidor no retornó JSON válido. ¿Estás usando HTTP en lugar de HTTPS?');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data Remote: ${authResponse.toJson()}');
        print('token: ${authResponse.token}');

        return Success(data: authResponse);
      } else {
        String errorMessage = 'Error desconocido';
        if (data is Map) {
          if (data.containsKey('message')) {
            var msg = data['message'];
            errorMessage = msg is List ? msg.join(', ') : msg.toString();
          } else if (data.containsKey('detail')) {
            errorMessage = data['detail'].toString();
          } else if (data.isNotEmpty) {
            var firstVal = data.values.first;
            errorMessage = firstVal is List ? firstVal.join(', ') : firstVal.toString();
          }
        }
        return ErrorData(message: errorMessage);
      }
    } catch (e) {
      print('Error $e');
      return ErrorData(message: e.toString());
    }
  }
}

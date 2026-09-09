import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rapidito/src/data/api/ApiConfig.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/data/dataSource/local/SharefPref.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersService {
  final SharefPref sharefPref;

  UsersService(this.sharefPref);

  Future<Resource<User>> update(int id, User user, [File? image]) async {
    try {
      Uri url = Uri.https(
        ApiConfig.API_PROJECT,
        '/users/$id/',
      ); // Agregado trailing slash

      dynamic userSession = await sharefPref.read('user');
      String? token;
      if (userSession != null && userSession['token'] != null) {
        token = userSession['token'];
      }

      http.Response response;

      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = token.trim();
      }

      Map<String, dynamic> bodyMap = {
        'name': user.name,
        'last_name': user.lastName,
        'phone': user.phone,
        'email': user.email,
      };

      if (image != null) {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(
          'users/$id/$fileName',
        );

        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        bodyMap['image_url'] = downloadUrl;
      }

      String body = json.encode(bodyMap);
      response = await http.post(url, headers: headers, body: body);

      print(
        'UpdateUser - URL: $url, Status: ${response.statusCode}, Body: "${response.body}"',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final data = json.decode(response.body);
          Map<String, dynamic> userData = data.containsKey('user')
              ? data['user']
              : data;
          User userResponse = User.fromJson(userData);

          dynamic userSession = await sharefPref.read('user');
          if (userSession != null) {
            userSession['user'] = userResponse.toJson();
            await sharefPref.save('user', userSession);
          }

          return Success(data: userResponse);
        } else {
          // Si el API no devuelve JSON, asumimos éxito y regresamos el mismo usuario
          return Success(data: user);
        }
      } else {
        String errorMessage = 'Error al actualizar';
        if (response.body.isNotEmpty) {
          try {
            final data = json.decode(response.body);
            if (data is Map) {
              if (data.containsKey('message')) {
                var msg = data['message'];
                errorMessage = msg is List ? msg.join(', ') : msg.toString();
              } else if (data.containsKey('detail')) {
                errorMessage = data['detail'].toString();
              } else if (data.isNotEmpty) {
                var firstVal = data.values.first;
                errorMessage = firstVal is List
                    ? firstVal.join(', ')
                    : firstVal.toString();
              }
            }
          } catch (e) {
            errorMessage = response.body; // en caso devuelva texto plano
          }
        }
        return ErrorData(message: errorMessage);
      }
    } catch (e) {
      print('Error $e');
      return ErrorData(message: 'Error al actualizar el usuario $e');
    }
  }
}

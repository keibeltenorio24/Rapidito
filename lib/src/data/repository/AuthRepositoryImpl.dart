import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart';
import 'package:rapidito/src/data/dataSource/local/SharefPref.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

class Authrepositoryimpl implements AuthRepository {
  AuthService authService;
  SharefPref sharefPref;

  Authrepositoryimpl({required this.authService, required this.sharefPref});

  @override
  Future<Resource<AuthResponse>> login(String email, String password) {
    return authService.login(email, password);
  }

  @override
  Future<Resource<AuthResponse>> register(User user) {
    return authService.register(user);
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await sharefPref.read("user");
    if (data != null) {
      return AuthResponse.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> removeUserSession() async {
    await sharefPref.remove("user");
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    await sharefPref.save("user", authResponse.toJson());
  }
}

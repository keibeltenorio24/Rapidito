import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';


class Authrepositoryimpl implements AuthRepository {
  final AuthService authService;

  Authrepositoryimpl({required this.authService});

  @override
  Future<Resource<AuthResponse>> login(String email, String password) {
    return authService.login(email, password);
  }

  @override
  Future<Resource<AuthResponse>> register(User user) {
    return authService.register(user);
  }
}

import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

class LoginUseCase {
  AuthRepository repository;

  LoginUseCase({required this.repository});
  Future<Resource<AuthResponse>> run(String email, String password) =>
      repository.login(email, password);
}

import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

class RegisterUseCase {
  AuthRepository authRepository;
  RegisterUseCase({required this.authRepository});

  run(User user) => authRepository.register(user);
}

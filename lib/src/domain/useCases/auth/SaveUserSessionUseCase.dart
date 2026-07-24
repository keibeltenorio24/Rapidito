import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';

class SaveUserSessionUseCase {
  final AuthRepository repository;
  SaveUserSessionUseCase({required this.repository});

  run(AuthResponse authResponse) => repository.saveUserSession(authResponse);
}

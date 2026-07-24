import 'package:rapidito/src/domain/repository/AuthRepository.dart';

class RemoveUserSessionUseCase {
  final AuthRepository repository;
  RemoveUserSessionUseCase({required this.repository});

  run() => repository.removeUserSession();
}

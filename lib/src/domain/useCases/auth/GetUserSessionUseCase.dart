import 'package:rapidito/src/domain/repository/AuthRepository.dart';

class GetUserSessionUseCase {
  final AuthRepository authRepository;
  GetUserSessionUseCase({required this.authRepository});

  run() => authRepository.getUserSession();
}

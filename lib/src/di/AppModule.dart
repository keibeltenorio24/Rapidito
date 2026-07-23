import 'package:injectable/injectable.dart';
import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart';
import 'package:rapidito/src/data/repository/AuthRepositoryImpl.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RegisterUseCase.dart';

@module
abstract class AppModule {
  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository =>
      Authrepositoryimpl(authService: authService);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    login: LoginUseCase(repository: authRepository),
    register: RegisterUseCase(authRepository: authRepository),
  );
}

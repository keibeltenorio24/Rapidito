import 'package:injectable/injectable.dart';
import 'package:rapidito/src/data/dataSource/local/SharefPref.dart';
import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart';
import 'package:rapidito/src/data/repository/AuthRepositoryImpl.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RegisterUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RemoveUserSessionUseCase.dart';

@module
abstract class AppModule {
  @injectable
  SharefPref get sharefPref => SharefPref();

  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository =>
      Authrepositoryimpl(authService: authService, sharefPref: sharefPref);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    login: LoginUseCase(repository: authRepository),
    register: RegisterUseCase(authRepository: authRepository),
    saveUserSession: SaveUserSessionUseCase(repository: authRepository),
    getUserSession: GetUserSessionUseCase(authRepository: authRepository),
    removeUserSession: RemoveUserSessionUseCase(repository: authRepository),
  );
}

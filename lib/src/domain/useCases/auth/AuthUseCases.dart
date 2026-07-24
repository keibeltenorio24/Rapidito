import 'package:rapidito/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RegisterUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RemoveUserSessionUseCase.dart';

class AuthUseCases {
  LoginUseCase login;
  RegisterUseCase register;
  SaveUserSessionUseCase saveUserSession;
  GetUserSessionUseCase getUserSession;
  RemoveUserSessionUseCase removeUserSession;

  AuthUseCases({
    required this.login,
    required this.register,
    required this.saveUserSession,
    required this.getUserSession,
    required this.removeUserSession,
  });
}

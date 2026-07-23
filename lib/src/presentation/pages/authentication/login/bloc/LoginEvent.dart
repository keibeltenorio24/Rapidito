import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';

abstract class LoginEvent {}

class LoginInitEvent extends LoginEvent {}

class EmailChanged extends LoginEvent {
  final BlocformItem email;
  EmailChanged({required this.email});
}

class PasswordChanged extends LoginEvent {
  final BlocformItem password;
  PasswordChanged({required this.password});
}

class ResetLoginForm extends LoginEvent {
  // Como no necesitamos mandarle datos (solo es un aviso de reseteo),
  // no requiere variables dentro.
}

class FormSubmit extends LoginEvent {}

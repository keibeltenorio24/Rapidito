import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginState.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthUseCases authUseCases;
  final formkey = GlobalKey<FormState>();

  LoginBloc({required this.authUseCases}) : super(const LoginState()) {
    on<LoginInitEvent>((event, emit) async {
      emit(state.copyWith(formkey: formkey));
      final authResponse = await authUseCases.getUserSession.run();
      if (authResponse != null) {
        emit(
          state.copyWith(response: Success<AuthResponse>(data: authResponse)),
        );
      }
    });

    on<SaveUserSession>((event, emit) async {
      await authUseCases.saveUserSession.run(event.authResponse);
    });

    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: BlocformItem(
            value: event.email.value,
            error: event.email.value.isEmpty ? 'ingresa el correo' : null,
          ),
          formkey: formkey,
        ),
      );
      // TODO: implement event handler
    });

    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: BlocformItem(
            value: event.password.value,
            error: event.password.value.isEmpty
                ? 'ingresa la constraseña'
                : event.password.value.length < 6
                ? 'Minimo 6 caracteres'
                : null,
          ),
        ),
      );
    });

    on<ResetLoginForm>((event, emit) {
      emit(const LoginState());
    });

    on<FormSubmit>((event, emit) async {
      print('Correo: ${state.email.value}');
      print('Password: ${state.password.value}');
      emit(state.copyWith(response: Loading(), formkey: formkey));
      Resource response = await authUseCases.login.run(
        state.email.value,
        state.password.value,
      );
      emit(state.copyWith(response: response, formkey: formkey));
      // TODO: implement event handler
    });
  }
}

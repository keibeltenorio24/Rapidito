import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';

class LoginState extends Equatable {
  final BlocformItem email;
  final BlocformItem password;
  final GlobalKey<FormState>? formkey;
  final Resource? response;

  const LoginState({
    this.email = const BlocformItem(error: 'Ingresa correo'),
    this.password = const BlocformItem(error: 'Ingresa contraseña'),
    this.formkey,
    this.response,
  });

  LoginState copyWith({
    BlocformItem? email,
    BlocformItem? password,
    GlobalKey<FormState>? formkey,
    Resource? response,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formkey: formkey ?? this.formkey,
      response: response ?? this.response,
    );
  }

  @override
  // Agregué el formkey a los props por buenas prácticas de Equatable
  List<Object?> get props => [email, password, formkey, response];
}

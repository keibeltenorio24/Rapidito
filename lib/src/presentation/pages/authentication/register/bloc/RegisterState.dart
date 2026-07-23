import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';

class RegisterState extends Equatable {
  final BlocformItem name;
  final BlocformItem lastName;
  final BlocformItem email;
  final BlocformItem phone;
  final BlocformItem password;
  final BlocformItem confirmPassword;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const RegisterState({
    this.name = const BlocformItem(error: 'Ingresa el nombre'),
    this.lastName = const BlocformItem(error: 'Ingresa el apellido'),
    this.email = const BlocformItem(error: 'Ingresa el correo'),
    this.phone = const BlocformItem(error: 'Ingresa el número de telefono'),
    this.password = const BlocformItem(error: 'Ingresa la contraseña'),
    this.confirmPassword = const BlocformItem(error: 'Confirma la contraseña'),
    this.formKey,
    this.response,
  });

  toUser()=> User(
      name: name.value,
      lastName: lastName.value,
      email: email.value,
      phone: phone.value,
      password: password.value,
    );

  RegisterState copyWith({
    BlocformItem? name,
    BlocformItem? lastName,
    BlocformItem? email,
    BlocformItem? phone,
    BlocformItem? password,
    BlocformItem? confirmPassword,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return RegisterState(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formKey: formKey ?? this.formKey,
      response: response ?? this.response,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    lastName,
    email,
    phone,
    password,
    confirmPassword,
    response,
  ];
}

import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
class ProfileUpdateState {
  final int id;
  final String email;
  final BlocformItem name;
  final BlocformItem lastname;
  final BlocformItem phone;
  final GlobalKey<FormState>? formKey;
  final Resource? response;
  final File? image;

  ProfileUpdateState({
    this.id = 0,
    this.email = '',
    this.name = const BlocformItem(error: 'Ingresa el nombre'),
    this.lastname = const BlocformItem(error: 'Ingresa el apellido'),
    this.phone = const BlocformItem(error: 'Ingresa el telefono'),
    this.formKey,
    this.response,
    this.image,
  });

  ProfileUpdateState copyWith({
    int? id,
    String? email,
    BlocformItem? name,
    BlocformItem? lastname,
    BlocformItem? phone,
    GlobalKey<FormState>? formKey,
    Resource? response,
    File? image,
  }) {
    return ProfileUpdateState(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      formKey: formKey ?? this.formKey,
      response: response,
      image: image ?? this.image,
    );
  }

  List<Object?> get props => [id, email, name, lastname, phone, response, image];
}

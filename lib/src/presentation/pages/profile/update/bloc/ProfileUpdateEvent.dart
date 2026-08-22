import 'dart:io';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';
abstract class ProfileUpdateEvent {}

class ProfileUpdateInitEvent extends ProfileUpdateEvent {
  final User? user;
  ProfileUpdateInitEvent({this.user});
}

class NameChanged extends ProfileUpdateEvent {
  final BlocformItem name;
  NameChanged({required this.name});
}

class LastNameChanged extends ProfileUpdateEvent {
  final BlocformItem lastName;
  LastNameChanged({required this.lastName});
}

class PhoneChanged extends ProfileUpdateEvent {
  final BlocformItem phone;
  PhoneChanged({required this.phone});
}

class UpdateImagePicked extends ProfileUpdateEvent {
  final File image;
  UpdateImagePicked({required this.image});
}

class FormSubmit extends ProfileUpdateEvent {}

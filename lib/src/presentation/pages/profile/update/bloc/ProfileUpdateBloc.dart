import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/domain/useCases/users/UsersUseCases.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final UsersUseCases usersUseCases;
  final formKey = GlobalKey<FormState>();

  ProfileUpdateBloc({required this.usersUseCases})
    : super(ProfileUpdateState()) {
    on<ProfileUpdateInitEvent>((event, emit) {
      emit(
        state.copyWith(
          id: event.user?.id ?? 0,
          email: event.user?.email ?? '',
          name: BlocformItem(value: event.user?.name ?? ''),
          lastname: BlocformItem(value: event.user?.lastName ?? ''),
          phone: BlocformItem(value: event.user?.phone ?? ''),
          formKey: formKey,
        ),
      );
    });

    on<NameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: BlocformItem(
            value: event.name.value,
            error: event.name.value.isEmpty ? 'Ingresa el nombre' : null,
          ),
          formKey: formKey,
        ),
      );
    });

    on<LastNameChanged>((event, emit) {
      emit(
        state.copyWith(
          lastname: BlocformItem(
            value: event.lastName.value,
            error: event.lastName.value.isEmpty ? 'Ingresa el apellido' : null,
          ),
          formKey: formKey,
        ),
      );
    });

    on<PhoneChanged>((event, emit) {
      emit(
        state.copyWith(
          phone: BlocformItem(
            value: event.phone.value,
            error: event.phone.value.isEmpty ? 'Ingresa el telefono' : null,
          ),
          formKey: formKey,
        ),
      );
    });

    on<UpdateImagePicked>((event, emit) {
      emit(
        state.copyWith(
          image: event.image,
          formKey: formKey,
        ),
      );
    });
    on<FormSubmit>((event, emit) async {
      emit(state.copyWith(response: Loading(), formKey: formKey));

      User user = User(
        name: state.name.value,
        lastName: state.lastname.value,
        phone: state.phone.value,
        email: state.email, // using the email from state
      );

      final response = await usersUseCases.update.run(
        state.id,
        user,
        state.image,
      );
      emit(state.copyWith(response: response, formKey: formKey));
    });
  }
}

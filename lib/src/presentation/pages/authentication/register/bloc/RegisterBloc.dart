import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterState.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthUseCases authUseCases;

  RegisterBloc({required this.authUseCases}) : super(const RegisterState()) {
    on<NameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: BlocformItem(
            value: event.name.value,
            error: event.name.value.isEmpty ? 'Ingrese el Nombre' : null,
          ),
        ),
      );
    });

    on<LastNameChanged>((event, emit) {
      emit(
        state.copyWith(
          lastName: BlocformItem(
            value: event.lastName.value,
            error: event.lastName.value.isEmpty ? 'Ingrese el Apellido' : null,
          ),
        ),
      );
    });

    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: BlocformItem(
            value: event.email.value,
            error: event.email.value.isEmpty ? 'Ingrese el Correo' : null,
          ),
        ),
      );
    });

    on<PhoneChanged>((event, emit) {
      emit(
        state.copyWith(
          phone: BlocformItem(
            value: event.phone.value,
            error: event.phone.value.isEmpty
                ? 'Ingrese el Número de teléfono'
                : null,
          ),
        ),
      );
    });

    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: BlocformItem(
            value: event.password.value,
            error: event.password.value.isEmpty
                ? 'Ingrese la Contraseña'
                : event.password.value.length < 6
                ? 'Mínimo 6 caracteres'
                : null,
          ),
        ),
      );
    });

    on<ConfirmPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          confirmPassword: BlocformItem(
            value: event.confirmPassword.value,
            error: event.confirmPassword.value.isEmpty
                ? 'Confirma la contraseña'
                : event.confirmPassword.value.length < 6
                ? 'Mínimo 6 caracteres'
                : event.confirmPassword.value != state.password.value
                ? 'Las contraseñas no coinciden'
                : null,
          ),
        ),
      );
    });

    on<FormSubmit>((event, emit) async {
      // ✅ Corregidos los prints para que muestren la variable correcta
      print('Name: ${state.name.value}');
      print('Email: ${state.email.value}');
      print('Phone: ${state.phone.value}');
      print('Password: ${state.password.value}');
      print('ConfirmPassword: ${state.confirmPassword.value}');
      emit(state.copyWith(response: Loading()));
      Resource response = await authUseCases.register.run(state.toUser());
      emit(state.copyWith(response: response));
    });

    on<FormReset>((event, emit) {
      emit(const RegisterState());
    });
  }
}

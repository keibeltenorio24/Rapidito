import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/injection.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginBloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterBloc.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';

// Nota: Puedes borrar las importaciones de LoginEvent y RegisterEvent
// en la parte superior porque ya no las vamos a usar aquí.

List<BlocProvider> blocProvider = [
  BlocProvider<LoginBloc>(
    // ✅ Solo creamos el BLoC limpio, sin disparar eventos iniciales
    create: (context) => LoginBloc(authUseCases: locator<AuthUseCases>()),
  ),
  BlocProvider<RegisterBloc>(
    // ✅ Lo mismo para el registro
    create: (context) => RegisterBloc(authUseCases: locator<AuthUseCases>()),
  ),
  BlocProvider<ClientHomeBloc>(
    create: (context) => ClientHomeBloc(authUseCases: locator<AuthUseCases>()),
  ),
];

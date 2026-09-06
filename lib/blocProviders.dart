import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/injection.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/users/UsersUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginBloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterBloc.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerBloc.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:rapidito/src/presentation/pages/driver/home/bloc/DriverHomeBloc.dart';
import 'package:rapidito/src/presentation/pages/driver/map/bloc/DriverMapBloc.dart';

// Nota: Puedes borrar las importaciones de LoginEvent y RegisterEvent
// en la parte superior porque ya no las vamos a usar aquí.

List<BlocProvider> blocProvider = [
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(authUseCases: locator<AuthUseCases>())
      ..add(LoginInitEvent()),
  ),
  BlocProvider<RegisterBloc>(
    create: (context) => RegisterBloc(authUseCases: locator<AuthUseCases>()),
  ),
  BlocProvider<ClientHomeBloc>(
    create: (context) => ClientHomeBloc(authUseCases: locator<AuthUseCases>()),
  ),
  BlocProvider<ProfileInfoBloc>(
    create: (context) => ProfileInfoBloc(authUseCases: locator<AuthUseCases>()),
  ),
  BlocProvider<ProfileUpdateBloc>(
    create: (context) =>
        ProfileUpdateBloc(usersUseCases: locator<UsersUseCases>()),
  ),
  BlocProvider<ClientMapSeekerBloc>(
    create: (context) =>
        ClientMapSeekerBloc(geolocatorUseCases: locator<GeolocatorUseCases>(), ridesUseCases: locator<RidesUseCases>()),
  ),
  BlocProvider<DriverHomeBloc>(
    create: (context) => DriverHomeBloc(authUseCases: locator<AuthUseCases>()),
  ),
  BlocProvider<DriverMapBloc>(
    create: (context) => DriverMapBloc(geolocatorUseCases: locator<GeolocatorUseCases>(), ridesUseCases: locator<RidesUseCases>()),
  ),
];

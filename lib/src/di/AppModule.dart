import 'package:injectable/injectable.dart';
import 'package:rapidito/src/data/dataSource/local/SharefPref.dart';
import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart';
import 'package:rapidito/src/data/dataSource/remote/service/UsersService.dart';
import 'package:rapidito/src/data/repository/AuthRepositoryImpl.dart';
import 'package:rapidito/src/data/repository/GeolocatorRepositoryImpl.dart';
import 'package:rapidito/src/data/repository/UsersRepositoryImpl.dart';
import 'package:rapidito/src/domain/repository/AuthRepository.dart';
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';
import 'package:rapidito/src/domain/repository/UsersRepository.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RegisterUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/auth/RemoveUserSessionUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/CreateMarkerUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/FindPositionUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetMarkerUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetPolylineUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetPositionStreamUseCase.dart';
import 'package:rapidito/src/domain/useCases/users/UpdateUserUseCase.dart';
import 'package:rapidito/src/domain/useCases/users/UsersUseCases.dart';

import 'package:rapidito/src/data/repository/FirebaseRideRequestRepositoryImpl.dart';
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';
import 'package:rapidito/src/domain/useCases/rides/CreateRideRequestUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/ListenRideRequestsUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/UpdateRideRequestStatusUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/GetRideRequestStreamUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';

@module
abstract class AppModule {
  @injectable
  SharefPref get sharefPref => SharefPref();

  @injectable
  AuthService get authService => AuthService();

  @injectable
  UsersService get usersService => UsersService(sharefPref);

  @injectable
  AuthRepository get authRepository =>
      Authrepositoryimpl(authService: authService, sharefPref: sharefPref);

  @injectable
  UsersRepository get usersRepository => UsersRepositoryImpl(usersService);

  @injectable
  GeolocatorRepository get geolocatorRepository => GeolocatorRepositoryImpl();

  @injectable
  RideRequestRepository get rideRequestRepository =>
      FirebaseRideRequestRepositoryImpl();

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    login: LoginUseCase(repository: authRepository),
    register: RegisterUseCase(authRepository: authRepository),
    saveUserSession: SaveUserSessionUseCase(repository: authRepository),
    getUserSession: GetUserSessionUseCase(authRepository: authRepository),
    removeUserSession: RemoveUserSessionUseCase(repository: authRepository),
  );

  @injectable
  UsersUseCases get usersUseCases =>
      UsersUseCases(update: UpdateUserUseCase(usersRepository));

  @injectable
  GeolocatorUseCases get geolocatorUseCases => GeolocatorUseCases(
    findPosition: FindPositionUseCase(
      geolocatorRepository: geolocatorRepository,
    ),
    createMarker: CreateMarkerUseCase(
      geolocatorRepository: geolocatorRepository,
    ),
    getMarker: GetMarkerUseCase(geolocatorRepository: geolocatorRepository),
    getPolyline: GetPolylineUseCase(geolocatorRepository: geolocatorRepository),
    getPositionStream: GetPositionStreamUseCase(
      geolocatorRepository: geolocatorRepository,
    ),
  );

  @injectable
  RidesUseCases get ridesUseCases => RidesUseCases(
    createRideRequest: CreateRideRequestUseCase(rideRequestRepository),
    listenRideRequests: ListenRideRequestsUseCase(rideRequestRepository),
    updateRideRequestStatus: UpdateRideRequestStatusUseCase(
      rideRequestRepository,
    ),
    getRideRequestStream: GetRideRequestStreamUseCase(rideRequestRepository),
  );
}

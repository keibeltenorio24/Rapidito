// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:rapidito/src/data/dataSource/local/SharefPref.dart' as _i861;
import 'package:rapidito/src/data/dataSource/remote/service/AuthService.dart'
    as _i331;
import 'package:rapidito/src/data/dataSource/remote/service/UsersService.dart'
    as _i406;
import 'package:rapidito/src/di/AppModule.dart' as _i885;
import 'package:rapidito/src/domain/repository/AuthRepository.dart' as _i656;
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart'
    as _i232;
import 'package:rapidito/src/domain/repository/UsersRepository.dart' as _i1060;
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart' as _i848;
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart'
    as _i438;
import 'package:rapidito/src/domain/useCases/users/UsersUseCases.dart' as _i74;
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart' as _i998;
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart' as _i999;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i861.SharefPref>(() => appModule.sharefPref);
    gh.factory<_i331.AuthService>(() => appModule.authService);
    gh.factory<_i406.UsersService>(() => appModule.usersService);
    gh.factory<_i656.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i1060.UsersRepository>(() => appModule.usersRepository);
    gh.factory<_i232.GeolocatorRepository>(
      () => appModule.geolocatorRepository,
    );
    gh.factory<_i998.RideRequestRepository>(() => appModule.rideRequestRepository);
    gh.factory<_i848.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i74.UsersUseCases>(() => appModule.usersUseCases);
    gh.factory<_i438.GeolocatorUseCases>(() => appModule.geolocatorUseCases);
    gh.factory<_i999.RidesUseCases>(() => appModule.ridesUseCases);
    return this;
  }
}

class _$AppModule extends _i885.AppModule {}

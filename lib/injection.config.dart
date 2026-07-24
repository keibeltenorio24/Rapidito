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
import 'package:rapidito/src/di/AppModule.dart' as _i885;
import 'package:rapidito/src/domain/repository/AuthRepository.dart' as _i656;
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart' as _i848;

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
    gh.factory<_i656.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i848.AuthUseCases>(() => appModule.authUseCases);
    return this;
  }
}

class _$AppModule extends _i885.AppModule {}

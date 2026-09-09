import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/presentation/pages/driver/home/bloc/DriverHomeEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/home/bloc/DriverHomeState.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  final AuthUseCases authUseCases;

  DriverHomeBloc({required this.authUseCases})
    : super(const DriverHomeState()) {
    on<ChangeDriverPageEvent>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<DriverLogoutEvent>((event, emit) async {
      await authUseCases.removeUserSession.run();
    });

    on<DriverHomeInitEvent>((event, emit) async {
      final authResponse = await authUseCases.getUserSession.run();
      if (authResponse != null) {
        emit(
          state.copyWith(
            roles: authResponse.user.roles,
            user: authResponse.user,
          ),
        );
      }
    });
  }
}

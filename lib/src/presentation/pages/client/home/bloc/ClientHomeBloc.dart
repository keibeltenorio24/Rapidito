import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeState.dart';

class ClientHomeBloc extends Bloc<ClientHomeEvent, ClientHomeState> {
  final AuthUseCases authUseCases;

  ClientHomeBloc({required this.authUseCases}) : super(ClientHomeState()) {
    on<ChangePageEvent>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<ClientLogoutEvent>((event, emit) async {
      await authUseCases.removeUserSession.run();
    });
  }
}

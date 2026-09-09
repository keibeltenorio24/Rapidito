import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/history/bloc/TripHistoryEvent.dart';
import 'package:rapidito/src/presentation/pages/history/bloc/TripHistoryState.dart';

class TripHistoryBloc extends Bloc<TripHistoryEvent, TripHistoryState> {
  final AuthUseCases authUseCases;
  final RidesUseCases ridesUseCases;

  TripHistoryBloc({required this.authUseCases, required this.ridesUseCases})
    : super(const TripHistoryState()) {
    on<TripHistoryInitEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final authResponse = await authUseCases.getUserSession.run();
        if (authResponse != null && authResponse.user.id != null) {
          final trips = await ridesUseCases.getRideHistory.run(
            authResponse.user.id!.toString(),
            event.role,
          );
          emit(state.copyWith(isLoading: false, trips: trips));
        } else {
          emit(state.copyWith(isLoading: false, error: 'User not logged in'));
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}

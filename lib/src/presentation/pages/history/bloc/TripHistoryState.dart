import 'package:equatable/equatable.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

class TripHistoryState extends Equatable {
  final bool isLoading;
  final List<RideRequest> trips;
  final String? error;

  const TripHistoryState({
    this.isLoading = false,
    this.trips = const [],
    this.error,
  });

  TripHistoryState copyWith({
    bool? isLoading,
    List<RideRequest>? trips,
    String? error,
  }) {
    return TripHistoryState(
      isLoading: isLoading ?? this.isLoading,
      trips: trips ?? this.trips,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, trips, error];
}

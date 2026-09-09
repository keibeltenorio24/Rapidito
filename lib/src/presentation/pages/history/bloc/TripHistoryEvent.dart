import 'package:equatable/equatable.dart';

abstract class TripHistoryEvent extends Equatable {
  const TripHistoryEvent();

  @override
  List<Object> get props => [];
}

class TripHistoryInitEvent extends TripHistoryEvent {
  final String role;

  const TripHistoryInitEvent({required this.role});

  @override
  List<Object> get props => [role];
}

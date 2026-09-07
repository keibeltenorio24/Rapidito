import 'package:rapidito/src/domain/models/RideRequest.dart';

abstract class DriverTripEvent {}

class DriverTripInitEvent extends DriverTripEvent {
  final RideRequest rideRequest;
  DriverTripInitEvent({required this.rideRequest});
}

class FinishTripEvent extends DriverTripEvent {}

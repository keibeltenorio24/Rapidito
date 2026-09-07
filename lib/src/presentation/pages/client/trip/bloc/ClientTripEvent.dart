import 'package:rapidito/src/domain/models/RideRequest.dart';

abstract class ClientTripEvent {}

class ClientTripInitEvent extends ClientTripEvent {
  final RideRequest rideRequest;
  ClientTripInitEvent({required this.rideRequest});
}

class UpdateRideRequestEvent extends ClientTripEvent {
  final RideRequest rideRequest;
  UpdateRideRequestEvent({required this.rideRequest});
}

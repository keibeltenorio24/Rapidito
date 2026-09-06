import 'package:rapidito/src/domain/models/RideRequest.dart';

abstract class DriverReceiveRequestEvent {}

class DriverReceiveRequestInitEvent extends DriverReceiveRequestEvent {
  final RideRequest rideRequest;
  DriverReceiveRequestInitEvent({required this.rideRequest});
}

class AcceptRideRequestEvent extends DriverReceiveRequestEvent {
  final String rideRequestId;
  AcceptRideRequestEvent({required this.rideRequestId});
}

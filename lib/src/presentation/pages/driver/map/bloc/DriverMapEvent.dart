import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

abstract class DriverMapEvent extends Equatable {
  const DriverMapEvent();

  @override
  List<Object> get props => [];
}

class DriverMapInitEvent extends DriverMapEvent {}

class UpdateLocationEvent extends DriverMapEvent {}

class OnLocationUpdated extends DriverMapEvent {
  final Position position;
  const OnLocationUpdated({required this.position});

  @override
  List<Object> get props => [position];
}

class StopLocationEvent extends DriverMapEvent {}

class ToggleConnectEvent extends DriverMapEvent {}

class OnNewRideRequest extends DriverMapEvent {
  final RideRequest request;
  const OnNewRideRequest({required this.request});
  
  @override
  List<Object> get props => [request];
}

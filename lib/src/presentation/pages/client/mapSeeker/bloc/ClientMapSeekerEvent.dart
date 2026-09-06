import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

abstract class ClientMapSeekerEvent {}

class ClientMapSeekerInitEvent extends ClientMapSeekerEvent {}

class FindPosition extends ClientMapSeekerEvent {}

class ChangeMapCameraPosition extends ClientMapSeekerEvent {
  final double latitude;
  final double longitude;
  ChangeMapCameraPosition({required this.latitude, required this.longitude});
}

class OnSearchPlace extends ClientMapSeekerEvent {
  final String query;
  OnSearchPlace({required this.query});
}

class OnSelectPlace extends ClientMapSeekerEvent {
  final String placeId;
  OnSelectPlace({required this.placeId});
}

class OnMapMoved extends ClientMapSeekerEvent {
  final double latitude;
  final double longitude;
  final bool isOrigin;
  OnMapMoved({required this.latitude, required this.longitude, required this.isOrigin});
}

class OnDrawRoute extends ClientMapSeekerEvent {
  final LatLng origin;
  final LatLng destination;
  OnDrawRoute({required this.origin, required this.destination});
}

class OnCancelRoute extends ClientMapSeekerEvent {}

class OnCreateRideRequest extends ClientMapSeekerEvent {
  final RideRequest rideRequest;
  OnCreateRideRequest({required this.rideRequest});
}

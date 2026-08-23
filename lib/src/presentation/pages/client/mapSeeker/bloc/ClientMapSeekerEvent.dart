import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

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

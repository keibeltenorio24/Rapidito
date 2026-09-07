import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

class ClientTripState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Marker? originMarker;
  final Marker? destinationMarker;
  final Map<PolylineId, Polyline> polylines;
  final RideRequest? rideRequest;

  ClientTripState({
    this.controller,
    this.originMarker,
    this.destinationMarker,
    this.polylines = const {},
    this.rideRequest,
  });

  ClientTripState copyWith({
    Completer<GoogleMapController>? controller,
    Marker? originMarker,
    Marker? destinationMarker,
    Map<PolylineId, Polyline>? polylines,
    RideRequest? rideRequest,
  }) {
    return ClientTripState(
      controller: controller ?? this.controller,
      originMarker: originMarker ?? this.originMarker,
      destinationMarker: destinationMarker ?? this.destinationMarker,
      polylines: polylines ?? this.polylines,
      rideRequest: rideRequest ?? this.rideRequest,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    originMarker,
    destinationMarker,
    polylines,
    rideRequest,
  ];
}

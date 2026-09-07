import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

class DriverTripState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Marker? originMarker;
  final Marker? destinationMarker;
  final Map<PolylineId, Polyline> polylines;
  final RideRequest? rideRequest;
  final bool isCompleting;
  final bool isCompleted;

  DriverTripState({
    this.controller,
    this.originMarker,
    this.destinationMarker,
    this.polylines = const {},
    this.rideRequest,
    this.isCompleting = false,
    this.isCompleted = false,
  });

  DriverTripState copyWith({
    Completer<GoogleMapController>? controller,
    Marker? originMarker,
    Marker? destinationMarker,
    Map<PolylineId, Polyline>? polylines,
    RideRequest? rideRequest,
    bool? isCompleting,
    bool? isCompleted,
  }) {
    return DriverTripState(
      controller: controller ?? this.controller,
      originMarker: originMarker ?? this.originMarker,
      destinationMarker: destinationMarker ?? this.destinationMarker,
      polylines: polylines ?? this.polylines,
      rideRequest: rideRequest ?? this.rideRequest,
      isCompleting: isCompleting ?? this.isCompleting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    originMarker,
    destinationMarker,
    polylines,
    rideRequest,
    isCompleting,
    isCompleted,
  ];
}

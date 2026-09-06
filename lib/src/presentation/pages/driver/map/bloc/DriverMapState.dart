import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

class DriverMapState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final Marker? marker;
  final bool isActive;
  final String? error;
  final RideRequest? newRideRequest;

  DriverMapState({
    this.controller,
    this.position,
    this.marker,
    this.isActive = false,
    this.error,
    this.newRideRequest,
  });

  DriverMapState copyWith({
    Completer<GoogleMapController>? controller,
    Position? position,
    Marker? marker,
    bool? isActive,
    String? error,
    RideRequest? newRideRequest,
  }) {
    return DriverMapState(
      controller: controller ?? this.controller,
      position: position ?? this.position,
      marker: marker ?? this.marker,
      isActive: isActive ?? this.isActive,
      error: error ?? this.error,
      newRideRequest: newRideRequest ?? this.newRideRequest,
    );
  }

  @override
  List<Object?> get props => [
        controller,
        position,
        marker,
        isActive,
        error,
        newRideRequest,
      ];
}

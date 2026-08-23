import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapSeekerState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final Marker? marker;
  final String? error;
  final List<dynamic> placesPredictions;

  ClientMapSeekerState({
    this.position,
    this.controller,
    this.marker,
    this.error,
    this.placesPredictions = const [],
  });

  ClientMapSeekerState copyWith({
    Position? position,
    Completer<GoogleMapController>? controller,
    Marker? marker,
    String? error,
    List<dynamic>? placesPredictions,
  }) {
    return ClientMapSeekerState(
      position: position ?? this.position,
      controller: controller ?? this.controller,
      marker: marker ?? this.marker,
      error: error ?? this.error,
      placesPredictions: placesPredictions ?? this.placesPredictions,
    );
  }

  @override
  List<Object?> get props => [position, marker, error, placesPredictions];
}

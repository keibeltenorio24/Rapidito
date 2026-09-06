import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapSeekerState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final Marker? marker;
  final Marker? destinationMarker;
  final String? error;
  final List<dynamic> placesPredictions;
  final String? placemarkName;
  final String? originName;
  final String? destinationName;
  final LatLng? originPosition;
  final LatLng? destinationPosition;
  final Map<PolylineId, Polyline> polylines;
  final String? distanceText;
  final String? durationText;
  final double? price;
  final bool isRequesting;
  final String? rideRequestId;

  ClientMapSeekerState({
    this.position,
    this.controller,
    this.marker,
    this.destinationMarker,
    this.error,
    this.placesPredictions = const [],
    this.placemarkName,
    this.originName,
    this.destinationName,
    this.originPosition,
    this.destinationPosition,
    this.polylines = const {},
    this.distanceText,
    this.durationText,
    this.price,
    this.isRequesting = false,
    this.rideRequestId,
  });

  ClientMapSeekerState copyWith({
    Position? position,
    Completer<GoogleMapController>? controller,
    Marker? marker,
    Marker? destinationMarker,
    String? error,
    List<dynamic>? placesPredictions,
    String? placemarkName,
    String? originName,
    String? destinationName,
    LatLng? originPosition,
    LatLng? destinationPosition,
    Map<PolylineId, Polyline>? polylines,
    String? distanceText,
    String? durationText,
    double? price,
    bool? isRequesting,
    String? rideRequestId,
  }) {
    return ClientMapSeekerState(
      position: position ?? this.position,
      controller: controller ?? this.controller,
      marker: marker ?? this.marker,
      destinationMarker: destinationMarker ?? this.destinationMarker,
      error: error ?? this.error,
      placesPredictions: placesPredictions ?? this.placesPredictions,
      placemarkName: placemarkName ?? this.placemarkName,
      originName: originName ?? this.originName,
      destinationName: destinationName ?? this.destinationName,
      originPosition: originPosition ?? this.originPosition,
      destinationPosition: destinationPosition ?? this.destinationPosition,
      polylines: polylines ?? this.polylines,
      distanceText: distanceText ?? this.distanceText,
      durationText: durationText ?? this.durationText,
      price: price ?? this.price,
      isRequesting: isRequesting ?? this.isRequesting,
      rideRequestId: rideRequestId ?? this.rideRequestId,
    );
  }

  @override
  List<Object?> get props => [
    position,
    marker,
    destinationMarker,
    error,
    placesPredictions,
    placemarkName,
    originName,
    destinationName,
    originPosition,
    destinationPosition,
    polylines,
    distanceText,
    durationText,
    price,
    isRequesting,
    rideRequestId,
  ];
}

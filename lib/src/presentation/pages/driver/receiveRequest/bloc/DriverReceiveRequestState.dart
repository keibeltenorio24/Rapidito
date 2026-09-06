import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverReceiveRequestState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Marker? originMarker;
  final Marker? destinationMarker;
  final Map<PolylineId, Polyline> polylines;
  final bool isAccepting;
  final bool isAccepted;

  DriverReceiveRequestState({
    this.controller,
    this.originMarker,
    this.destinationMarker,
    this.polylines = const {},
    this.isAccepting = false,
    this.isAccepted = false,
  });

  DriverReceiveRequestState copyWith({
    Completer<GoogleMapController>? controller,
    Marker? originMarker,
    Marker? destinationMarker,
    Map<PolylineId, Polyline>? polylines,
    bool? isAccepting,
    bool? isAccepted,
  }) {
    return DriverReceiveRequestState(
      controller: controller ?? this.controller,
      originMarker: originMarker ?? this.originMarker,
      destinationMarker: destinationMarker ?? this.destinationMarker,
      polylines: polylines ?? this.polylines,
      isAccepting: isAccepting ?? this.isAccepting,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    originMarker,
    destinationMarker,
    polylines,
    isAccepting,
    isAccepted,
  ];
}

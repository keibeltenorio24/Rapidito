import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapSeekerState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final String? error;

  const ClientMapSeekerState({this.position, this.controller, this.error});

  ClientMapSeekerState copyWith({
    Position? position,
    Completer<GoogleMapController>? controller,
    String? error,
  }) {
    return ClientMapSeekerState(
      position: position ?? this.position,
      controller: controller ?? this.controller,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [position, error];
}

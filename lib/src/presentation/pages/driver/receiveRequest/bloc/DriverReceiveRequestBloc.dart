import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/presentation/pages/driver/receiveRequest/bloc/DriverReceiveRequestEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/receiveRequest/bloc/DriverReceiveRequestState.dart';

import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';

class DriverReceiveRequestBloc
    extends Bloc<DriverReceiveRequestEvent, DriverReceiveRequestState> {
  final GeolocatorUseCases geolocatorUseCases;
  final RidesUseCases ridesUseCases;

  DriverReceiveRequestBloc({required this.geolocatorUseCases, required this.ridesUseCases})
    : super(DriverReceiveRequestState()) {
    on<DriverReceiveRequestInitEvent>((event, emit) async {
      emit(state.copyWith(controller: Completer<GoogleMapController>()));

      BitmapDescriptor originIcon = await geolocatorUseCases.createMarker.run(
        'assets/img/location_blue.png',
      );
      BitmapDescriptor destinationIcon = await geolocatorUseCases.createMarker
          .run('assets/img/location_blue.png');

      Marker originMarker = geolocatorUseCases.getMarker.run(
        'origin',
        event.rideRequest.originPosition.latitude,
        event.rideRequest.originPosition.longitude,
        'Origen',
        '',
        originIcon,
      );

      Marker destinationMarker = geolocatorUseCases.getMarker.run(
        'destination',
        event.rideRequest.destinationPosition.latitude,
        event.rideRequest.destinationPosition.longitude,
        'Destino',
        '',
        destinationIcon,
      );

      PolylineId id = const PolylineId("route");
      Polyline polyline = Polyline(
        polylineId: id,
        color: const Color(0xFF4285F4),
        points: event.rideRequest.polylineCoordinates,
        width: 5,
      );

      emit(
        state.copyWith(
          originMarker: originMarker,
          destinationMarker: destinationMarker,
          polylines: {id: polyline},
        ),
      );
    });

    on<AcceptRideRequestEvent>((event, emit) async {
      emit(state.copyWith(isAccepting: true));
      try {
        await ridesUseCases.updateRideRequestStatus.run(event.rideRequestId, 'accepted', 'driver_temporal_123');
        emit(state.copyWith(isAccepting: false, isAccepted: true));
      } catch (e) {
        emit(state.copyWith(isAccepting: false));
        print('Error accepting ride: $e');
      }
    });
  }
}

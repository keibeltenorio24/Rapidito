import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/driver/trip/bloc/DriverTripEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/trip/bloc/DriverTripState.dart';

class DriverTripBloc extends Bloc<DriverTripEvent, DriverTripState> {
  final GeolocatorUseCases geolocatorUseCases;
  final RidesUseCases ridesUseCases;
  final AuthUseCases authUseCases;

  DriverTripBloc({
    required this.geolocatorUseCases,
    required this.ridesUseCases,
    required this.authUseCases,
  }) : super(DriverTripState()) {
    on<DriverTripInitEvent>((event, emit) async {
      emit(
        state.copyWith(
          controller: Completer<GoogleMapController>(),
          rideRequest: event.rideRequest,
        ),
      );

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

    on<FinishTripEvent>((event, emit) async {
      if (state.rideRequest == null || state.rideRequest!.id == null) return;
      emit(state.copyWith(isCompleting: true));

      final authResponse = await authUseCases.getUserSession.run();
      final driverId = authResponse?.user.id?.toString();

      if (driverId != null) {
        try {
          await ridesUseCases.updateRideRequestStatus.run(
            state.rideRequest!.id!,
            'completed',
            driverId,
          );
          emit(state.copyWith(isCompleting: false, isCompleted: true));
        } catch (e) {
          emit(state.copyWith(isCompleting: false));
          // Emitir estado de error si es necesario
        }
      } else {
        emit(state.copyWith(isCompleting: false));
      }
    });
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/client/trip/bloc/ClientTripEvent.dart';
import 'package:rapidito/src/presentation/pages/client/trip/bloc/ClientTripState.dart';

class ClientTripBloc extends Bloc<ClientTripEvent, ClientTripState> {
  final GeolocatorUseCases geolocatorUseCases;
  final RidesUseCases ridesUseCases;
  StreamSubscription<RideRequest?>? _rideRequestSubscription;

  ClientTripBloc({
    required this.geolocatorUseCases,
    required this.ridesUseCases,
  }) : super(ClientTripState()) {
    on<ClientTripInitEvent>((event, emit) async {
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

      // Start listening to the ride request in Firebase
      if (event.rideRequest.id != null) {
        _rideRequestSubscription?.cancel();
        _rideRequestSubscription = ridesUseCases.getRideRequestStream
            .run(event.rideRequest.id!)
            .listen((rideRequest) {
              if (rideRequest != null) {
                add(UpdateRideRequestEvent(rideRequest: rideRequest));
              }
            });
      }
    });

    on<UpdateRideRequestEvent>((event, emit) {
      emit(state.copyWith(rideRequest: event.rideRequest));
    });
  }

  @override
  Future<void> close() {
    _rideRequestSubscription?.cancel();
    return super.close();
  }
}

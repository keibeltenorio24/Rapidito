import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/presentation/pages/driver/map/bloc/DriverMapEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/map/bloc/DriverMapState.dart';

import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

class DriverMapBloc extends Bloc<DriverMapEvent, DriverMapState> {
  final GeolocatorUseCases geolocatorUseCases;
  final RidesUseCases ridesUseCases;
  StreamSubscription? locationSubscription;
  StreamSubscription<List<RideRequest>>? rideRequestsSubscription;

  DriverMapBloc({required this.geolocatorUseCases, required this.ridesUseCases})
    : super(DriverMapState()) {
    on<DriverMapInitEvent>((event, emit) async {
      emit(state.copyWith(controller: Completer<GoogleMapController>()));

      BitmapDescriptor markerIcon = await geolocatorUseCases.createMarker.run(
        'assets/img/location_blue.png',
      );

      emit(
        state.copyWith(
          marker: Marker(markerId: const MarkerId('driver'), icon: markerIcon),
        ),
      );

      add(UpdateLocationEvent());
    });

    on<UpdateLocationEvent>((event, emit) async {
      try {
        Position position = await geolocatorUseCases.findPosition.run();

        if (state.marker != null) {
          emit(
            state.copyWith(
              position: position,
              marker: state.marker!.copyWith(
                positionParam: LatLng(position.latitude, position.longitude),
              ),
            ),
          );
        }

        if (state.controller != null && state.controller!.isCompleted) {
          final GoogleMapController mapController =
              await state.controller!.future;
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16,
              ),
            ),
          );
        }

        locationSubscription = geolocatorUseCases.getPositionStream
            .run()
            .listen((Position position) {
              add(OnLocationUpdated(position: position));
            });
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<OnLocationUpdated>((event, emit) async {
      if (state.marker != null) {
        emit(
          state.copyWith(
            position: event.position,
            marker: state.marker!.copyWith(
              positionParam: LatLng(
                event.position.latitude,
                event.position.longitude,
              ),
            ),
          ),
        );
      }

      if (state.controller != null && state.controller!.isCompleted) {
        final GoogleMapController mapController =
            await state.controller!.future;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(event.position.latitude, event.position.longitude),
              zoom: 16,
            ),
          ),
        );
      }
    });

    on<ToggleConnectEvent>((event, emit) {
      final newIsActive = !state.isActive;
      emit(state.copyWith(isActive: newIsActive));

      if (newIsActive) {
        // Iniciar a escuchar viajes de Firestore
        rideRequestsSubscription = ridesUseCases.listenRideRequests
            .run()
            .listen((requests) {
              if (requests.isNotEmpty) {
                add(OnNewRideRequest(request: requests.first));
              }
            });
      } else {
        // Dejar de escuchar
        rideRequestsSubscription?.cancel();
        rideRequestsSubscription = null;
      }
    });

    on<OnNewRideRequest>((event, emit) {
      emit(state.copyWith(newRideRequest: event.request));
    });

    on<StopLocationEvent>((event, emit) {
      locationSubscription?.cancel();
    });
  }

  @override
  Future<void> close() {
    locationSubscription?.cancel();
    rideRequestsSubscription?.cancel();
    return super.close();
  }
}

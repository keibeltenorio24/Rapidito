import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerState.dart';

class ClientMapSeekerBloc
    extends Bloc<ClientMapSeekerEvent, ClientMapSeekerState> {
  final GeolocatorUseCases geolocatorUseCases;

  ClientMapSeekerBloc({required this.geolocatorUseCases})
    : super(ClientMapSeekerState()) {
    on<ClientMapSeekerInitEvent>((event, emit) async {
      emit(state.copyWith(controller: Completer<GoogleMapController>()));
    });
    on<FindPosition>((event, emit) async {
      try {
        Position position = await geolocatorUseCases.findPosition.run();
        emit(state.copyWith(position: position, error: null));
        print('position ${position.latitude}');
        print('position ${position.longitude}');
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<ChangeMapCameraPosition>((event, emit) async {
      if (state.controller == null || !state.controller!.isCompleted) {
        return;
      }
      GoogleMapController googleMapController = await state.controller!.future;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 16,
            bearing: 0,
          ),
        ),
      );
    });
  }
}

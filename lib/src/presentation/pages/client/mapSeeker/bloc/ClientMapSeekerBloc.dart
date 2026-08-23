import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerState.dart';

class ClientMapSeekerBloc
    extends Bloc<ClientMapSeekerEvent, ClientMapSeekerState> {
  final GeolocatorUseCases geolocatorUseCases;
  final String _googleApiKey = 'AIzaSyBHJifu14P0CTs6cflg9B6ikOLCRfxOv_k';

  ClientMapSeekerBloc({required this.geolocatorUseCases})
    : super(ClientMapSeekerState()) {
    on<ClientMapSeekerInitEvent>((event, emit) async {
      emit(state.copyWith(controller: Completer<GoogleMapController>()));
    });
    on<FindPosition>((event, emit) async {
      try {
        Position position = await geolocatorUseCases.findPosition.run();

        // Crear el icono del marcador
        BitmapDescriptor imageMarker = await geolocatorUseCases.createMarker
            .run('assets/img/location_blue.png');

        // Configurar el marcador
        Marker marker = geolocatorUseCases.getMarker.run(
          'my_location',
          position.latitude,
          position.longitude,
          'Mi ubicación',
          '',
          imageMarker,
        );

        emit(state.copyWith(position: position, marker: marker, error: null));
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

    on<OnSearchPlace>((event, emit) async {
      if (event.query.isEmpty) {
        emit(state.copyWith(placesPredictions: []));
        return;
      }
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${event.query}&key=$_googleApiKey&language=es&components=country:ve',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            emit(state.copyWith(placesPredictions: data['predictions']));
          } else {
            emit(state.copyWith(placesPredictions: []));
          }
        }
      } catch (e) {
        emit(state.copyWith(placesPredictions: []));
      }
    });

    on<OnSelectPlace>((event, emit) async {
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${event.placeId}&key=$_googleApiKey&language=es',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            final lat = data['result']['geometry']['location']['lat'];
            final lng = data['result']['geometry']['location']['lng'];

            BitmapDescriptor imageMarker = await geolocatorUseCases.createMarker
                .run('assets/img/location_blue.png');

            Marker destinationMarker = geolocatorUseCases.getMarker.run(
              'destination',
              lat,
              lng,
              'Destino',
              '',
              imageMarker,
            );

            emit(
              state.copyWith(marker: destinationMarker, placesPredictions: []),
            );

            add(ChangeMapCameraPosition(latitude: lat, longitude: lng));
          }
        }
      } catch (e) {
        // Handle error if needed
      }
    });
  }
}

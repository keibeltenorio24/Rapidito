import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerState.dart';

import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';

class ClientMapSeekerBloc
    extends Bloc<ClientMapSeekerEvent, ClientMapSeekerState> {
  final GeolocatorUseCases geolocatorUseCases;
  final RidesUseCases ridesUseCases;
  final Geocoding geocoding = Geocoding();
  final String _googleApiKey = 'AIzaSyBHJifu14P0CTs6cflg9B6ikOLCRfxOv_k';

  ClientMapSeekerBloc({required this.geolocatorUseCases, required this.ridesUseCases})
    : super(ClientMapSeekerState()) {
    on<ClientMapSeekerInitEvent>((event, emit) async {
      emit(ClientMapSeekerState(controller: Completer<GoogleMapController>()));
    });
    on<FindPosition>((event, emit) async {
      try {
        Position position = await geolocatorUseCases.findPosition.run();

        // Obtener la direccion usando reverse geocoding
        String placemarkName = '';
        try {
          List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks.first;

            String name = placemark.name ?? '';
            String street = placemark.street ?? '';
            String thoroughfare = placemark.thoroughfare ?? '';
            String subLocality = placemark.subLocality ?? '';
            String locality = placemark.locality ?? '';

            List<String> parts = [];

            if (name.isNotEmpty && !name.contains('+')) {
              parts.add(name);
            } else if (street.isNotEmpty && !street.contains('+')) {
              parts.add(street);
            } else if (thoroughfare.isNotEmpty && !thoroughfare.contains('+')) {
              parts.add(thoroughfare);
            }

            if (subLocality.isNotEmpty && !parts.contains(subLocality)) {
              parts.add(subLocality);
            }

            if (locality.isNotEmpty && !parts.contains(locality)) {
              parts.add(locality);
            }

            placemarkName = parts.join(', ');
            if (placemarkName.isEmpty) {
              placemarkName = 'Ubicación desconocida';
            }
          }
        } catch (e) {
          print('Error en geocoding: $e');
        }

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

        emit(
          state.copyWith(
            position: position,
            originPosition: LatLng(position.latitude, position.longitude),
            marker: marker,
            placemarkName: placemarkName.isNotEmpty ? placemarkName : null,
            error: null,
          ),
        );
        add(
          ChangeMapCameraPosition(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
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

    String _currentQuery = '';

    on<OnSearchPlace>((event, emit) async {
      _currentQuery = event.query;
      if (event.query.isEmpty) {
        emit(state.copyWith(placesPredictions: []));
        return;
      }
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${event.query}&key=$_googleApiKey&language=es&components=country:ve',
        );
        final response = await http.get(url);

        // Prevent race condition: only emit if this query is still the current one
        if (_currentQuery != event.query) return;

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            emit(
              state.copyWith(
                placesPredictions: data['predictions'],
                polylines: const {},
              ),
            );
          } else {
            emit(state.copyWith(placesPredictions: [], polylines: const {}));
          }
        }
      } catch (e) {
        if (_currentQuery == event.query) {
          emit(state.copyWith(placesPredictions: []));
        }
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
              state.copyWith(
                marker: destinationMarker,
                destinationMarker: destinationMarker,
                destinationPosition: LatLng(lat, lng),
                placesPredictions: [],
                polylines: const {}, // Clear the previous route
              ),
            );

            add(ChangeMapCameraPosition(latitude: lat, longitude: lng));
          }
        }
      } catch (e) {
        // Handle error if needed
      }
    });

    on<OnMapMoved>((event, emit) async {
      if (state.polylines.isNotEmpty)
        return; // Ignore map movements if route is drawn

      String placemarkName = '';
      try {
        final Geocoding geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          event.latitude,
          event.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;

          String name = placemark.name ?? '';
          String street = placemark.street ?? '';
          String thoroughfare = placemark.thoroughfare ?? '';
          String subLocality = placemark.subLocality ?? '';
          String locality = placemark.locality ?? '';

          List<String> parts = [];

          if (name.isNotEmpty && !name.contains('+')) {
            parts.add(name);
          } else if (street.isNotEmpty && !street.contains('+')) {
            parts.add(street);
          } else if (thoroughfare.isNotEmpty && !thoroughfare.contains('+')) {
            parts.add(thoroughfare);
          }

          if (subLocality.isNotEmpty && !parts.contains(subLocality)) {
            parts.add(subLocality);
          }

          if (locality.isNotEmpty && !parts.contains(locality)) {
            parts.add(locality);
          }

          placemarkName = parts.join(', ');
          if (placemarkName.isEmpty) {
            placemarkName = 'Ubicación desconocida';
          }
        }
      } catch (e) {
        print('Error en geocoding OnMapMoved: $e');
      }

      Position newPosition = Position(
        latitude: event.latitude,
        longitude: event.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      emit(
        state.copyWith(
          position: newPosition,
          placemarkName: placemarkName.isNotEmpty ? placemarkName : null,
          originPosition: event.isOrigin
              ? LatLng(event.latitude, event.longitude)
              : state.originPosition,
          destinationPosition: !event.isOrigin
              ? LatLng(event.latitude, event.longitude)
              : state.destinationPosition,
        ),
      );
    });

    on<OnDrawRoute>((event, emit) async {
      try {
        final directionData = await geolocatorUseCases.getPolyline.run(
          event.origin,
          event.destination,
        );

        List<LatLng> polylineCoordinates = directionData.polylineCoordinates;

        if (polylineCoordinates.isNotEmpty) {
          PolylineId id = const PolylineId("myRoute");
          Polyline polyline = Polyline(
            polylineId: id,
            color: Color(0xFF4285F4),
            points: polylineCoordinates,
            width: 5,
          );

          // Calcular precio (Ejemplo: $1.50 base + $0.50 por km)
          double distanceKm = directionData.distanceValue / 1000;
          double price = 1.50 + (0.50 * distanceKm);

          emit(
            state.copyWith(
              polylines: {id: polyline},
              distanceText: directionData.distanceText,
              durationText: directionData.durationText,
              price: double.parse(price.toStringAsFixed(2)),
            ),
          );

          // Animar la camara para mostrar toda la ruta
          if (state.controller != null && state.controller!.isCompleted) {
            GoogleMapController googleMapController =
                await state.controller!.future;

            // Calculate bounds
            double minLat = event.origin.latitude;
            double minLng = event.origin.longitude;
            double maxLat = event.origin.latitude;
            double maxLng = event.origin.longitude;

            for (var point in polylineCoordinates) {
              if (point.latitude < minLat) minLat = point.latitude;
              if (point.latitude > maxLat) maxLat = point.latitude;
              if (point.longitude < minLng) minLng = point.longitude;
              if (point.longitude > maxLng) maxLng = point.longitude;
            }

            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(minLat, minLng),
              northeast: LatLng(maxLat, maxLng),
            );

            googleMapController.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 50.0), // 50 points padding
            );
          }
        }
      } catch (e) {
        print('Error drawing route: $e');
      }
    });

    on<OnCancelRoute>((event, emit) {
      emit(state.copyWith(polylines: const {}));
    });

    on<OnCreateRideRequest>((event, emit) async {
      emit(state.copyWith(isRequesting: true));
      try {
        String requestId = await ridesUseCases.createRideRequest.run(event.rideRequest);
        emit(state.copyWith(isRequesting: false, rideRequestId: requestId));
      } catch (e) {
        print('Error creating ride request in firebase: $e');
        emit(state.copyWith(isRequesting: false));
      }
    });
  }
}

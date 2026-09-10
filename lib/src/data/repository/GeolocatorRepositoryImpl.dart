import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';
import 'package:rapidito/src/domain/models/DirectionData.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeolocatorRepositoryImpl implements GeolocatorRepository {
  @override
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('La ubicacion no esta habilitada');
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Los permisos de ubicacion han sido denegados');
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Los permisos de ubicacion han sido denegados permanentemente');
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<BitmapDescriptor> createMarkerFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
      configuration,
      path,
    );
    return descriptor;
  }

  @override
  Marker getMarker(
    String markerId,
    double latitude,
    double longitude,
    String title,
    String content,
    BitmapDescriptor imageMarker,
  ) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: imageMarker,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: title, snippet: content),
    );
    return marker;
  }

  @override
  Future<DirectionData> getPolyline(LatLng origin, LatLng destination) async {
    String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'OK') {
        final route = jsonResponse['routes'][0];
        final leg = route['legs'][0];

        final distanceText = leg['distance']['text'];
        final distanceValue = leg['distance']['value'].toDouble();

        final durationText = leg['duration']['text'];
        final durationValue = leg['duration']['value'];

        final encodedPolyline = route['overview_polyline']['points'];

        List<PointLatLng> decodedPoints = PolylinePoints.decodePolyline(
          encodedPolyline,
        );
        List<LatLng> polylineCoordinates = decodedPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        return DirectionData(
          polylineCoordinates: polylineCoordinates,
          distanceText: distanceText,
          distanceValue: distanceValue,
          durationText: durationText,
          durationValue: durationValue,
        );
      } else {
        throw Exception('Directions API error: ${jsonResponse['status']}');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  @override
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // update every 1 meter
      ),
    );
  }
}

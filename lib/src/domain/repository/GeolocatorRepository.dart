import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/DirectionData.dart';

abstract class GeolocatorRepository {
  Future<Position> determinePosition();
  Future<BitmapDescriptor> createMarkerFromAsset(String path);
  Marker getMarker(
    String markerId,
    double latitude,
    double longitude,
    String title,
    String content,
    BitmapDescriptor imageMarker,
  );
  Future<DirectionData> getPolyline(LatLng origin, LatLng destination);
}

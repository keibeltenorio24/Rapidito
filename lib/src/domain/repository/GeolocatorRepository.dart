import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
}

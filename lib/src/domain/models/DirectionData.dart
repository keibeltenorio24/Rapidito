import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionData {
  final List<LatLng> polylineCoordinates;
  final String distanceText;
  final double distanceValue;
  final String durationText;
  final int durationValue;

  DirectionData({
    required this.polylineCoordinates,
    required this.distanceText,
    required this.distanceValue,
    required this.durationText,
    required this.durationValue,
  });
}

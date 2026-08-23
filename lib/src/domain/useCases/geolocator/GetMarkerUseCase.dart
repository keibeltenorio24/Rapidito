import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';

class GetMarkerUseCase {
  final GeolocatorRepository geolocatorRepository;
  GetMarkerUseCase({required this.geolocatorRepository});
  run(
    String markerId,
    double latitude,
    double longitude,
    String title,
    String content,
    BitmapDescriptor imageMarker,
  ) {
    return geolocatorRepository.getMarker(
      markerId,
      latitude,
      longitude,
      title,
      content,
      imageMarker,
    );
  }
}

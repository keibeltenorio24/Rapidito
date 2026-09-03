import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/domain/models/DirectionData.dart';
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';

class GetPolylineUseCase {
  final GeolocatorRepository geolocatorRepository;

  GetPolylineUseCase({required this.geolocatorRepository});

  Future<DirectionData> run(LatLng origin, LatLng destination) =>
      geolocatorRepository.getPolyline(origin, destination);
}

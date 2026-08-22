import 'package:geolocator/geolocator.dart';
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';

class FindPositionUseCase {
  final GeolocatorRepository geolocatorRepository;

  FindPositionUseCase({required this.geolocatorRepository});

  Future<Position> run() async {
    return await geolocatorRepository.determinePosition();
  }
}

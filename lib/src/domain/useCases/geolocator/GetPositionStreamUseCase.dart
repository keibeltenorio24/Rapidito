import 'package:geolocator/geolocator.dart';
import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';

class GetPositionStreamUseCase {
  final GeolocatorRepository geolocatorRepository;

  GetPositionStreamUseCase({required this.geolocatorRepository});

  Stream<Position> run() {
    return geolocatorRepository.getPositionStream();
  }
}

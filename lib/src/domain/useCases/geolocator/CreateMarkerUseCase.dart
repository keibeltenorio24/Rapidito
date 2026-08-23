import 'package:rapidito/src/domain/repository/GeolocatorRepository.dart';

class CreateMarkerUseCase {
  final GeolocatorRepository geolocatorRepository;
  CreateMarkerUseCase({required this.geolocatorRepository});
  run(String path) => geolocatorRepository.createMarkerFromAsset(path);
}

import 'package:rapidito/src/domain/useCases/geolocator/CreateMarkerUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/FindPositionUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetMarkerUseCase.dart';

class GeolocatorUseCases {
  final FindPositionUseCase findPosition;
  CreateMarkerUseCase createMarker;
  GetMarkerUseCase getMarker;

  GeolocatorUseCases({
    required this.findPosition,
    required this.createMarker,
    required this.getMarker,
  });
}

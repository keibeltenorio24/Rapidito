import 'package:rapidito/src/domain/useCases/geolocator/CreateMarkerUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/FindPositionUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetMarkerUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetPolylineUseCase.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GetPositionStreamUseCase.dart';

class GeolocatorUseCases {
  final FindPositionUseCase findPosition;
  CreateMarkerUseCase createMarker;
  GetMarkerUseCase getMarker;
  GetPolylineUseCase getPolyline;
  GetPositionStreamUseCase getPositionStream;

  GeolocatorUseCases({
    required this.findPosition,
    required this.createMarker,
    required this.getMarker,
    required this.getPolyline,
    required this.getPositionStream,
  });
}

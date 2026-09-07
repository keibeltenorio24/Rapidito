import 'package:rapidito/src/domain/useCases/rides/CreateRideRequestUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/ListenRideRequestsUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/UpdateRideRequestStatusUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/GetRideRequestStreamUseCase.dart';

class RidesUseCases {
  final CreateRideRequestUseCase createRideRequest;
  final ListenRideRequestsUseCase listenRideRequests;
  final UpdateRideRequestStatusUseCase updateRideRequestStatus;
  final GetRideRequestStreamUseCase getRideRequestStream;

  RidesUseCases({
    required this.createRideRequest,
    required this.listenRideRequests,
    required this.updateRideRequestStatus,
    required this.getRideRequestStream,
  });
}

import 'package:rapidito/src/domain/useCases/rides/CreateRideRequestUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/ListenRideRequestsUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/UpdateRideRequestStatusUseCase.dart';

class RidesUseCases {
  final CreateRideRequestUseCase createRideRequest;
  final ListenRideRequestsUseCase listenRideRequests;
  final UpdateRideRequestStatusUseCase updateRideRequestStatus;

  RidesUseCases({
    required this.createRideRequest,
    required this.listenRideRequests,
    required this.updateRideRequestStatus,
  });
}

import 'package:rapidito/src/domain/useCases/rides/CreateRideRequestUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/ListenRideRequestsUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/UpdateRideRequestStatusUseCase.dart';
import 'package:rapidito/src/domain/useCases/rides/GetRideRequestStreamUseCase.dart';

import 'package:rapidito/src/domain/useCases/rides/GetRideHistoryUseCase.dart';

class RidesUseCases {
  final CreateRideRequestUseCase createRideRequest;
  final ListenRideRequestsUseCase listenRideRequests;
  final UpdateRideRequestStatusUseCase updateRideRequestStatus;
  final GetRideRequestStreamUseCase getRideRequestStream;
  final GetRideHistoryUseCase getRideHistory;

  RidesUseCases({
    required this.createRideRequest,
    required this.listenRideRequests,
    required this.updateRideRequestStatus,
    required this.getRideRequestStream,
    required this.getRideHistory,
  });
}

import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';

class CreateRideRequestUseCase {
  final RideRequestRepository repository;

  CreateRideRequestUseCase(this.repository);

  Future<String> run(RideRequest rideRequest) => repository.createRideRequest(rideRequest);
}

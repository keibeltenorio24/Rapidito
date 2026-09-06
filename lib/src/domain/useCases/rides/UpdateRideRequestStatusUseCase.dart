import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';

class UpdateRideRequestStatusUseCase {
  final RideRequestRepository repository;

  UpdateRideRequestStatusUseCase(this.repository);

  Future<void> run(String requestId, String status, String driverId) =>
      repository.updateRideRequestStatus(requestId, status, driverId);
}

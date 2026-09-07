import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';

class GetRideRequestStreamUseCase {
  final RideRequestRepository repository;

  GetRideRequestStreamUseCase(this.repository);

  Stream<RideRequest?> run(String requestId) =>
      repository.getRideRequestStream(requestId);
}

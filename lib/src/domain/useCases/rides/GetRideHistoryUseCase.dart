import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';

class GetRideHistoryUseCase {
  final RideRequestRepository repository;

  GetRideHistoryUseCase(this.repository);

  Future<List<RideRequest>> run(String userId, String role) =>
      repository.getRideHistory(userId, role);
}

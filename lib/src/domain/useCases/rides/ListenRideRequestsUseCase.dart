import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';

class ListenRideRequestsUseCase {
  final RideRequestRepository repository;

  ListenRideRequestsUseCase(this.repository);

  Stream<List<RideRequest>> run() => repository.getActiveRideRequestsStream();
}
